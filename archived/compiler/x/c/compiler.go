//go:build archive

package ccode

import (
	"bytes"
	"fmt"
	"strconv"
	"strings"

	"mochi/parser"
	"mochi/types"
)

var cReserved = map[string]bool{
	"auto": true, "break": true, "case": true, "char": true, "const": true,
	"continue": true, "default": true, "do": true, "double": true, "else": true,
	"enum": true, "extern": true, "float": true, "for": true, "goto": true,
	"if": true, "int": true, "long": true, "register": true, "return": true,
	"short": true, "signed": true, "sizeof": true, "static": true, "struct": true,
	"switch": true, "typedef": true, "union": true, "unsigned": true, "void": true,
	"volatile": true, "while": true,
}

func sanitizeName(name string) string {
	if name == "" {
		return ""
	}
	var b strings.Builder
	for i, r := range name {
		if r == '_' || ('0' <= r && r <= '9' && i > 0) || ('A' <= r && r <= 'Z') || ('a' <= r && r <= 'z') {
			b.WriteRune(r)
		} else {
			b.WriteRune('_')
		}
	}
	s := b.String()
	if s == "" || !((s[0] >= 'A' && s[0] <= 'Z') || (s[0] >= 'a' && s[0] <= 'z') || s[0] == '_') {
		s = "_" + s
	}
	if cReserved[s] {
		s = "_" + s
	}
	// Avoid clashing with standard library functions such as remove()
	switch s {
	case "remove":
		s = "_remove"
	}
	return s
}

type Compiler struct {
	structLits    map[*parser.MapLiteral]types.StructType
	buf           bytes.Buffer
	indent        int
	tmp           int
	env           *types.Env
	lambdas       []string
	needs         map[string]bool
	externs       []string
	externObjects []string
	structs       map[string]bool
	listStructs   map[string]bool
	fetchStructs  map[string]bool
	currentStruct string
	autoType      bool
}

func New(env *types.Env) *Compiler {
	return &Compiler{
		env:           env,
		structLits:    map[*parser.MapLiteral]types.StructType{},
		lambdas:       []string{},
		needs:         map[string]bool{},
		structs:       map[string]bool{},
		listStructs:   map[string]bool{},
		fetchStructs:  map[string]bool{},
		externObjects: []string{},
	}
}

// NewWithAutoType creates a compiler and controls whether variable
// declarations use GCC's __auto_type for type inference.
func NewWithAutoType(env *types.Env, auto bool) *Compiler {
	c := New(env)
	c.autoType = auto
	return c
}

func (c *Compiler) writeln(s string) {
	for i := 0; i < c.indent; i++ {
		c.buf.WriteByte('\t')
	}
	c.buf.WriteString(s)
	c.buf.WriteByte('\n')
}

func (c *Compiler) writeIndent() {
	for i := 0; i < c.indent; i++ {
		c.buf.WriteByte('\t')
	}
}

func (c *Compiler) newTemp() string {
	c.tmp++
	return fmt.Sprintf("_t%d", c.tmp)
}

func (c *Compiler) need(key string) {
	if c.needs == nil {
		c.needs = map[string]bool{}
	}
	c.needs[key] = true
}

func (c *Compiler) has(key string) bool {
	return c.needs[key]
}

func (c *Compiler) cType(t *parser.TypeRef) string {
	if t == nil {
		return "void"
	}
	if t.Fun != nil {
		ret := c.cType(t.Fun.Return)
		params := make([]string, len(t.Fun.Params))
		for i, p := range t.Fun.Params {
			params[i] = c.cType(p)
		}
		return fmt.Sprintf("%s (*)(%s)", ret, strings.Join(params, ", "))
	}
	if t.Simple != nil {
		switch *t.Simple {
		case "int":
			return "int"
		case "float":
			return "double"
		case "bool":
			return "int"
		case "string":
			return "char*"
		default:
			if c.env != nil {
				if _, ok := c.env.GetStruct(*t.Simple); ok {
					return sanitizeName(*t.Simple)
				}
				if _, ok := c.env.GetUnion(*t.Simple); ok {
					return sanitizeName(*t.Simple)
				}
			}
		}
	}
	if t.Generic != nil {
		if t.Generic.Name == "list" {
			if len(t.Generic.Args) == 1 {
				elem := c.cType(t.Generic.Args[0])
				if elem == "int" {
					return "list_int"
				}
				if elem == "double" {
					return "list_float"
				}
				if elem == "char*" {
					return "list_string"
				}
				if elem == "list_int" {
					return "list_list_int"
				}
			}
		}
		if t.Generic.Name == "map" && len(t.Generic.Args) == 2 {
			key := c.cType(t.Generic.Args[0])
			val := c.cType(t.Generic.Args[1])
			if key == "int" && val == "int" {
				return "map_int_bool"
			}
		}
	}
	return "int"
}

func (c *Compiler) compileProgram(prog *parser.Program) ([]byte, error) {
	// forward declarations for user-defined types allow recursive structs
	forwardSet := map[string]bool{}
	var forward []string
	for _, s := range prog.Statements {
		if s.Type != nil {
			name := sanitizeName(s.Type.Name)
			if !forwardSet[name] {
				forwardSet[name] = true
				forward = append(forward, name)
			}
			for _, v := range s.Type.Variants {
				vname := sanitizeName(v.Name)
				if !forwardSet[vname] {
					forwardSet[vname] = true
					forward = append(forward, vname)
				}
			}
		}
	}

	// compile body first to know which helpers are needed
	oldBuf := c.buf
	c.buf = bytes.Buffer{}
	c.externs = nil
	c.lambdas = nil
	for _, s := range prog.Statements {
		if s.Type != nil {
			if err := c.compileTypeDecl(s.Type); err != nil {
				return nil, err
			}
			c.writeln("")
		}
	}
	for _, s := range prog.Statements {
		if s.Import != nil {
			// import statements are ignored in the C backend
			continue
		}
		if s.ExternType != nil {
			name := sanitizeName(s.ExternType.Name)
			c.externs = append(c.externs, fmt.Sprintf("typedef struct %s %s;", name, name))
			if c.env != nil {
				st := types.StructType{Name: s.ExternType.Name, Fields: map[string]types.Type{}, Order: []string{}, Methods: map[string]types.Method{}}
				c.env.SetStruct(s.ExternType.Name, st)
			}
			continue
		}
		if s.Fun != nil {
			if err := c.compileFun(s.Fun); err != nil {
				return nil, err
			}
			c.writeln("")
		} else if s.Test != nil {
			if err := c.compileTestBlock(s.Test); err != nil {
				return nil, err
			}
			c.writeln("")
		} else if s.ExternVar != nil {
			typ := c.cType(s.ExternVar.Type)
			name := sanitizeName(s.ExternVar.Name())
			c.externs = append(c.externs, fmt.Sprintf("extern %s %s;", typ, name))
			if c.env != nil {
				c.env.SetVar(s.ExternVar.Name(), resolveTypeRef(s.ExternVar.Type, c.env), true)
			}
		} else if s.ExternFun != nil {
			ret := c.cType(s.ExternFun.Return)
			params := make([]string, len(s.ExternFun.Params))
			var ptypes []types.Type
			for i, p := range s.ExternFun.Params {
				params[i] = fmt.Sprintf("%s %s", c.cType(p.Type), sanitizeName(p.Name))
				if c.env != nil {
					ptypes = append(ptypes, resolveTypeRef(p.Type, c.env))
				}
			}
			fname := sanitizeName(s.ExternFun.Name())
			c.externs = append(c.externs, fmt.Sprintf("extern %s %s(%s);", ret, fname, strings.Join(params, ", ")))
			if c.env != nil {
				ft := types.FuncType{Params: ptypes, Return: resolveTypeRef(s.ExternFun.Return, c.env)}
				c.env.SetVar(s.ExternFun.Name(), ft, true)
			}
		} else if s.ExternObject != nil {
			name := sanitizeName(s.ExternObject.Name)
			c.externs = append(c.externs, fmt.Sprintf("extern void* %s;", name))
			c.externObjects = append(c.externObjects, name)
			if c.env != nil {
				c.env.SetVar(s.ExternObject.Name, types.AnyType{}, true)
			}
		}
	}
	// main function
	c.writeln("int main() {")
	c.indent++
	for _, name := range c.externObjects {
		c.writeln(fmt.Sprintf("if (%s == NULL) { fprintf(stderr, \"extern object not registered: %s\\n\"); return 1; }", name, name))
	}
	for _, s := range prog.Statements {
		if s.Fun == nil && s.Test == nil {
			if err := c.compileStmt(s); err != nil {
				return nil, err
			}
		}
	}
	for _, s := range prog.Statements {
		if s.Test != nil {
			name := "test_" + sanitizeName(s.Test.Name)
			c.writeln(name + "();")
		}
	}
	c.writeln("return 0;")
	c.indent--
	c.writeln("}")
	body := c.buf.String()
	if len(c.lambdas) > 0 {
		body = strings.Join(c.lambdas, "\n") + "\n" + body
	}
	c.buf = oldBuf

	c.writeln("#include <stdio.h>")
	c.writeln("#include <stdlib.h>")
	if c.has(needStringHeader) || c.has(needConcatString) || c.has(needConcatListString) || c.has(needListString) || c.has(needUnionListString) || c.has(needExceptListString) || c.has(needIntersectListString) || c.has(needInListString) || c.has(needInString) {
		c.writeln("#include <string.h>")
	}
	if c.has(needNow) {
		c.writeln("#include <time.h>")
	}
	c.writeln("")
	c.emitRuntime()
	if c.buf.Len() > 0 && c.buf.Bytes()[c.buf.Len()-1] != '\n' {
		c.writeln("")
	}
	for _, name := range forward {
		c.writeln(fmt.Sprintf("typedef struct %s %s;", name, name))
	}
	if len(forward) > 0 {
		c.writeln("")
	}
	for _, ex := range c.externs {
		c.writeln(ex)
	}
	if len(c.externs) > 0 {
		c.writeln("")
	}
	c.buf.WriteString(body)
	return FormatC(c.buf.Bytes()), nil
}

func (c *Compiler) Compile(prog *parser.Program) ([]byte, error) {
	return c.compileProgram(prog)
}

func (c *Compiler) compileTypeDecl(t *parser.TypeDecl) error {
	name := sanitizeName(t.Name)
	if c.structs[name] {
		return nil
	}
	c.structs[name] = true
	if len(t.Variants) > 0 {
		// compile variant structs
		for _, v := range t.Variants {
			vname := sanitizeName(v.Name)
			c.writeln("typedef struct {")
			c.indent++
			for _, f := range v.Fields {
				typ := c.cType(f.Type)
				c.writeln(fmt.Sprintf("%s %s;", typ, sanitizeName(f.Name)))
			}
			c.indent--
			c.writeln(fmt.Sprintf("}%s;", vname))
		}
		// union wrapper
		c.writeln("typedef struct {")
		c.indent++
		c.writeln("int tag;")
		c.writeln("union {")
		c.indent++
		for _, v := range t.Variants {
			vname := sanitizeName(v.Name)
			c.writeln(fmt.Sprintf("%s %s;", vname, vname))
		}
		c.indent--
		c.writeln("} value;")
		c.indent--
		c.writeln(fmt.Sprintf("}%s;", name))
		if c.env != nil {
			ut := types.UnionType{Name: t.Name, Variants: map[string]types.StructType{}}
			for _, v := range t.Variants {
				fields := map[string]types.Type{}
				order := []string{}
				for _, f := range v.Fields {
					fields[f.Name] = resolveTypeRef(f.Type, c.env)
					order = append(order, f.Name)
				}
				st := types.StructType{Name: v.Name, Fields: fields, Order: order, Methods: map[string]types.Method{}}
				c.env.SetStruct(v.Name, st)
				ut.Variants[v.Name] = st
			}
			c.env.SetUnion(t.Name, ut)
		}
		return nil
	}
	c.writeln("typedef struct {")
	c.indent++
	var fields map[string]types.Type
	var order []string
	if c.env != nil {
		if st, ok := c.env.GetStruct(t.Name); ok {
			fields = st.Fields
			order = st.Order
		} else {
			fields = map[string]types.Type{}
		}
	}
	for _, m := range t.Members {
		if m.Field == nil {
			continue
		}
		typ := c.cType(m.Field.Type)
		c.writeln(fmt.Sprintf("%s %s;", typ, sanitizeName(m.Field.Name)))
		if c.env != nil {
			fields[m.Field.Name] = resolveTypeRef(m.Field.Type, c.env)
			order = append(order, m.Field.Name)
		}
	}
	c.indent--
	c.writeln(fmt.Sprintf("}%s;", name))
	if c.env != nil {
		st := types.StructType{Name: t.Name, Fields: fields, Order: order}
		if orig, ok := c.env.GetStruct(t.Name); ok {
			st.Methods = orig.Methods
		}
		c.env.SetStruct(t.Name, st)
	}
	for _, m := range t.Members {
		if m.Method != nil {
			if err := c.compileTypeMethod(t.Name, m.Method); err != nil {
				return err
			}
			c.writeln("")
		}
	}
	return nil
}

func (c *Compiler) compileFun(fun *parser.FunStmt) error {
	oldEnv := c.env
	var bodyEnv *types.Env
	if c.env != nil {
		bodyEnv = types.NewEnv(c.env)
		for _, p := range fun.Params {
			if p.Type != nil {
				bodyEnv.SetVar(p.Name, resolveTypeRef(p.Type, c.env), true)
			} else {
				bodyEnv.SetVar(p.Name, types.IntType{}, true)
			}
		}
	}
	var retType types.Type
	if fun.Return != nil {
		retType = resolveTypeRef(fun.Return, c.env)
	} else {
		if c.env != nil {
			c.env = bodyEnv
			retType = c.inferFunReturnType(fun.Body)
			c.env = oldEnv
		} else {
			retType = types.VoidType{}
		}
	}
	ret := cTypeFromType(retType)
	c.buf.WriteString(ret + " ")
	c.buf.WriteString(sanitizeName(fun.Name))
	c.buf.WriteByte('(')
	for i, p := range fun.Params {
		if i > 0 {
			c.buf.WriteString(", ")
		}
		c.buf.WriteString(c.cType(p.Type))
		c.buf.WriteByte(' ')
		c.buf.WriteString(sanitizeName(p.Name))
		if p.Type != nil {
			t := resolveTypeRef(p.Type, c.env)
			if isListStringType(t) {
				c.need(needListString)
			}
			if isListFloatType(t) {
				c.need(needListFloat)
			}
			if isListListIntType(t) {
				c.need(needListListInt)
			}
		}
	}
	c.buf.WriteString("){\n")
	c.indent++
	prevEnv := c.env
	if c.env != nil {
		c.env = bodyEnv
	}
	for _, st := range fun.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	if c.env != nil {
		c.env = prevEnv
	}
	c.indent--
	c.writeln("}")
	return nil
}

func (c *Compiler) compileTypeMethod(structName string, fun *parser.FunStmt) error {
	oldEnv := c.env
	var bodyEnv *types.Env
	if c.env != nil {
		bodyEnv = types.NewEnv(c.env)
		if st, ok := oldEnv.GetStruct(structName); ok {
			for name, ft := range st.Fields {
				bodyEnv.SetVar(name, ft, true)
			}
			for name, m := range st.Methods {
				bodyEnv.SetVar(name, m.Type, true)
			}
		}
		for _, p := range fun.Params {
			if p.Type != nil {
				bodyEnv.SetVar(p.Name, resolveTypeRef(p.Type, oldEnv), true)
			} else {
				bodyEnv.SetVar(p.Name, types.IntType{}, true)
			}
		}
	}
	var retType types.Type
	if fun.Return != nil {
		retType = resolveTypeRef(fun.Return, c.env)
	} else {
		if c.env != nil {
			c.env = bodyEnv
			retType = c.inferFunReturnType(fun.Body)
			c.env = oldEnv
		} else {
			retType = types.VoidType{}
		}
	}
	ret := cTypeFromType(retType)
	c.buf.WriteString(ret + " ")
	c.buf.WriteString(sanitizeName(structName) + "_" + sanitizeName(fun.Name))
	c.buf.WriteByte('(')
	c.buf.WriteString(sanitizeName(structName) + "* self")
	for _, p := range fun.Params {
		c.buf.WriteString(", ")
		c.buf.WriteString(c.cType(p.Type))
		c.buf.WriteByte(' ')
		c.buf.WriteString(sanitizeName(p.Name))
	}
	c.buf.WriteString("){\n")
	c.indent++
	prevEnv := c.env
	oldStruct := c.currentStruct
	if c.env != nil {
		c.env = bodyEnv
	}
	c.currentStruct = structName
	for _, st := range fun.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	c.currentStruct = oldStruct
	if c.env != nil {
		c.env = prevEnv
	}
	c.indent--
	c.writeln("}")
	return nil
}

func (c *Compiler) compileStructType(st types.StructType) {
	name := sanitizeName(st.Name)
	if c.structs[name] {
		return
	}
	c.structs[name] = true
	c.writeln("typedef struct {")
	c.indent++
	for _, fn := range st.Order {
		ft := st.Fields[fn]
		c.writeln(fmt.Sprintf("%s %s;", cTypeFromType(ft), sanitizeName(fn)))
	}
	c.indent--
	c.writeln(fmt.Sprintf("}%s;", name))
	c.compileStructListType(st)
	for _, ft := range st.Fields {
		if sub, ok := ft.(types.StructType); ok {
			c.compileStructType(sub)
		}
	}
}

func (c *Compiler) compileStructListType(st types.StructType) {
	listName := "list_" + sanitizeName(st.Name)
	if c.listStructs[listName] {
		return
	}
	c.listStructs[listName] = true
	c.writeln(fmt.Sprintf("typedef struct { int len; %s *data; } %s;", sanitizeName(st.Name), listName))
	c.writeln(fmt.Sprintf("static %s %s_create(int len) {", listName, listName))
	c.indent++
	c.writeln(fmt.Sprintf("%s l;", listName))
	c.writeln("l.len = len;")
	c.writeln(fmt.Sprintf("l.data = (%s*)malloc(sizeof(%s)*len);", sanitizeName(st.Name), sanitizeName(st.Name)))
	c.writeln("return l;")
	c.indent--
	c.writeln("}")
}

func (c *Compiler) emitFetchStructFunc(st types.StructType) string {
	name := "_fetch_" + sanitizeName(st.Name)
	if c.fetchStructs[name] {
		return name
	}
	c.fetchStructs[name] = true
	oldBuf := c.buf
	oldIndent := c.indent
	c.buf = bytes.Buffer{}
	c.indent = 0
	c.writeln(fmt.Sprintf("static %s %s(const char* url, void* opts){", sanitizeName(st.Name), name))
	c.indent++
	c.writeln("map_string row = _fetch(url, opts);")
	c.writeln(fmt.Sprintf("%s out;", sanitizeName(st.Name)))
	for _, fn := range st.Order {
		ft := st.Fields[fn]
		field := sanitizeName(fn)
		switch ft.(type) {
		case types.IntType, types.BoolType:
			c.writeln(fmt.Sprintf("out.%s = atoi(map_string_get(row, \"%s\"));", field, fn))
		case types.FloatType:
			c.writeln(fmt.Sprintf("out.%s = atof(map_string_get(row, \"%s\"));", field, fn))
		case types.StringType:
			c.writeln(fmt.Sprintf("out.%s = strdup(map_string_get(row, \"%s\"));", field, fn))
		default:
			c.writeln(fmt.Sprintf("/* unsupported field %s */", fn))
		}
	}
	c.writeln("return out;")
	c.indent--
	c.writeln("}")
	c.lambdas = append(c.lambdas, c.buf.String())
	c.buf = oldBuf
	c.indent = oldIndent
	return name
}

func (c *Compiler) compileStmt(s *parser.Statement) error {
	switch {
	case s.Fun != nil:
		// Nested function declarations are hoisted to the top level.
		// Compile the body separately and append to the lambdas slice
		// so it appears before `main` like other helpers.
		oldBuf := c.buf
		oldIndent := c.indent
		c.buf = bytes.Buffer{}
		c.indent = 0
		if err := c.compileFun(s.Fun); err != nil {
			c.buf = oldBuf
			c.indent = oldIndent
			return err
		}
		c.lambdas = append(c.lambdas, c.buf.String())
		c.buf = oldBuf
		c.indent = oldIndent
		if c.env != nil {
			var params []types.Type
			for _, p := range s.Fun.Params {
				if p.Type != nil {
					params = append(params, resolveTypeRef(p.Type, c.env))
				} else {
					params = append(params, types.IntType{})
				}
			}
			var ret types.Type
			if s.Fun.Return != nil {
				ret = resolveTypeRef(s.Fun.Return, c.env)
			} else {
				bodyEnv := types.NewEnv(c.env)
				for i, p := range s.Fun.Params {
					bodyEnv.SetVar(p.Name, params[i], true)
				}
				prev := c.env
				c.env = bodyEnv
				ret = c.inferFunReturnType(s.Fun.Body)
				c.env = prev
			}
			if ret == nil {
				ret = types.VoidType{}
			}
			ft := types.FuncType{Params: params, Return: ret}
			c.env.SetVar(s.Fun.Name, ft, true)
		}
		return nil
	case s.Let != nil:
		return c.compileLet(s.Let)
	case s.Var != nil:
		return c.compileVar(s.Var)
	case s.Assign != nil:
		lhs := sanitizeName(s.Assign.Name)
		target := lhs
		if c.currentStruct != "" && c.env != nil && len(s.Assign.Index) == 0 {
			if st, ok := c.env.GetStruct(c.currentStruct); ok {
				if _, ok2 := st.Fields[s.Assign.Name]; ok2 {
					target = "self->" + lhs
				}
			}
		}
		if len(s.Assign.Index) == 1 {
			if c.env != nil {
				if tv, err := c.env.GetVar(s.Assign.Name); err == nil && isMapIntBoolType(tv) {
					key := c.compileExpr(s.Assign.Index[0].Start)
					val := c.compileExpr(s.Assign.Value)
					c.need(needMapIntBool)
					c.writeln(fmt.Sprintf("map_int_bool_put(&%s, %s, %s);", lhs, key, val))
					return nil
				}
			}
		}
		for _, idx := range s.Assign.Index {
			ix := c.compileExpr(idx.Start)
			target = fmt.Sprintf("%s.data[%s]", target, ix)
		}
		val := c.compileExpr(s.Assign.Value)
		c.writeln(fmt.Sprintf("%s = %s;", target, val))
	case s.Return != nil:
		val := c.compileExpr(s.Return.Value)
		c.writeln(fmt.Sprintf("return %s;", val))
	case s.For != nil:
		return c.compileFor(s.For)
	case s.While != nil:
		return c.compileWhile(s.While)
	case s.If != nil:
		return c.compileIf(s.If)
	case s.Expr != nil:
		expr := c.compileExpr(s.Expr.Expr)
		if expr != "" {
			c.writeln(fmt.Sprintf("%s;", expr))
		}
	case s.Expect != nil:
		if err := c.compileExpect(s.Expect); err != nil {
			return err
		}
	case s.Break != nil:
		c.writeln("break;")
	case s.Continue != nil:
		c.writeln("continue;")
	case s.Update != nil:
		return c.compileUpdate(s.Update)
	case s.Import != nil:
		// imports are ignored at code generation time
		return nil
	case s.ExternType != nil:
		// extern type declarations have no runtime effect
		return nil
	case s.ExternObject != nil:
		// extern objects have no runtime effect
		return nil
	default:
		// unsupported
	}
	return nil
}

func (c *Compiler) compileLet(stmt *parser.LetStmt) error {
	name := sanitizeName(stmt.Name)
	var t types.Type
	if stmt.Type != nil {
		t = resolveTypeRef(stmt.Type, c.env)
		if stmt.Value != nil {
			if ll := stmt.Value.Binary.Left.Value.Target.List; ll != nil {
				if st, ok := c.inferStructFromList(ll, stmt.Name); ok {
					t = types.ListType{Elem: st}
					if c.env != nil {
						c.env.SetStruct(st.Name, st)
					}
					c.compileStructType(st)
					c.compileStructListType(st)
					for _, el := range ll.Elems {
						if ml := el.Binary.Left.Value.Target.Map; ml != nil {
							c.structLits[ml] = st
						}
					}
				}
			}
		}
	} else if stmt.Value != nil {
		t = c.exprType(stmt.Value)
		if ll := stmt.Value.Binary.Left.Value.Target.List; ll != nil {
			if st, ok := c.inferStructFromList(ll, stmt.Name); ok {
				t = types.ListType{Elem: st}
				if c.env != nil {
					c.env.SetStruct(st.Name, st)
				}
				c.compileStructType(st)
				c.compileStructListType(st)
				for _, el := range ll.Elems {
					if ml := el.Binary.Left.Value.Target.Map; ml != nil {
						c.structLits[ml] = st
					}
				}
			}
		}
	}
	if t == nil {
		t = types.IntType{}
	}
	typ := cTypeFromType(t)
	if c.autoType && stmt.Type == nil && stmt.Value != nil {
		typ = "__auto_type"
	}
	if stmt.Value != nil && isNowExpr(stmt.Value) {
		typ = "long long"
		if c.env != nil {
			t = types.Int64Type{}
		}
	}
	if stmt.Value != nil && isNowExpr(stmt.Value) {
		typ = "long long"
		if c.env != nil {
			t = types.Int64Type{}
		}
	}
	if stmt.Value != nil {
		if f := asFetchExpr(stmt.Value); f != nil {
			if st, ok := t.(types.StructType); ok {
				c.need(needFetch)
				c.need(needStringHeader)
				c.need(needMapStringGet)
				fname := c.emitFetchStructFunc(st)
				url := c.compileExpr(f.URL)
				opts := "NULL"
				if f.With != nil {
					opts = c.compileExpr(f.With)
				}
				c.writeln(fmt.Sprintf("%s %s = %s(%s, %s);", typ, name, fname, url, opts))
			} else {
				val := c.compileFetchExpr(f)
				c.writeln(formatFuncPtrDecl(typ, name, val))
			}
		} else if isEmptyListLiteral(stmt.Value) {
			if isListStringType(t) {
				c.need(needListString)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_string %s = list_string_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isListFloatType(t) {
				c.need(needListFloat)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_float %s = list_float_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isListListIntType(t) {
				c.need(needListListInt)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_list_int %s = list_list_int_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isListIntType(t) {
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_int %s = list_int_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isMapIntBoolType(t) && isEmptyMapLiteral(stmt.Value) {
				c.need(needMapIntBool)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("map_int_bool %s = map_int_bool_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else {
				val := c.compileExpr(stmt.Value)
				c.writeln(formatFuncPtrDecl(typ, name, val))
			}
		} else {
			val := c.compileExpr(stmt.Value)
			c.writeln(formatFuncPtrDecl(typ, name, val))
		}
	} else {
		decl := formatFuncPtrDecl(typ, name, "")
		if strings.HasSuffix(decl, " = ;") { // remove "= ;" when no value
			decl = strings.TrimSuffix(decl, " = ;") + ";"
		}
		c.writeln(decl)
	}
	if c.env != nil {
		c.env.SetVar(stmt.Name, t, false)
	}
	return nil
}

func (c *Compiler) compileVar(stmt *parser.VarStmt) error {
	name := sanitizeName(stmt.Name)
	var t types.Type
	if stmt.Type != nil {
		t = resolveTypeRef(stmt.Type, c.env)
		if stmt.Value != nil {
			if ll := stmt.Value.Binary.Left.Value.Target.List; ll != nil {
				if st, ok := c.inferStructFromList(ll, stmt.Name); ok {
					t = types.ListType{Elem: st}
					if c.env != nil {
						c.env.SetStruct(st.Name, st)
					}
					c.compileStructType(st)
					c.compileStructListType(st)
					for _, el := range ll.Elems {
						if ml := el.Binary.Left.Value.Target.Map; ml != nil {
							c.structLits[ml] = st
						}
					}
				}
			}
		}
	} else if stmt.Value != nil {
		t = c.exprType(stmt.Value)
		if ll := stmt.Value.Binary.Left.Value.Target.List; ll != nil {
			if st, ok := c.inferStructFromList(ll, stmt.Name); ok {
				t = types.ListType{Elem: st}
				if c.env != nil {
					c.env.SetStruct(st.Name, st)
				}
				c.compileStructType(st)
				c.compileStructListType(st)
				for _, el := range ll.Elems {
					if ml := el.Binary.Left.Value.Target.Map; ml != nil {
						c.structLits[ml] = st
					}
				}
			}
		}
	}
	if t == nil {
		t = types.IntType{}
	}
	typ := cTypeFromType(t)
	if c.autoType && stmt.Type == nil && stmt.Value != nil {
		typ = "__auto_type"
	}
	if stmt.Value != nil {
		if f := asFetchExpr(stmt.Value); f != nil {
			if st, ok := t.(types.StructType); ok {
				c.need(needFetch)
				c.need(needStringHeader)
				c.need(needMapStringGet)
				fname := c.emitFetchStructFunc(st)
				url := c.compileExpr(f.URL)
				opts := "NULL"
				if f.With != nil {
					opts = c.compileExpr(f.With)
				}
				c.writeln(fmt.Sprintf("%s %s = %s(%s, %s);", typ, name, fname, url, opts))
			} else {
				val := c.compileFetchExpr(f)
				c.writeln(formatFuncPtrDecl(typ, name, val))
			}
		} else if isEmptyListLiteral(stmt.Value) {
			if isListStringType(t) {
				c.need(needListString)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_string %s = list_string_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isListFloatType(t) {
				c.need(needListFloat)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_float %s = list_float_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isListListIntType(t) {
				c.need(needListListInt)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_list_int %s = list_list_int_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isListIntType(t) {
				val := c.newTemp()
				c.writeln(fmt.Sprintf("list_int %s = list_int_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else if isMapIntBoolType(t) && isEmptyMapLiteral(stmt.Value) {
				c.need(needMapIntBool)
				val := c.newTemp()
				c.writeln(fmt.Sprintf("map_int_bool %s = map_int_bool_create(0);", val))
				c.writeln(formatFuncPtrDecl(typ, name, val))
			} else {
				val := c.compileExpr(stmt.Value)
				c.writeln(formatFuncPtrDecl(typ, name, val))
			}
		} else {
			val := c.compileExpr(stmt.Value)
			c.writeln(formatFuncPtrDecl(typ, name, val))
		}
	} else {
		c.writeln(fmt.Sprintf("%s %s;", typ, name))
	}
	if c.env != nil {
		c.env.SetVar(stmt.Name, t, true)
	}
	return nil
}

func (c *Compiler) compileFor(f *parser.ForStmt) error {
	name := sanitizeName(f.Name)
	useVar := f.Name != "_"
	if f.RangeEnd != nil {
		start := c.compileExpr(f.Source)
		end := c.compileExpr(f.RangeEnd)
		loopVar := name
		if !useVar {
			loopVar = c.newTemp()
		}
		c.writeln(fmt.Sprintf("for (int %s = %s; %s < %s; %s++) {", loopVar, start, loopVar, end, loopVar))
		if useVar && loopVar != name {
			c.indent++
			c.writeln(fmt.Sprintf("int %s = %s;", name, loopVar))
		} else {
			c.indent++
		}
	} else {
		src := c.compileExpr(f.Source)
		idx := c.newTemp()
		isStr := isStringExpr(f.Source, c.env)
		isListStr := isListStringExpr(f.Source, c.env)
		if isStr {
			c.writeln(fmt.Sprintf("for (int %s = 0; %s[%s] != '\\0'; %s++) {", idx, src, idx, idx))
			c.indent++
			if useVar {
				c.writeln(fmt.Sprintf("char %s[2];", name))
				c.writeln(fmt.Sprintf("%s[0] = %s[%s];", name, src, idx))
				c.writeln(fmt.Sprintf("%s[1] = '\\0';", name))
			}
		} else if isListStr {
			c.writeln(fmt.Sprintf("for (int %s = 0; %s < %s.len; %s++) {", idx, idx, src, idx))
			c.indent++
			if useVar {
				c.writeln(fmt.Sprintf("char* %s = %s.data[%s];", name, src, idx))
			}
		} else {
			c.writeln(fmt.Sprintf("for (int %s = 0; %s < %s.len; %s++) {", idx, idx, src, idx))
			c.indent++
			if useVar {
				c.writeln(fmt.Sprintf("int %s = %s.data[%s];", name, src, idx))
			}
		}
		oldEnv := c.env
		if c.env != nil {
			c.env = types.NewEnv(c.env)
			if useVar {
				if isStr {
					c.env.SetVar(f.Name, types.StringType{}, true)
				} else if isListStr {
					c.env.SetVar(f.Name, types.StringType{}, true)
				} else {
					c.env.SetVar(f.Name, types.IntType{}, true)
				}
			}
		}
		for _, st := range f.Body {
			if err := c.compileStmt(st); err != nil {
				return err
			}
		}
		if c.env != nil {
			c.env = oldEnv
		}
		c.indent--
		c.writeln("}")
		return nil
	}
	oldEnv := c.env
	if c.env != nil {
		c.env = types.NewEnv(c.env)
		if useVar {
			c.env.SetVar(f.Name, types.IntType{}, true)
		}
	}
	for _, st := range f.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	if c.env != nil {
		c.env = oldEnv
	}
	c.indent--
	c.writeln("}")
	return nil
}

func (c *Compiler) compileIf(stmt *parser.IfStmt) error {
	cond := c.compileExpr(stmt.Cond)
	c.writeln(fmt.Sprintf("if (%s) {", cond))
	c.indent++
	for _, st := range stmt.Then {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	c.indent--
	if stmt.ElseIf != nil {
		c.writeIndent()
		c.buf.WriteString("} else ")
		return c.compileIf(stmt.ElseIf)
	}
	if len(stmt.Else) > 0 {
		c.writeln("} else {")
		c.indent++
		for _, st := range stmt.Else {
			if err := c.compileStmt(st); err != nil {
				return err
			}
		}
		c.indent--
		c.writeln("}")
		return nil
	}
	c.writeln("}")
	return nil
}

func (c *Compiler) compileWhile(w *parser.WhileStmt) error {
	cond := c.compileExpr(w.Cond)
	c.writeln(fmt.Sprintf("while (%s) {", cond))
	c.indent++
	for _, st := range w.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	c.indent--
	c.writeln("}")
	return nil
}

func (c *Compiler) compileUpdate(u *parser.UpdateStmt) error {
	list := sanitizeName(u.Target)
	var elemType types.Type
	if c.env != nil {
		if v, err := c.env.GetVar(u.Target); err == nil {
			if lt, ok := v.(types.ListType); ok {
				elemType = lt.Elem
			}
		}
	}
	elemC := cTypeFromType(elemType)
	if elemC == "" {
		elemC = "int"
	}
	idx := c.newTemp()
	c.writeln(fmt.Sprintf("for (int %s = 0; %s < %s.len; %s++) {", idx, idx, list, idx))
	c.indent++
	item := c.newTemp()
	c.writeln(fmt.Sprintf("%s %s = %s.data[%s];", elemC, item, list, idx))
	oldStruct := c.currentStruct
	origEnv := c.env
	if st, ok := elemType.(types.StructType); ok {
		c.currentStruct = st.Name
		c.compileStructType(st)
		if c.env != nil {
			child := types.NewEnv(c.env)
			for _, f := range st.Order {
				ft := st.Fields[f]
				c.writeln(fmt.Sprintf("%s %s = %s.%s;", cTypeFromType(ft), sanitizeName(f), item, sanitizeName(f)))
				child.SetVar(f, ft, true)
			}
			c.env = child
		}
	}
	var cond string
	if u.Where != nil {
		cond = c.compileExpr(u.Where)
		cond = strings.ReplaceAll(cond, "self->", item+".")
		c.writeln(fmt.Sprintf("if (%s) {", cond))
		c.indent++
	}
	for _, it := range u.Set.Items {
		key, _ := identName(it.Key)
		if key == "" {
			key, _ = types.SimpleStringKey(it.Key)
		}
		val := c.compileExpr(it.Value)
		val = strings.ReplaceAll(val, "self->", item+".")
		c.writeln(fmt.Sprintf("%s.%s = %s;", item, sanitizeName(key), val))
	}
	if u.Where != nil {
		c.indent--
		c.writeln("}")
	}
	c.writeln(fmt.Sprintf("%s.data[%s] = %s;", list, idx, item))
	if origEnv != nil {
		c.env = origEnv
	}
	c.currentStruct = oldStruct
	c.indent--
	c.writeln("}")
	return nil
}

func (c *Compiler) compileExpect(e *parser.ExpectStmt) error {
	cond := c.compileExpr(e.Value)
	c.writeln(fmt.Sprintf("if (!(%s)) { fprintf(stderr, \"expect failed\\n\"); exit(1); }", cond))
	return nil
}

func (c *Compiler) compileIfExpr(e *parser.IfExpr) string {
	cond := c.compileExpr(e.Cond)
	thenVal := c.compileExpr(e.Then)
	elseVal := "0"
	if e.ElseIf != nil {
		elseVal = c.compileIfExpr(e.ElseIf)
	} else if e.Else != nil {
		elseVal = c.compileExpr(e.Else)
	}
	return fmt.Sprintf("(%s ? %s : %s)", cond, thenVal, elseVal)
}

func (c *Compiler) compileMatchExpr(m *parser.MatchExpr) string {
	target := c.compileExpr(m.Target)
	expr := "0"
	for i := len(m.Cases) - 1; i >= 0; i-- {
		pat := c.compileExpr(m.Cases[i].Pattern)
		res := c.compileExpr(m.Cases[i].Result)
		if pat == "_" {
			expr = res
		} else {
			expr = fmt.Sprintf("(%s == %s ? %s : %s)", target, pat, res, expr)
		}
	}
	return expr
}

func (c *Compiler) compileLoadExpr(l *parser.LoadExpr) string {
	path := "\"\""
	if l.Path != nil {
		path = fmt.Sprintf("%q", *l.Path)
	}
	c.need(needLoadJSON)
	c.need(needStringHeader)
	return fmt.Sprintf("_load_json(%s)", path)
}

func (c *Compiler) compileSaveExpr(s *parser.SaveExpr) string {
	src := c.compileExpr(s.Src)
	path := "\"\""
	if s.Path != nil {
		path = fmt.Sprintf("%q", *s.Path)
	}
	c.need(needSaveJSON)
	c.need(needStringHeader)
	return fmt.Sprintf("_save_json(%s, %s)", src, path)
}

func (c *Compiler) compileFetchExpr(f *parser.FetchExpr) string {
	url := c.compileExpr(f.URL)
	opts := "NULL"
	if f.With != nil {
		opts = c.compileExpr(f.With)
	}
	c.need(needFetch)
	c.need(needStringHeader)
	return fmt.Sprintf("_fetch(%s, %s)", url, opts)
}

func (c *Compiler) compileFunExpr(fn *parser.FunExpr) string {
	name := fmt.Sprintf("_lambda%d", len(c.lambdas))
	oldBuf := c.buf
	oldIndent := c.indent
	c.buf = bytes.Buffer{}
	c.indent = 0
	var body []*parser.Statement
	if fn.ExprBody != nil {
		body = []*parser.Statement{{Return: &parser.ReturnStmt{Value: fn.ExprBody}}}
	} else {
		body = fn.BlockBody
	}
	fs := &parser.FunStmt{Name: name, Params: fn.Params, Return: fn.Return, Body: body}
	if err := c.compileFun(fs); err != nil {
		c.buf = oldBuf
		c.indent = oldIndent
		return "0"
	}
	code := c.buf.String()
	c.lambdas = append(c.lambdas, code)
	c.buf = oldBuf
	c.indent = oldIndent
	return name
}

// compileQueryExpr generates C code for simple dataset queries. It now
// supports optional `sort by`, `skip` and `take` clauses in addition to basic
// `from`/`where`/`select`. Joins and grouping remain unimplemented.
func (c *Compiler) compileQueryExpr(q *parser.QueryExpr) string {
	if q.Group != nil && len(q.Froms) == 0 && len(q.Joins) == 0 && q.Where == nil && q.Sort == nil && q.Skip == nil && q.Take == nil {
		if name, ok := identName(q.Group.Exprs[0]); ok && name == q.Var {
			src := c.compileExpr(q.Source)
			srcT := c.exprType(q.Source)
			if lt, ok := srcT.(types.ListType); ok {
				if _, ok := lt.Elem.(types.IntType); ok {
					c.need(needGroupByInt)
					groups := c.newTemp()
					c.writeln(fmt.Sprintf("list_group_int %s = _group_by_int(%s);", groups, src))
					oldEnv := c.env
					if c.env != nil {
						genv := types.NewEnv(c.env)
						genv.SetVar(q.Group.Name, types.GroupType{Elem: lt.Elem}, true)
						c.env = genv
					}
					val := c.compileExpr(q.Select)
					retT := c.exprType(q.Select)
					retList := types.ListType{Elem: retT}
					listC := cTypeFromType(retList)
					if listC == "list_string" {
						c.need(needListString)
					} else if listC == "list_float" {
						c.need(needListFloat)
					} else if listC == "list_list_int" {
						c.need(needListListInt)
					}
					res := c.newTemp()
					idx := c.newTemp()
					c.writeln(fmt.Sprintf("%s %s = %s_create(%s.len);", listC, res, listC, groups))
					c.writeln(fmt.Sprintf("int %s = 0;", idx))
					c.writeln(fmt.Sprintf("for (int i=0; i<%s.len; i++) {", groups))
					c.indent++
					c.writeln(fmt.Sprintf("_GroupInt %s = %s.data[i];", sanitizeName(q.Group.Name), groups))
					c.writeln(fmt.Sprintf("%s.data[%s] = %s;", res, idx, val))
					c.writeln(fmt.Sprintf("%s++;", idx))
					c.indent--
					c.writeln("}")
					c.writeln(fmt.Sprintf("%s.len = %s;", res, idx))
					if c.env != nil {
						c.env = oldEnv
					}
					return res
				}
			}
		}
	}
	// only handle simple queries without joins or grouping
	if len(q.Froms) > 0 || len(q.Joins) > 0 || q.Group != nil {
		return "0"
	}

	src := c.compileExpr(q.Source)
	srcT := c.exprType(q.Source)
	lt, ok := srcT.(types.ListType)
	if !ok {
		return "0"
	}

	elemType := lt.Elem
	elemC := cTypeFromType(elemType)
	oldEnv := c.env
	if c.env != nil {
		c.env = types.NewEnv(c.env)
		c.env.SetVar(q.Var, elemType, true)
	}
	var cond string
	if q.Where != nil {
		cond = c.compileExpr(q.Where)
	}

	var sortExpr string
	var sortT types.Type
	if q.Sort != nil {
		sortExpr = c.compileExpr(q.Sort)
		sortT = c.exprType(q.Sort)
	}

	var skipExpr string
	if q.Skip != nil {
		skipExpr = c.compileExpr(q.Skip)
	} else {
		skipExpr = "0"
	}

	var takeExpr string
	if q.Take != nil {
		takeExpr = c.compileExpr(q.Take)
	} else {
		takeExpr = "-1"
	}

	val := c.compileExpr(q.Select)
	retT := c.exprType(q.Select)
	retList := types.ListType{Elem: retT}
	listC := cTypeFromType(retList)
	if listC == "" {
		listC = "list_int"
	}
	if listC == "list_string" {
		c.need(needListString)
	} else if listC == "list_float" {
		c.need(needListFloat)
	} else if listC == "list_list_int" {
		c.need(needListListInt)
	}

	res := c.newTemp()
	idx := c.newTemp()
	iter := c.newTemp()
	var keyArr string
	keyType := ""
	if sortExpr != "" {
		keyType = cTypeFromType(sortT)
		if keyType == "" {
			keyType = "int"
		}
	}
	c.writeln(fmt.Sprintf("%s %s = %s_create(%s.len);", listC, res, listC, src))
	if keyType != "" {
		keyArr = c.newTemp()
		c.writeln(fmt.Sprintf("%s *%s = (%s*)malloc(sizeof(%s)*%s.len);", keyType, keyArr, keyType, keyType, src))
	}
	hasLimit := q.Skip != nil || q.Take != nil
	skipVar := ""
	takeVar := ""
	seenVar := ""
	c.writeln(fmt.Sprintf("int %s = 0;", idx))
	if hasLimit {
		skipVar = c.newTemp()
		takeVar = c.newTemp()
		seenVar = c.newTemp()
		c.writeln(fmt.Sprintf("int %s = %s;", skipVar, skipExpr))
		c.writeln(fmt.Sprintf("int %s = %s;", takeVar, takeExpr))
		c.writeln(fmt.Sprintf("int %s = 0;", seenVar))
	}
	c.writeln(fmt.Sprintf("for (int %s = 0; %s < %s.len; %s++) {", iter, iter, src, iter))
	c.indent++
	c.writeln(fmt.Sprintf("%s %s = %s.data[%s];", elemC, sanitizeName(q.Var), src, iter))
	if cond != "" {
		c.writeln(fmt.Sprintf("if (!(%s)) { continue; }", cond))
	}
	if hasLimit {
		c.writeln(fmt.Sprintf("if (%s < %s) { %s++; continue; }", seenVar, skipVar, seenVar))
		c.writeln(fmt.Sprintf("if (%s >= 0 && %s >= %s) { break; }", takeVar, idx, takeVar))
		c.writeln(fmt.Sprintf("%s++;", seenVar))
	}
	c.writeln(fmt.Sprintf("%s.data[%s] = %s;", res, idx, val))
	if keyType != "" {
		c.writeln(fmt.Sprintf("%s[%s] = %s;", keyArr, idx, sortExpr))
	}
	c.writeln(fmt.Sprintf("%s++;", idx))
	c.indent--
	c.writeln("}")
	c.writeln(fmt.Sprintf("%s.len = %s;", res, idx))
	if c.env != nil {
		c.env = oldEnv
	}
	if keyType != "" {
		tmpK := c.newTemp()
		tmpV := c.newTemp()
		elemOut := cTypeFromType(retT)
		if elemOut == "" {
			elemOut = "int"
		}
		c.writeln(fmt.Sprintf("for (int i = 0; i < %s-1; i++) {", idx))
		c.indent++
		c.writeln(fmt.Sprintf("for (int j = i+1; j < %s; j++) {", idx))
		c.indent++
		if keyType == "char*" {
			c.writeln(fmt.Sprintf("if (strcmp(%s[i], %s[j]) > 0) {", keyArr, keyArr))
		} else {
			c.writeln(fmt.Sprintf("if (%s[i] > %s[j]) {", keyArr, keyArr))
		}
		c.indent++
		c.writeln(fmt.Sprintf("%s %s = %s[i];", keyType, tmpK, keyArr))
		c.writeln(fmt.Sprintf("%s[i] = %s[j];", keyArr, keyArr))
		c.writeln(fmt.Sprintf("%s[j] = %s;", keyArr, tmpK))
		c.writeln(fmt.Sprintf("%s %s = %s.data[i];", elemOut, tmpV, res))
		c.writeln(fmt.Sprintf("%s.data[i] = %s.data[j];", res, res))
		c.writeln(fmt.Sprintf("%s.data[j] = %s;", res, tmpV))
		c.indent--
		c.writeln("}")
		c.indent--
		c.writeln("}")
	}
	return res
}

func (c *Compiler) compileTestBlock(t *parser.TestBlock) error {
	name := "test_" + sanitizeName(t.Name)
	c.writeln("static void " + name + "() {")
	c.indent++
	for _, st := range t.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	c.indent--
	c.writeln("}")
	return nil
}

func (c *Compiler) compileExpr(e *parser.Expr) string {
	if e == nil {
		return ""
	}
	res := c.compileBinary(e.Binary)
	return res
}

func (c *Compiler) compileBinary(b *parser.BinaryExpr) string {
	left := c.compileUnary(b.Left)
	leftList := isListListUnary(b.Left, c.env)
	leftListInt := isListIntUnary(b.Left, c.env)
	leftListFloat := isListFloatUnary(b.Left, c.env)
	leftListString := isListStringUnary(b.Left, c.env)
	leftString := isStringUnary(b.Left, c.env)
	for _, op := range b.Right {
		right := c.compilePostfix(op.Right)
		if (op.Op == "+" || (op.Op == "union" && op.All)) && leftList && isListListPostfix(op.Right, c.env) {
			c.need(needConcatListListInt)
			c.need(needListListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_list_int %s = concat_list_list_int(%s, %s);", name, left, right))
			left = name
			leftList = true
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if (op.Op == "+" || (op.Op == "union" && op.All)) && leftListInt && isListIntPostfix(op.Right, c.env) {
			c.need(needConcatListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_int %s = concat_list_int(%s, %s);", name, left, right))
			left = name
			leftListInt = true
			leftList = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if (op.Op == "+" || (op.Op == "union" && op.All)) && leftListFloat && isListFloatPostfix(op.Right, c.env) {
			c.need(needConcatListFloat)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_float %s = concat_list_float(%s, %s);", name, left, right))
			left = name
			leftListFloat = true
			leftList = false
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if (op.Op == "+" || (op.Op == "union" && op.All)) && leftListString && isListStringPostfix(op.Right, c.env) {
			c.need(needConcatListString)
			c.need(needListString)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_string %s = concat_list_string(%s, %s);", name, left, right))
			left = name
			leftListString = true
			leftList = false
			leftListInt = false
			leftString = false
			continue
		}
		if (op.Op == "+" || (op.Op == "union" && op.All)) && leftString && isStringPostfixOrIndex(op.Right, c.env) {
			c.need(needConcatString)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("char* %s = concat_string(%s, %s);", name, left, right))
			left = name
			leftString = true
			leftList = false
			leftListInt = false
			leftListString = false
			continue
		}
		if op.Op == "union" && leftListInt && isListIntPostfix(op.Right, c.env) {
			c.need(needUnionListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_int %s = union_list_int(%s, %s);", name, left, right))
			left = name
			leftListInt = true
			leftList = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "union" && leftListFloat && isListFloatPostfix(op.Right, c.env) {
			c.need(needUnionListFloat)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_float %s = union_list_float(%s, %s);", name, left, right))
			left = name
			leftListFloat = true
			leftList = false
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "union" && leftListString && isListStringPostfix(op.Right, c.env) {
			c.need(needUnionListString)
			c.need(needListString)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_string %s = union_list_string(%s, %s);", name, left, right))
			left = name
			leftListString = true
			leftList = false
			leftListInt = false
			leftString = false
			continue
		}
		if op.Op == "union" && leftList && isListListPostfix(op.Right, c.env) {
			c.need(needUnionListListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_list_int %s = union_list_list_int(%s, %s);", name, left, right))
			left = name
			leftList = true
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "except" && leftListInt && isListIntPostfix(op.Right, c.env) {
			c.need(needExceptListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_int %s = except_list_int(%s, %s);", name, left, right))
			left = name
			leftListInt = true
			leftList = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "except" && leftListFloat && isListFloatPostfix(op.Right, c.env) {
			c.need(needExceptListFloat)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_float %s = except_list_float(%s, %s);", name, left, right))
			left = name
			leftListFloat = true
			leftList = false
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "except" && leftListString && isListStringPostfix(op.Right, c.env) {
			c.need(needExceptListString)
			c.need(needListString)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_string %s = except_list_string(%s, %s);", name, left, right))
			left = name
			leftListString = true
			leftList = false
			leftListInt = false
			leftString = false
			continue
		}
		if op.Op == "except" && leftList && isListListPostfix(op.Right, c.env) {
			c.need(needExceptListListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_list_int %s = except_list_list_int(%s, %s);", name, left, right))
			left = name
			leftList = true
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "intersect" && leftListInt && isListIntPostfix(op.Right, c.env) {
			c.need(needIntersectListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_int %s = intersect_list_int(%s, %s);", name, left, right))
			left = name
			leftListInt = true
			leftList = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "intersect" && leftListString && isListStringPostfix(op.Right, c.env) {
			c.need(needIntersectListString)
			c.need(needListString)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_string %s = intersect_list_string(%s, %s);", name, left, right))
			left = name
			leftListString = true
			leftList = false
			leftListInt = false
			leftString = false
			continue
		}
		if op.Op == "intersect" && leftListFloat && isListFloatPostfix(op.Right, c.env) {
			c.need(needIntersectListFloat)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_float %s = intersect_list_float(%s, %s);", name, left, right))
			left = name
			leftListFloat = true
			leftList = false
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "intersect" && leftList && isListListPostfix(op.Right, c.env) {
			c.need(needIntersectListListInt)
			name := c.newTemp()
			c.writeln(fmt.Sprintf("list_list_int %s = intersect_list_list_int(%s, %s);", name, left, right))
			left = name
			leftList = true
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "in" && isListIntPostfix(op.Right, c.env) {
			c.need(needInListInt)
			left = fmt.Sprintf("contains_list_int(%s, %s)", right, left)
			leftList = false
			leftListInt = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "in" && isListStringPostfix(op.Right, c.env) {
			c.need(needInListString)
			c.need(needListString)
			left = fmt.Sprintf("contains_list_string(%s, %s)", right, left)
			leftList = false
			leftListInt = false
			leftListString = false
			leftString = false
			continue
		}
		if op.Op == "in" && isListFloatPostfix(op.Right, c.env) {
			c.need(needInListFloat)
			left = fmt.Sprintf("contains_list_float(%s, %s)", right, left)
			leftList = false
			leftListInt = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "in" && isListListPostfix(op.Right, c.env) {
			c.need(needInListListInt)
			left = fmt.Sprintf("contains_list_list_int(%s, %s)", right, left)
			leftList = false
			leftListInt = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "in" && isMapIntBoolPostfix(op.Right, c.env) {
			c.need(needInMapIntBool)
			left = fmt.Sprintf("map_int_bool_contains(%s, %s)", right, left)
			leftList = false
			leftListInt = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if op.Op == "in" && leftString && isStringPostfixOrIndex(op.Right, c.env) {
			c.need(needInString)
			left = fmt.Sprintf("contains_string(%s, %s)", right, left)
			leftList = false
			leftListInt = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		if (op.Op == "==" || op.Op == "!=" || op.Op == "<" || op.Op == ">" || op.Op == "<=" || op.Op == ">=") && leftString && isStringPostfixOrIndex(op.Right, c.env) {
			c.need(needStringHeader)
			cmp := fmt.Sprintf("strcmp(%s, %s)", left, right)
			switch op.Op {
			case "==":
				left = fmt.Sprintf("(%s == 0)", cmp)
			case "!=":
				left = fmt.Sprintf("(%s != 0)", cmp)
			case "<":
				left = fmt.Sprintf("(%s < 0)", cmp)
			case ">":
				left = fmt.Sprintf("(%s > 0)", cmp)
			case "<=":
				left = fmt.Sprintf("(%s <= 0)", cmp)
			case ">=":
				left = fmt.Sprintf("(%s >= 0)", cmp)
			}
			leftList = false
			leftListInt = false
			leftListString = false
			leftListFloat = false
			leftString = false
			continue
		}
		left = fmt.Sprintf("(%s %s %s)", left, op.Op, right)
		leftList = false
		leftListInt = false
		leftListString = false
		leftListFloat = false
		leftString = false
	}
	return left
}

func (c *Compiler) compileUnary(u *parser.Unary) string {
	expr := c.compilePostfix(u.Value)
	for i := len(u.Ops) - 1; i >= 0; i-- {
		op := u.Ops[i]
		if op == "-" {
			expr = fmt.Sprintf("(-%s)", expr)
		} else if op == "!" {
			expr = fmt.Sprintf("(!%s)", expr)
		}
	}
	return expr
}

func (c *Compiler) compilePostfix(p *parser.PostfixExpr) string {
	expr := c.compilePrimary(p.Target)
	isStr := isStringPrimary(p.Target, c.env)
	isFloatList := isListFloatPrimary(p.Target, c.env)
	isStringList := isListStringPrimary(p.Target, c.env)
	for _, op := range p.Ops {
		if op.Index != nil {
			if op.Index.Colon == nil {
				idx := c.compileExpr(op.Index.Start)
				if isStr && op.Index.End == nil {
					name := c.newTemp()
					c.need(needStringHeader)
					c.writeln(fmt.Sprintf("char* %s = ({ int _len = strlen(%s); int _i = %s; if (_i < 0) _i += _len; if (_i < 0 || _i >= _len) { fprintf(stderr, \"index out of range\\n\"); exit(1); } char* _b = (char*)malloc(2); _b[0] = %s[_i]; _b[1] = '\\0'; _b; });", name, expr, idx, expr))
					if c.env != nil {
						c.env.SetVar(name, types.StringType{}, true)
					}
					expr = name
					isStr = true
				} else {
					expr = fmt.Sprintf("%s.data[%s]", expr, idx)
					if isStringList {
						isStr = true
					} else {
						isStr = false
					}
					isFloatList = false
					isStringList = false
				}
			} else {
				start := "0"
				if op.Index.Start != nil {
					start = c.compileExpr(op.Index.Start)
				}
				end := fmt.Sprintf("%s.len", expr)
				if op.Index.End != nil {
					end = c.compileExpr(op.Index.End)
				}
				name := c.newTemp()
				if isStr {
					c.need(needStringHeader)
					c.writeln(fmt.Sprintf("char* %s = ({ int _len = strlen(%s); int _s = %s; int _e = %s; if (_s < 0) _s += _len; if (_e < 0) _e += _len; if (_s < 0) _s = 0; if (_e > _len) _e = _len; if (_s > _e) _s = _e; char* _b = (char*)malloc(_e - _s + 1); memcpy(_b, %s + _s, _e - _s); _b[_e - _s] = '\\0'; _b; });", name, expr, start, end, expr))
					if c.env != nil {
						c.env.SetVar(name, types.StringType{}, true)
					}
					expr = name
					isStr = true
				} else if isFloatList {
					c.need(needSliceListFloat)
					c.writeln(fmt.Sprintf("list_float %s = slice_list_float(%s, %s, %s);", name, expr, start, end))
					if c.env != nil {
						c.env.SetVar(name, types.ListType{Elem: types.FloatType{}}, true)
					}
					expr = name
					isStr = false
					isFloatList = false
					isStringList = false
				} else if isStringList {
					c.need(needSliceListString)
					c.need(needListString)
					c.writeln(fmt.Sprintf("list_string %s = slice_list_string(%s, %s, %s);", name, expr, start, end))
					if c.env != nil {
						c.env.SetVar(name, types.ListType{Elem: types.StringType{}}, true)
					}
					expr = name
					isStr = false
					isFloatList = false
					isStringList = false
				} else {
					c.need(needSliceListInt)
					c.writeln(fmt.Sprintf("list_int %s = slice_list_int(%s, %s, %s);", name, expr, start, end))
					if c.env != nil {
						c.env.SetVar(name, types.ListType{Elem: types.IntType{}}, true)
					}
					expr = name
					isStr = false
					isFloatList = false
					isStringList = false
				}
			}
		} else if op.Call != nil {
			if p.Target != nil && p.Target.Selector != nil && c.env != nil {
				sel := p.Target.Selector
				if len(sel.Tail) > 0 {
					baseSel := &parser.SelectorExpr{Root: sel.Root, Tail: sel.Tail[:len(sel.Tail)-1]}
					meth := sel.Tail[len(sel.Tail)-1]
					stype, ok := c.selectorStructType(baseSel)
					if ok {
						if _, ok2 := stype.Methods[meth]; ok2 {
							recv := c.compileSelector(baseSel)
							args := make([]string, len(op.Call.Args)+1)
							args[0] = "&" + recv
							for i, a := range op.Call.Args {
								args[i+1] = c.compileExpr(a)
							}
							expr = fmt.Sprintf("%s_%s(%s)", sanitizeName(stype.Name), sanitizeName(meth), strings.Join(args, ", "))
							isStr = false
							isFloatList = false
							isStringList = false
							continue
						}
					}
				}
			}
			args := make([]string, len(op.Call.Args))
			for i, a := range op.Call.Args {
				args[i] = c.compileExpr(a)
			}
			expr = fmt.Sprintf("%s(%s)", expr, strings.Join(args, ", "))
			isStr = false
			isFloatList = false
			isStringList = false
		}
	}
	return expr
}

func (c *Compiler) compilePrimary(p *parser.Primary) string {
	switch {
	case p.Lit != nil:
		return c.compileLiteral(p.Lit)
	case p.Selector != nil:
		return c.compileSelector(p.Selector)
	case p.Struct != nil:
		parts := make([]string, len(p.Struct.Fields))
		for i, f := range p.Struct.Fields {
			v := c.compileExpr(f.Value)
			parts[i] = fmt.Sprintf(".%s = %s", sanitizeName(f.Name), v)
		}
		return fmt.Sprintf("(%s){%s}", sanitizeName(p.Struct.Name), strings.Join(parts, ", "))
	case p.List != nil:
		name := c.newTemp()
		nested := false
		if len(p.List.Elems) > 0 {
			if isListLiteral(p.List.Elems[0]) || isListIntExpr(p.List.Elems[0], c.env) {
				nested = true
			}
		}
		if nested {
			c.need(needListListInt)
			c.writeln(fmt.Sprintf("list_list_int %s = list_list_int_create(%d);", name, len(p.List.Elems)))
			for i, el := range p.List.Elems {
				v := c.compileExpr(el)
				c.writeln(fmt.Sprintf("%s.data[%d] = %s;", name, i, v))
			}
		} else if len(p.List.Elems) > 0 && isStringExpr(p.List.Elems[0], c.env) {
			c.need(needListString)
			c.writeln(fmt.Sprintf("list_string %s = list_string_create(%d);", name, len(p.List.Elems)))
			for i, el := range p.List.Elems {
				v := c.compileExpr(el)
				c.writeln(fmt.Sprintf("%s.data[%d] = %s;", name, i, v))
			}
		} else if len(p.List.Elems) > 0 && isFloatExpr(p.List.Elems[0], c.env) {
			c.need(needListFloat)
			c.writeln(fmt.Sprintf("list_float %s = list_float_create(%d);", name, len(p.List.Elems)))
			for i, el := range p.List.Elems {
				v := c.compileExpr(el)
				c.writeln(fmt.Sprintf("%s.data[%d] = %s;", name, i, v))
			}
		} else if len(p.List.Elems) > 0 {
			if ml := asMapLiteral(p.List.Elems[0]); ml != nil {
				if st, ok := c.structLits[ml]; ok {
					listName := "list_" + sanitizeName(st.Name)
					c.compileStructListType(st)
					c.writeln(fmt.Sprintf("%s %s = %s_create(%d);", listName, name, listName, len(p.List.Elems)))
					for i, el := range p.List.Elems {
						v := c.compileExpr(el)
						c.writeln(fmt.Sprintf("%s.data[%d] = %s;", name, i, v))
					}
					return name
				}
			}
			c.writeln(fmt.Sprintf("list_int %s = list_int_create(%d);", name, len(p.List.Elems)))
			for i, el := range p.List.Elems {
				v := c.compileExpr(el)
				c.writeln(fmt.Sprintf("%s.data[%d] = %s;", name, i, v))
			}
		}
		return name
	case p.Map != nil:
		if st, ok := c.structLits[p.Map]; ok {
			parts := make([]string, len(p.Map.Items))
			for i, it := range p.Map.Items {
				key, _ := types.SimpleStringKey(it.Key)
				v := c.compileExpr(it.Value)
				parts[i] = fmt.Sprintf(".%s = %s", sanitizeName(key), v)
			}
			return fmt.Sprintf("(%s){%s}", sanitizeName(st.Name), strings.Join(parts, ", "))
		}
		name := c.newTemp()
		c.need(needMapIntBool)
		c.writeln(fmt.Sprintf("map_int_bool %s = map_int_bool_create(%d);", name, len(p.Map.Items)))
		for _, it := range p.Map.Items {
			k := c.compileExpr(it.Key)
			v := c.compileExpr(it.Value)
			c.writeln(fmt.Sprintf("map_int_bool_put(&%s, %s, %s);", name, k, v))
		}
		return name
	case p.Call != nil:
		if p.Call.Func == "len" {
			isStr := isStringArg(p.Call.Args[0], c.env)
			arg := c.compileExpr(p.Call.Args[0])
			if isStr {
				c.need(needStringHeader)
				return fmt.Sprintf("strlen(%s)", arg)
			}
			return fmt.Sprintf("%s.len", arg)
		} else if p.Call.Func == "print" {
			for i, a := range p.Call.Args {
				argExpr := c.compileExpr(a)
				if isListListExpr(a, c.env) {
					c.need(needListListInt)
					c.need(needPrintListInt)
					c.need(needPrintListListInt)
					c.writeln(fmt.Sprintf("_print_list_list_int(%s);", argExpr))
					if i == len(p.Call.Args)-1 {
						c.writeln("printf(\"\\n\");")
					} else {
						c.writeln("printf(\" \");")
					}
				} else if isListIntExpr(a, c.env) {
					c.need(needListListInt)
					c.need(needPrintListInt)
					c.writeln(fmt.Sprintf("_print_list_int(%s);", argExpr))
					if i == len(p.Call.Args)-1 {
						c.writeln("printf(\"\\n\");")
					} else {
						c.writeln("printf(\" \");")
					}
				} else if isListFloatExpr(a, c.env) {
					c.need(needListFloat)
					c.need(needPrintListFloat)
					c.writeln(fmt.Sprintf("_print_list_float(%s);", argExpr))
					if i == len(p.Call.Args)-1 {
						c.writeln("printf(\"\\n\");")
					} else {
						c.writeln("printf(\" \");")
					}
				} else if isListStringExpr(a, c.env) {
					c.need(needListString)
					c.need(needPrintListString)
					c.writeln(fmt.Sprintf("_print_list_string(%s);", argExpr))
					if i == len(p.Call.Args)-1 {
						c.writeln("printf(\"\\n\");")
					} else {
						c.writeln("printf(\" \");")
					}
				} else {
					fmtStr := "%d"
					if isStringArg(a, c.env) {
						fmtStr = "%s"
					} else if isFloatArg(a, c.env) {
						fmtStr = "%g"
					}
					end := " "
					if i == len(p.Call.Args)-1 {
						end = "\\n"
					}
					c.writeln(fmt.Sprintf("printf(\"%s%s\", %s);", fmtStr, end, argExpr))
				}
			}
			return ""
		} else if p.Call.Func == "count" {
			t := c.exprType(p.Call.Args[0])
			arg := c.compileExpr(p.Call.Args[0])
			switch t.(type) {
			case types.GroupType:
				return fmt.Sprintf("%s.items.len", arg)
			case types.ListType:
				return fmt.Sprintf("%s.len", arg)
			default:
				c.need(needCount)
				return fmt.Sprintf("_count(%s)", arg)
			}
		} else if p.Call.Func == "sum" {
			arg := c.compileExpr(p.Call.Args[0])
			switch listElemType(p.Call.Args[0], c.env).(type) {
			case types.FloatType:
				return fmt.Sprintf("({ double sum=0; for(int i=0;i<%s.len;i++) sum+=%s.data[i]; sum; })", arg, arg)
			case types.IntType, types.BoolType:
				return fmt.Sprintf("({ int sum=0; for(int i=0;i<%s.len;i++) sum+=%s.data[i]; sum; })", arg, arg)
			}
			c.need(needSumInt)
			return fmt.Sprintf("_sum_int(%s)", arg)
		} else if p.Call.Func == "avg" {
			arg := c.compileExpr(p.Call.Args[0])
			switch listElemType(p.Call.Args[0], c.env).(type) {
			case types.FloatType:
				return fmt.Sprintf("({ double sum=0; for(int i=0;i<%s.len;i++) sum+=%s.data[i]; sum/%s.len; })", arg, arg, arg)
			case types.IntType, types.BoolType:
				return fmt.Sprintf("({ double sum=0; for(int i=0;i<%s.len;i++) sum+=%s.data[i]; sum/%s.len; })", arg, arg, arg)
			}
			c.need(needAvg)
			return fmt.Sprintf("_avg(%s)", arg)
		} else if p.Call.Func == "min" {
			arg := c.compileExpr(p.Call.Args[0])
			switch listElemType(p.Call.Args[0], c.env).(type) {
			case types.FloatType:
				return fmt.Sprintf("({ double m=%s.len?%s.data[0]:0; for(int i=1;i<%s.len;i++) if(%s.data[i]<m) m=%s.data[i]; m; })", arg, arg, arg, arg, arg)
			case types.StringType:
				c.need(needStringHeader)
				return fmt.Sprintf("({ char* m=%s.len?%s.data[0]:\"\"; for(int i=1;i<%s.len;i++) if(strcmp(%s.data[i], m)<0) m=%s.data[i]; m; })", arg, arg, arg, arg, arg)
			default:
				return fmt.Sprintf("({ int m=%s.len?%s.data[0]:0; for(int i=1;i<%s.len;i++) if(%s.data[i]<m) m=%s.data[i]; m; })", arg, arg, arg, arg, arg)
			}
		} else if p.Call.Func == "max" {
			arg := c.compileExpr(p.Call.Args[0])
			switch listElemType(p.Call.Args[0], c.env).(type) {
			case types.FloatType:
				return fmt.Sprintf("({ double m=%s.len?%s.data[0]:0; for(int i=1;i<%s.len;i++) if(%s.data[i]>m) m=%s.data[i]; m; })", arg, arg, arg, arg, arg)
			case types.StringType:
				c.need(needStringHeader)
				return fmt.Sprintf("({ char* m=%s.len?%s.data[0]:\"\"; for(int i=1;i<%s.len;i++) if(strcmp(%s.data[i], m)>0) m=%s.data[i]; m; })", arg, arg, arg, arg, arg)
			default:
				return fmt.Sprintf("({ int m=%s.len?%s.data[0]:0; for(int i=1;i<%s.len;i++) if(%s.data[i]>m) m=%s.data[i]; m; })", arg, arg, arg, arg, arg)
			}
		} else if p.Call.Func == "reduce" {
			list := c.compileExpr(p.Call.Args[0])
			fn := c.compileExpr(p.Call.Args[1])
			init := c.compileExpr(p.Call.Args[2])
			switch listElemType(p.Call.Args[0], c.env).(type) {
			case types.FloatType:
				c.need(needReduceFloat)
				return fmt.Sprintf("_reduce_float(%s, %s, %s)", list, fn, init)
			case types.StringType:
				c.need(needReduceString)
				return fmt.Sprintf("_reduce_string(%s, %s, %s)", list, fn, init)
			default:
				c.need(needReduceInt)
				return fmt.Sprintf("_reduce_int(%s, %s, %s)", list, fn, init)
			}
		} else if p.Call.Func == "str" {
			arg := c.compileExpr(p.Call.Args[0])
			name := c.newTemp()
			c.need(needStr)
			c.writeln(fmt.Sprintf("char* %s = _str(%s);", name, arg))
			return name
		} else if p.Call.Func == "input" {
			c.need(needInput)
			return "_input()"
		} else if p.Call.Func == "now" {
			c.need(needNow)
			return "_now()"
		} else if p.Call.Func == "json" {
			if len(p.Call.Args) != 1 {
				return ""
			}
			if ml := asMapLiteral(p.Call.Args[0]); ml != nil {
				c.need(needJSON)
				c.need(needListFloat)
				c.need(needListString)
				c.need(needListListInt)
				c.writeln("printf(\"{\");")
				for i, item := range ml.Items {
					if i > 0 {
						c.writeln("printf(\",\");")
					}
					if item.Key != nil && item.Key.Binary != nil && item.Key.Binary.Left != nil && item.Key.Binary.Left.Value != nil && item.Key.Binary.Left.Value.Target != nil && item.Key.Binary.Left.Value.Target.Lit != nil && item.Key.Binary.Left.Value.Target.Lit.Str != nil {
						key := strings.ReplaceAll(*item.Key.Binary.Left.Value.Target.Lit.Str, "\"", "\\\"")
						c.writeln(fmt.Sprintf("_json_string(\"%s\");", key))
						c.writeln("printf(\":\");")
					}
					c.emitJSONExpr(item.Value)
				}
				c.writeln("printf(\"}\\n\");")
				return ""
			}
			c.emitJSONExpr(p.Call.Args[0])
			return ""
		}
		args := make([]string, len(p.Call.Args))
		for i, a := range p.Call.Args {
			args[i] = c.compileExpr(a)
		}
		return fmt.Sprintf("%s(%s)", sanitizeName(p.Call.Func), strings.Join(args, ", "))
	case p.If != nil:
		return c.compileIfExpr(p.If)
	case p.Match != nil:
		return c.compileMatchExpr(p.Match)
	case p.Query != nil:
		return c.compileQueryExpr(p.Query)
	case p.Load != nil:
		return c.compileLoadExpr(p.Load)
	case p.Save != nil:
		return c.compileSaveExpr(p.Save)
	case p.Fetch != nil:
		return c.compileFetchExpr(p.Fetch)
	case p.FunExpr != nil:
		return c.compileFunExpr(p.FunExpr)
	case p.Group != nil:
		return fmt.Sprintf("(%s)", c.compileExpr(p.Group))
	default:
		return "0"
	}
}

func (c *Compiler) compileLiteral(l *parser.Literal) string {
	switch {
	case l.Int != nil:
		return fmt.Sprintf("%d", *l.Int)
	case l.Float != nil:
		s := strconv.FormatFloat(*l.Float, 'f', -1, 64)
		if !strings.ContainsAny(s, ".eE") {
			s += ".0"
		}
		return s
	case l.Bool != nil:
		if *l.Bool {
			return "1"
		} else {
			return "0"
		}
	case l.Str != nil:
		return strconv.Quote(*l.Str)
	}
	return "0"
}

func (c *Compiler) compileSelector(s *parser.SelectorExpr) string {
	expr := sanitizeName(s.Root)
	var typ types.Type
	if c.currentStruct != "" && c.env != nil {
		if st, ok := c.env.GetStruct(c.currentStruct); ok {
			if ft, ok2 := st.Fields[s.Root]; ok2 {
				expr = "self->" + sanitizeName(s.Root)
				typ = ft
			}
		}
	}
	if typ == nil && c.env != nil {
		if t, err := c.env.GetVar(s.Root); err == nil {
			typ = t
		}
	}
	for _, f := range s.Tail {
		if gt, ok := typ.(types.GroupType); ok {
			if f == "key" {
				expr += ".key"
				typ = gt.Elem
				continue
			}
			if f == "items" {
				expr += ".items"
				typ = types.ListType{Elem: gt.Elem}
				continue
			}
		}
		if ut, ok := typ.(types.UnionType); ok {
			var variant string
			var ft types.Type
			for name, st := range ut.Variants {
				if t, ok2 := st.Fields[f]; ok2 {
					if variant != "" {
						variant = ""
						break
					}
					variant = name
					ft = t
				}
			}
			if variant != "" {
				expr += fmt.Sprintf(".value.%s.%s", sanitizeName(variant), sanitizeName(f))
				typ = ft
				continue
			}
		}
		expr += "." + sanitizeName(f)
		if st, ok := typ.(types.StructType); ok {
			typ = st.Fields[f]
		} else {
			typ = nil
		}
	}
	return expr
}

func (c *Compiler) selectorStructType(sel *parser.SelectorExpr) (types.StructType, bool) {
	if c.env == nil {
		return types.StructType{}, false
	}
	var t types.Type
	var ok bool
	v, err := c.env.GetVar(sel.Root)
	if err == nil {
		t = v
		ok = true
	} else if c.currentStruct != "" {
		if st, ok2 := c.env.GetStruct(c.currentStruct); ok2 {
			if ft, ok3 := st.Fields[sel.Root]; ok3 {
				t = ft
				ok = true
			}
		}
	}
	if !ok {
		return types.StructType{}, false
	}
	for _, f := range sel.Tail {
		st, ok := t.(types.StructType)
		if !ok {
			return types.StructType{}, false
		}
		t = st.Fields[f]
	}
	st, ok := t.(types.StructType)
	return st, ok
}

func isStringArg(e *parser.Expr, env *types.Env) bool {
	if e == nil {
		return false
	}
	c := New(env)
	_, ok := c.exprType(e).(types.StringType)
	return ok
}

func isStringExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isStringUnary(e.Binary.Left, env)
}

func isStringUnaryOrIndex(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isStringPostfixOrIndex(u.Value, env)
}

func isStringUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isStringPostfix(u.Value, env)
}

func isStringPostfixOrIndex(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) > 0 {
		if p.Ops[0].Index != nil {
			if isStringPrimary(p.Target, env) || isListStringPrimary(p.Target, env) {
				return true
			}
			return false
		}
		return false
	}
	return isStringPrimary(p.Target, env)
}

func isStringPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) > 0 {
		if p.Ops[0].Index != nil && isListStringPrimary(p.Target, env) {
			return true
		}
		return false
	}
	return isStringPrimary(p.Target, env)
}

func isStringPrimary(p *parser.Primary, env *types.Env) bool {
	switch {
	case p == nil:
		return false
	case p.Lit != nil && p.Lit.Str != nil:
		return true
	case p.Call != nil && p.Call.Func == "str":
		return true
	case p.Selector != nil && env != nil:
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if _, ok := t.(types.StringType); ok {
				return true
			}
		}
	}
	return false
}

func isFloatArg(e *parser.Expr, env *types.Env) bool {
	if e == nil {
		return false
	}
	c := New(env)
	_, ok := c.exprType(e).(types.FloatType)
	return ok
}

func isFloatExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isFloatUnary(e.Binary.Left, env)
}

func isFloatUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isFloatPostfix(u.Value, env)
}

func isFloatPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil || len(p.Ops) > 0 {
		return false
	}
	return isFloatPrimary(p.Target, env)
}

func isFloatPrimary(p *parser.Primary, env *types.Env) bool {
	switch {
	case p == nil:
		return false
	case p.Lit != nil && p.Lit.Float != nil:
		return true
	case p.Selector != nil && env != nil:
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if _, ok := t.(types.FloatType); ok {
				return true
			}
		}
	case p.Call != nil && env != nil:
		if t, err := env.GetVar(p.Call.Func); err == nil {
			if ft, ok := t.(types.FuncType); ok {
				if _, ok2 := ft.Return.(types.FloatType); ok2 {
					return true
				}
			}
		}
	}
	return false
}

func isNowExpr(e *parser.Expr) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isNowUnary(e.Binary.Left)
}

func isNowUnary(u *parser.Unary) bool {
	if u == nil {
		return false
	}
	return isNowPostfix(u.Value)
}

func isNowPostfix(p *parser.PostfixExpr) bool {
	if p == nil || len(p.Ops) > 0 {
		return false
	}
	return isNowPrimary(p.Target)
}

func isNowPrimary(p *parser.Primary) bool {
	return p != nil && p.Call != nil && p.Call.Func == "now"
}

func isListLiteral(e *parser.Expr) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isListLiteralUnary(e.Binary.Left)
}

func isListLiteralUnary(u *parser.Unary) bool {
	if u == nil {
		return false
	}
	return isListLiteralPostfix(u.Value)
}

func isListLiteralPostfix(p *parser.PostfixExpr) bool {
	if p == nil || len(p.Ops) > 0 {
		return false
	}
	return isListLiteralPrimary(p.Target)
}

func isListLiteralPrimary(p *parser.Primary) bool {
	return p != nil && p.List != nil
}

func isEmptyListLiteral(e *parser.Expr) bool {
	if e == nil || e.Binary == nil || e.Binary.Left == nil || e.Binary.Left.Value == nil || e.Binary.Left.Value.Target == nil {
		return false
	}
	if e.Binary.Left.Value.Target.List != nil {
		return len(e.Binary.Left.Value.Target.List.Elems) == 0
	}
	return false
}

func isEmptyMapLiteral(e *parser.Expr) bool {
	ml := asMapLiteral(e)
	return ml != nil && len(ml.Items) == 0
}

func isListListExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isListListUnary(e.Binary.Left, env)
}

func isListListUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isListListPostfix(u.Value, env)
}

func isListListPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil || len(p.Ops) > 0 {
		return false
	}
	return isListListPrimary(p.Target, env)
}

func isListListPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.List != nil {
		if len(p.List.Elems) > 0 {
			if isListLiteral(p.List.Elems[0]) || isListIntExpr(p.List.Elems[0], env) {
				return true
			}
		}
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if isListListIntType(t) {
				return true
			}
		}
	}
	if p.Call != nil && env != nil {
		if t, err := env.GetVar(p.Call.Func); err == nil {
			if ft, ok := t.(types.FuncType); ok {
				if isListListIntType(ft.Return) {
					return true
				}
			}
		}
	}
	return false
}

func isListIntExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isListIntUnary(e.Binary.Left, env)
}

func isListIntUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isListIntPostfix(u.Value, env)
}

func isListIntPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) == 0 {
		return isListIntPrimary(p.Target, env)
	}
	if p.Ops[0].Index != nil && p.Ops[0].Index.Colon != nil {
		if isStringPrimary(p.Target, env) {
			return false
		}
		return true
	}
	return false
}

func isListIntPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.List != nil {
		if len(p.List.Elems) == 0 {
			return true
		}
		el := p.List.Elems[0]
		if el.Binary != nil && el.Binary.Left != nil && el.Binary.Left.Value != nil && el.Binary.Left.Value.Target != nil {
			if el.Binary.Left.Value.Target.Lit != nil {
				if el.Binary.Left.Value.Target.Lit.Int != nil || el.Binary.Left.Value.Target.Lit.Bool != nil {
					return true
				}
			}
			if el.Binary.Left.Value.Target.Selector != nil && env != nil {
				name := el.Binary.Left.Value.Target.Selector.Root
				if t, err := env.GetVar(name); err == nil {
					if lt, ok := t.(types.ListType); ok {
						switch lt.Elem.(type) {
						case types.IntType, types.BoolType:
							return true
						}
					}
					switch t.(type) {
					case types.IntType, types.BoolType:
						return true
					}
				}
			}
		}
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if lt, ok := t.(types.ListType); ok {
				switch lt.Elem.(type) {
				case types.IntType, types.BoolType:
					return true
				}
			}
		}
	}
	if p.Call != nil && env != nil {
		if t, err := env.GetVar(p.Call.Func); err == nil {
			if ft, ok := t.(types.FuncType); ok {
				if lt, ok2 := ft.Return.(types.ListType); ok2 {
					switch lt.Elem.(type) {
					case types.IntType, types.BoolType:
						return true
					}
				}
			}
		}
	}
	return false
}

func isListStringExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isListStringUnary(e.Binary.Left, env)
}

func isListStringUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isListStringPostfix(u.Value, env)
}

func isListStringPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) == 0 {
		return isListStringPrimary(p.Target, env)
	}
	if p.Ops[0].Index != nil && p.Ops[0].Index.Colon != nil {
		if isStringPrimary(p.Target, env) {
			return false
		}
		return true
	}
	return false
}

func isListStringPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.List != nil {
		if len(p.List.Elems) == 0 {
			return true
		}
		el := p.List.Elems[0]
		if el.Binary != nil && el.Binary.Left != nil && el.Binary.Left.Value != nil && el.Binary.Left.Value.Target != nil {
			if lit := el.Binary.Left.Value.Target.Lit; lit != nil && lit.Str != nil {
				return true
			}
			if sel := el.Binary.Left.Value.Target.Selector; sel != nil && env != nil {
				if t, err := env.GetVar(sel.Root); err == nil {
					if _, ok := t.(types.StringType); ok {
						return true
					}
					if lt, ok := t.(types.ListType); ok {
						if _, ok2 := lt.Elem.(types.StringType); ok2 {
							return true
						}
					}
				}
			}
		}
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if lt, ok := t.(types.ListType); ok {
				if _, ok := lt.Elem.(types.StringType); ok {
					return true
				}
			}
		}
	}
	if p.Call != nil && env != nil {
		if t, err := env.GetVar(p.Call.Func); err == nil {
			if ft, ok := t.(types.FuncType); ok {
				if lt, ok2 := ft.Return.(types.ListType); ok2 {
					if _, ok3 := lt.Elem.(types.StringType); ok3 {
						return true
					}
				}
			}
		}
	}
	return false
}

func isListFloatExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isListFloatUnary(e.Binary.Left, env)
}

func isListFloatUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isListFloatPostfix(u.Value, env)
}

func isListFloatPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) == 0 {
		return isListFloatPrimary(p.Target, env)
	}
	if p.Ops[0].Index != nil && p.Ops[0].Index.Colon != nil {
		if isStringPrimary(p.Target, env) {
			return false
		}
		return true
	}
	return false
}

func isListFloatPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.List != nil {
		if len(p.List.Elems) == 0 {
			return true
		}
		el := p.List.Elems[0]
		if el.Binary != nil && el.Binary.Left != nil && el.Binary.Left.Value != nil && el.Binary.Left.Value.Target != nil {
			if lit := el.Binary.Left.Value.Target.Lit; lit != nil && lit.Float != nil {
				return true
			}
			if sel := el.Binary.Left.Value.Target.Selector; sel != nil && env != nil {
				if t, err := env.GetVar(sel.Root); err == nil {
					if _, ok := t.(types.FloatType); ok {
						return true
					}
					if lt, ok := t.(types.ListType); ok {
						if _, ok2 := lt.Elem.(types.FloatType); ok2 {
							return true
						}
					}
				}
			}
		}
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if lt, ok := t.(types.ListType); ok {
				if _, ok := lt.Elem.(types.FloatType); ok {
					return true
				}
			}
		}
	}
	if p.Call != nil && env != nil {
		if t, err := env.GetVar(p.Call.Func); err == nil {
			if ft, ok := t.(types.FuncType); ok {
				if lt, ok2 := ft.Return.(types.ListType); ok2 {
					if _, ok3 := lt.Elem.(types.FloatType); ok3 {
						return true
					}
				}
			}
		}
	}
	return false
}

func isMapIntBoolExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isMapIntBoolUnary(e.Binary.Left, env)
}

func isMapIntBoolUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isMapIntBoolPostfix(u.Value, env)
}

func isMapIntBoolPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) > 0 {
		return false
	}
	return isMapIntBoolPrimary(p.Target, env)
}

func isMapIntBoolPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.Map != nil {
		return true
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if isMapIntBoolType(t) {
				return true
			}
		}
	}
	return false
}

func isMapStringExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isMapStringUnary(e.Binary.Left, env)
}

func isMapStringUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isMapStringPostfix(u.Value, env)
}

func isMapStringPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) > 0 {
		return false
	}
	return isMapStringPrimary(p.Target, env)
}

func isMapStringPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.Map != nil {
		return true
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if isMapStringType(t) {
				return true
			}
		}
	}
	return false
}

func isListMapStringExpr(e *parser.Expr, env *types.Env) bool {
	if e == nil || e.Binary == nil {
		return false
	}
	return isListMapStringUnary(e.Binary.Left, env)
}

func isListMapStringUnary(u *parser.Unary, env *types.Env) bool {
	if u == nil {
		return false
	}
	return isListMapStringPostfix(u.Value, env)
}

func isListMapStringPostfix(p *parser.PostfixExpr, env *types.Env) bool {
	if p == nil {
		return false
	}
	if len(p.Ops) == 0 {
		return isListMapStringPrimary(p.Target, env)
	}
	if p.Ops[0].Index != nil && p.Ops[0].Index.Colon != nil {
		if isStringPrimary(p.Target, env) {
			return false
		}
		return true
	}
	return false
}

func isListMapStringPrimary(p *parser.Primary, env *types.Env) bool {
	if p == nil {
		return false
	}
	if p.List != nil {
		if len(p.List.Elems) == 0 {
			return true
		}
		el := p.List.Elems[0]
		if el.Binary != nil && el.Binary.Left != nil && el.Binary.Left.Value != nil && el.Binary.Left.Value.Target != nil {
			if el.Binary.Left.Value.Target.Map != nil {
				return true
			}
			if sel := el.Binary.Left.Value.Target.Selector; sel != nil && env != nil {
				if t, err := env.GetVar(sel.Root); err == nil {
					if isMapStringType(t) {
						return true
					}
					if lt, ok := t.(types.ListType); ok {
						if isMapStringType(lt.Elem) {
							return true
						}
					}
				}
			}
		}
	}
	if p.Selector != nil && env != nil {
		if t, err := env.GetVar(p.Selector.Root); err == nil {
			if lt, ok := t.(types.ListType); ok {
				if isMapStringType(lt.Elem) {
					return true
				}
			}
		}
	}
	if p.Call != nil && env != nil {
		if t, err := env.GetVar(p.Call.Func); err == nil {
			if ft, ok := t.(types.FuncType); ok {
				if lt, ok2 := ft.Return.(types.ListType); ok2 {
					if isMapStringType(lt.Elem) {
						return true
					}
				}
			}
		}
	}
	return false
}

func asMapLiteral(e *parser.Expr) *parser.MapLiteral {
	if e == nil || e.Binary == nil || e.Binary.Left == nil || e.Binary.Left.Value == nil || e.Binary.Left.Value.Target == nil {
		return nil
	}
	return e.Binary.Left.Value.Target.Map
}

func asFetchExpr(e *parser.Expr) *parser.FetchExpr {
	if e == nil || e.Binary == nil || len(e.Binary.Right) > 0 {
		return nil
	}
	if e.Binary.Left == nil || e.Binary.Left.Value == nil || e.Binary.Left.Value.Target == nil {
		return nil
	}
	return e.Binary.Left.Value.Target.Fetch
}

func (c *Compiler) emitJSONExpr(e *parser.Expr) {
	argExpr := c.compileExpr(e)
	c.need(needJSON)
	c.need(needListFloat)
	c.need(needListString)
	c.need(needListListInt)
	if isListListExpr(e, c.env) {
		c.writeln(fmt.Sprintf("_json_list_list_int(%s);", argExpr))
	} else if isListIntExpr(e, c.env) {
		c.writeln(fmt.Sprintf("_json_list_int(%s);", argExpr))
	} else if isListFloatExpr(e, c.env) {
		c.writeln(fmt.Sprintf("_json_list_float(%s);", argExpr))
	} else if isListStringExpr(e, c.env) {
		c.writeln(fmt.Sprintf("_json_list_string(%s);", argExpr))
	} else if isListMapStringExpr(e, c.env) {
		c.need(needJSONListMapString)
		c.writeln(fmt.Sprintf("_json_list_map_string(%s);", argExpr))
	} else if isFloatArg(e, c.env) {
		c.writeln(fmt.Sprintf("_json_float(%s);", argExpr))
	} else if isStringArg(e, c.env) {
		c.writeln(fmt.Sprintf("_json_string(%s);", argExpr))
	} else if isMapStringExpr(e, c.env) {
		c.need(needJSONMapString)
		c.writeln(fmt.Sprintf("_json_map_string(%s);", argExpr))
	} else {
		c.writeln(fmt.Sprintf("_json_int(%s);", argExpr))
	}
}

func (c *Compiler) inferStructFromList(ll *parser.ListLiteral, name string) (types.StructType, bool) {
	if ll == nil || len(ll.Elems) == 0 {
		return types.StructType{}, false
	}
	first := ll.Elems[0]
	if first.Binary == nil || len(first.Binary.Right) != 0 {
		return types.StructType{}, false
	}
	fm := first.Binary.Left.Value.Target.Map
	if fm == nil {
		return types.StructType{}, false
	}
	fields := map[string]types.Type{}
	order := make([]string, len(fm.Items))
	for i, it := range fm.Items {
		key, ok := types.SimpleStringKey(it.Key)
		if !ok {
			return types.StructType{}, false
		}
		order[i] = key
		fields[key] = types.ExprType(it.Value, c.env)
	}
	for _, el := range ll.Elems[1:] {
		if el.Binary == nil || len(el.Binary.Right) != 0 {
			return types.StructType{}, false
		}
		ml := el.Binary.Left.Value.Target.Map
		if ml == nil || len(ml.Items) != len(order) {
			return types.StructType{}, false
		}
		for i, it := range ml.Items {
			key, ok := types.SimpleStringKey(it.Key)
			if !ok || key != order[i] {
				return types.StructType{}, false
			}
			t := types.ExprType(it.Value, c.env)
			if !equalTypes(fields[key], t) {
				return types.StructType{}, false
			}
		}
	}
	stName := sanitizeName(name) + "Item"
	idx := 1
	base := stName
	for {
		if c.structs[stName] {
			stName = fmt.Sprintf("%s%d", base, idx)
			idx++
		} else if c.env != nil {
			if _, ok := c.env.GetStruct(stName); ok {
				stName = fmt.Sprintf("%s%d", base, idx)
				idx++
			} else {
				break
			}
		} else {
			break
		}
	}
	st := types.StructType{Name: stName, Fields: fields, Order: order}
	return st, true
}
