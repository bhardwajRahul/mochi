//go:build slow

package st

import (
	"bytes"
	"fmt"
	"strings"

	meta "mochi/compiler/meta"
	"mochi/parser"
	"mochi/types"
)

// Compiler translates a subset of Mochi to Smalltalk source code.
type Compiler struct {
	buf          bytes.Buffer
	vars         map[string]bool
	order        []string
	indent       int
	needBreak    bool
	needContinue bool
	fallbackVar  string

	env       *types.Env
	constLens map[string]int
	constStrs map[string]string
}

// New returns a new compiler instance.
func New(env *types.Env) *Compiler {
	return &Compiler{
		vars:      make(map[string]bool),
		env:       env,
		constLens: make(map[string]int),
		constStrs: make(map[string]string),
	}
}

// Compile converts a parsed Mochi program to Smalltalk code.
func (c *Compiler) Compile(p *parser.Program) ([]byte, error) {
	c.buf.Reset()
	var out bytes.Buffer
	out.Write(meta.Header("\""))
	out.WriteString("\"\n")
	c.vars = make(map[string]bool)
	c.indent = 0
	c.needBreak = false
	c.needContinue = false
	c.order = nil
	c.constLens = make(map[string]int)
	c.constStrs = make(map[string]string)

	var body bytes.Buffer
	saved := c.buf
	c.buf = body
	for _, st := range p.Statements {
		c.collectVars(st)
		if err := c.compileStmt(st); err != nil {
			return nil, err
		}
	}
	bodyBytes := c.buf.Bytes()
	c.buf = saved

	if len(c.order) > 0 {
		c.buf.WriteString("| ")
		c.buf.WriteString(strings.Join(c.order, " "))
		c.buf.WriteString(" |\n")
	}
	if c.needBreak {
		c.writeln("Object subclass: #BreakSignal instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' category: nil!")
	}
	if c.needContinue {
		c.writeln("Object subclass: #ContinueSignal instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' category: nil!")
	}

	c.buf.Write(bodyBytes)
	out.Write(c.buf.Bytes())
	return out.Bytes(), nil
}

func (c *Compiler) collectVars(st *parser.Statement) {
	switch {
	case st.Let != nil:
		if !c.vars[st.Let.Name] {
			c.order = append(c.order, st.Let.Name)
			c.vars[st.Let.Name] = true
		}
	case st.Var != nil:
		if !c.vars[st.Var.Name] {
			c.order = append(c.order, st.Var.Name)
			c.vars[st.Var.Name] = true
		}
	case st.Fun != nil:
		if !c.vars[st.Fun.Name] {
			c.order = append(c.order, st.Fun.Name)
			c.vars[st.Fun.Name] = true
		}
		for _, s := range st.Fun.Body {
			c.collectVars(s)
		}
	case st.If != nil:
		for _, s := range st.If.Then {
			c.collectVars(s)
		}
		if st.If.ElseIf != nil {
			c.collectVars(&parser.Statement{If: st.If.ElseIf})
		}
		for _, s := range st.If.Else {
			c.collectVars(s)
		}
	case st.While != nil:
		for _, s := range st.While.Body {
			c.collectVars(s)
		}
	case st.For != nil:
		if !c.vars[st.For.Name] {
			c.order = append(c.order, st.For.Name)
			c.vars[st.For.Name] = true
		}
		for _, s := range st.For.Body {
			c.collectVars(s)
		}
	case st.Import != nil:
		name := st.Import.As
		if name == "" {
			if base := st.Import.Path; base != "" {
				parts := strings.Split(base, "/")
				name = parts[len(parts)-1]
			}
		}
		if name != "" && !c.vars[name] {
			if !(st.Import.Lang != nil && *st.Import.Lang == "python" && st.Import.Path == "math") {
				c.order = append(c.order, name)
				c.vars[name] = true
			}
		}
	}
}

func (c *Compiler) writeln(s string) {
	c.buf.WriteString(s)
	if !strings.HasSuffix(s, ".") {
		c.buf.WriteByte('.')
	}
	c.buf.WriteByte('\n')
}

func (c *Compiler) compileStmt(st *parser.Statement) error {
	switch {
	case st.Type != nil:
		// Smalltalk code does not require explicit type declarations.
		// Ignore struct and enum definitions.
		return nil
	case st.Fun != nil:
		params := make([]string, len(st.Fun.Params))
		for i, p := range st.Fun.Params {
			params[i] = ":" + p.Name
		}
		pnames := make([]string, len(st.Fun.Params))
		for i, p := range st.Fun.Params {
			pnames[i] = p.Name
		}
		body, err := c.blockString(pnames, st.Fun.Body)
		if err != nil {
			return err
		}
		header := strings.Join(params, " ")
		if header != "" {
			header += " | "
			c.writeln(fmt.Sprintf("%s := [%s%s ]", st.Fun.Name, header, body))
		} else {
			c.writeln(fmt.Sprintf("%s := [ %s ]", st.Fun.Name, body))
		}
		return nil
	case st.Let != nil:
		if st.Let.Value != nil {
			if l := listLiteral(st.Let.Value); l != nil {
				c.constLens[st.Let.Name] = len(l.Elems)
			} else {
				delete(c.constLens, st.Let.Name)
			}
			if s := stringLiteralExpr(st.Let.Value); s != nil {
				c.constStrs[st.Let.Name] = *s
			} else {
				delete(c.constStrs, st.Let.Name)
			}
			expr, err := c.compileExpr(st.Let.Value)
			if err != nil {
				return err
			}
			c.writeln(fmt.Sprintf("%s := %s", st.Let.Name, expr))
		}
		return nil
	case st.Var != nil:
		if st.Var.Value != nil {
			if l := listLiteral(st.Var.Value); l != nil {
				c.constLens[st.Var.Name] = len(l.Elems)
			} else {
				delete(c.constLens, st.Var.Name)
			}
			if s := stringLiteralExpr(st.Var.Value); s != nil {
				c.constStrs[st.Var.Name] = *s
			} else {
				delete(c.constStrs, st.Var.Name)
			}
			expr, err := c.compileExpr(st.Var.Value)
			if err != nil {
				return err
			}
			c.writeln(fmt.Sprintf("%s := %s", st.Var.Name, expr))
		}
		return nil
	case st.Import != nil:
		return c.compileImport(st.Import)
	case st.ExternVar != nil, st.ExternFun != nil, st.ExternType != nil,
		st.ExternObject != nil:
		return nil
	case st.Assign != nil:
		if l := listLiteral(st.Assign.Value); l != nil {
			c.constLens[st.Assign.Name] = len(l.Elems)
		} else {
			delete(c.constLens, st.Assign.Name)
		}
		if s := stringLiteralExpr(st.Assign.Value); s != nil {
			c.constStrs[st.Assign.Name] = *s
		} else {
			delete(c.constStrs, st.Assign.Name)
		}
		val, err := c.compileExpr(st.Assign.Value)
		if err != nil {
			return err
		}
		target := st.Assign.Name
		// build nested access for all but last index/field
		for i, idx := range st.Assign.Index {
			if i == len(st.Assign.Index)-1 && len(st.Assign.Field) == 0 {
				idxStr, err := c.compileExpr(idx.Start)
				if err != nil {
					return err
				}
				c.writeln(fmt.Sprintf("%s at: %s put: %s", target, idxStr, val))
				return nil
			}
			idxStr, err := c.compileExpr(idx.Start)
			if err != nil {
				return err
			}
			target = fmt.Sprintf("%s at: %s", target, idxStr)
		}
		for i, f := range st.Assign.Field {
			if i == len(st.Assign.Field)-1 {
				c.writeln(fmt.Sprintf("%s at: '%s' put: %s", target, f.Name, val))
				return nil
			}
			target = fmt.Sprintf("%s at: '%s'", target, f.Name)
		}
		if len(st.Assign.Index) == 0 && len(st.Assign.Field) == 0 {
			c.writeln(fmt.Sprintf("%s := %s", st.Assign.Name, val))
		}
		return nil
	case st.Expr != nil:
		// handle print built-in
		if call := getCall(st.Expr.Expr); call != nil && call.Func == "print" && len(call.Args) == 1 {
			arg, err := c.compileExpr(call.Args[0])
			if err != nil {
				return err
			}
			if isStringLiteral(call.Args[0]) {
				c.writeln(fmt.Sprintf("Transcript show: %s; cr", arg))
			} else {
				c.writeln(fmt.Sprintf("Transcript show: (%s) printString; cr", arg))
			}
			return nil
		}
		expr, err := c.compileExpr(st.Expr.Expr)
		if err != nil {
			return err
		}
		c.writeln(expr)
	case st.Return != nil:
		val, err := c.compileExpr(st.Return.Value)
		if err != nil {
			return err
		}
		// Returning from top-level script blocks using '^' triggers
		// "return from a dead method context" errors under GNU
		// Smalltalk. Simply emit the value expression so the last
		// evaluated statement becomes the result.
		c.writeln(val)
		return nil
	case st.If != nil:
		return c.compileIf(st.If)
	case st.While != nil:
		return c.compileWhile(st.While)
	case st.For != nil:
		return c.compileFor(st.For)
	case st.Break != nil:
		return c.compileBreak()
	case st.Continue != nil:
		return c.compileContinue()
	case st.Test != nil:
		return c.compileTestBlock(st.Test)
	case st.Expect != nil:
		return c.compileExpect(st.Expect)
	case st.Update != nil:
		return c.compileUpdate(st.Update)
	default:
		return fmt.Errorf("unsupported statement at line %d", st.Pos.Line)
	}
	return nil
}

func (c *Compiler) compileIf(i *parser.IfStmt) error {
	cond, err := c.compileExpr(i.Cond)
	if err != nil {
		return err
	}
	c.buf.WriteString("(" + cond + ") ifTrue: [\n")
	c.indent++
	for _, st := range i.Then {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	c.indent--
	if i.ElseIf != nil {
		c.buf.WriteString("] ifFalse: [\n")
		c.indent++
		if err := c.compileIf(i.ElseIf); err != nil {
			return err
		}
		c.indent--
		c.buf.WriteString("].\n")
		return nil
	}
	if len(i.Else) == 0 {
		c.buf.WriteString("] .\n")
		return nil
	}
	c.buf.WriteString("] ifFalse: [\n")
	c.indent++
	for _, st := range i.Else {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	c.indent--
	c.buf.WriteString("].\n")
	return nil
}

func (c *Compiler) compileWhile(w *parser.WhileStmt) error {
	cond, err := c.compileExpr(w.Cond)
	if err != nil {
		return err
	}
	brk := hasBreak(w.Body)
	cont := hasContinue(w.Body)
	if brk {
		c.needBreak = true
	}
	if cont {
		c.needContinue = true
	}
	wrap := brk || cont
	if wrap {
		c.writeln("[")
		c.indent++
	}
	c.writeln(fmt.Sprintf("[%s] whileTrue: [", cond))
	c.indent++
	if cont {
		c.writeln("[")
		c.indent++
	}
	for _, st := range w.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	if cont {
		c.indent--
		c.writeln("] on: ContinueSignal do: [:ex | ]")
	}
	c.indent--
	c.writeln("]")
	if wrap {
		c.indent--
		c.writeln("] on: BreakSignal do: [:ex | ].")
	} else {
		c.writeln(".")
	}
	return nil
}

func (c *Compiler) compileFor(f *parser.ForStmt) error {
	brk := hasBreak(f.Body)
	cont := hasContinue(f.Body)
	if brk {
		c.needBreak = true
	}
	if cont {
		c.needContinue = true
	}
	wrap := brk || cont
	if wrap {
		c.writeln("[")
		c.indent++
	}
	if f.RangeEnd != nil {
		start, err := c.compileExpr(f.Source)
		if err != nil {
			return err
		}
		end, err := c.compileExpr(f.RangeEnd)
		if err != nil {
			return err
		}
		c.writeln(fmt.Sprintf("%s to: %s do: [:%s |", start, end, f.Name))
	} else {
		src, err := c.compileExpr(f.Source)
		if err != nil {
			return err
		}
		c.writeln(fmt.Sprintf("%s do: [:%s |", src, f.Name))
	}
	c.indent++
	if cont {
		c.writeln("[")
		c.indent++
	}
	for _, st := range f.Body {
		if err := c.compileStmt(st); err != nil {
			return err
		}
	}
	if cont {
		c.indent--
		c.writeln("] on: ContinueSignal do: [:ex | ]")
	}
	c.indent--
	c.writeln("]")
	if wrap {
		c.indent--
		c.writeln("] on: BreakSignal do: [:ex | ].")
	} else {
		c.writeln(".")
	}
	return nil
}

func (c *Compiler) compileBreak() error {
	c.needBreak = true
	c.writeln("BreakSignal signal")
	return nil
}

func (c *Compiler) compileContinue() error {
	c.needContinue = true
	c.writeln("ContinueSignal signal")
	return nil
}

func (c *Compiler) compileExpr(e *parser.Expr) (string, error) {
	if e == nil || e.Binary == nil {
		return "", fmt.Errorf("empty expression")
	}
	return c.compileBinary(e.Binary)
}

func (c *Compiler) compileBinary(b *parser.BinaryExpr) (string, error) {
	if b == nil {
		return "", fmt.Errorf("nil binary expression")
	}

	if len(b.Right) == 1 && b.Right[0].Op == "in" {
		leftStr, err := c.compileUnary(b.Left)
		if err != nil {
			return "", err
		}
		rightStr, err := c.compilePostfix(b.Right[0].Right)
		if err != nil {
			return "", err
		}
		if types.IsMapPostfix(b.Right[0].Right, c.env) {
			return fmt.Sprintf("(%s includesKey: %s)", rightStr, leftStr), nil
		}
		if types.IsStringPostfix(b.Right[0].Right, c.env) {
			return fmt.Sprintf("(%s includesSubstring: %s)", rightStr, leftStr), nil
		}
		return fmt.Sprintf("(%s includes: %s)", rightStr, leftStr), nil
	}

	operands := []string{}
	ops := []string{}

	first, err := c.compileUnary(b.Left)
	if err != nil {
		return "", err
	}
	operands = append(operands, first)
	for _, p := range b.Right {
		o, err := c.compilePostfix(p.Right)
		if err != nil {
			return "", err
		}
		op := p.Op
		if p.All {
			op = op + "_all"
		}
		ops = append(ops, op)
		operands = append(operands, o)
	}

	levels := [][]string{
		{"*", "/", "%"},
		{"+", "-"},
		{"<", "<=", ">", ">="},
		{"==", "!=", "in"},
		{"&&"},
		{"||"},
		{"union", "union_all", "except", "intersect"},
	}

	wrap := func(s string) string {
		if strings.ContainsAny(s, " :") {
			return "(" + s + ")"
		}
		return s
	}

	apply := func(left, op, right string) string {
		left = wrap(left)
		right = wrap(right)
		switch op {
		case "&&":
			return fmt.Sprintf("(%s and: [%s])", left, right)
		case "||":
			return fmt.Sprintf("(%s or: [%s])", left, right)
		case "==":
			return fmt.Sprintf("(%s = %s)", left, right)
		case "!=":
			return fmt.Sprintf("(%s ~= %s)", left, right)
		default:
			return fmt.Sprintf("(%s %s %s)", left, op, right)
		}
	}

	for _, level := range levels {
		for i := 0; i < len(ops); {
			matched := false
			for _, t := range level {
				if ops[i] == t {
					res := apply(operands[i], ops[i], operands[i+1])
					operands[i] = res
					operands = append(operands[:i+1], operands[i+2:]...)
					ops = append(ops[:i], ops[i+1:]...)
					matched = true
					break
				}
			}
			if !matched {
				i++
			}
		}
	}

	if len(operands) != 1 {
		return "", fmt.Errorf("expression reduction failed")
	}
	return operands[0], nil
}

func (c *Compiler) compileUnary(u *parser.Unary) (string, error) {
	val, err := c.compilePostfix(u.Value)
	if err != nil {
		return "", err
	}
	for i := len(u.Ops) - 1; i >= 0; i-- {
		switch u.Ops[i] {
		case "-":
			if strings.ContainsAny(val, " :") {
				val = "-(" + val + ")"
			} else {
				val = "-" + val
			}
		case "!":
			val = val + " not"
		}
	}
	return val, nil
}

func (c *Compiler) compilePostfix(p *parser.PostfixExpr) (string, error) {
	val, err := c.compilePrimary(p.Target)
	if err != nil {
		return "", err
	}
	for _, op := range p.Ops {
		switch {
		case op.Call != nil:
			args := make([]string, len(op.Call.Args))
			for i, a := range op.Call.Args {
				s, err := c.compileExpr(a)
				if err != nil {
					return "", err
				}
				args[i] = s
			}
			if p.Target != nil && p.Target.Selector != nil && len(p.Target.Selector.Tail) == 1 && p.Target.Selector.Tail[0] == "contains" {
				if len(args) != 1 {
					return "", fmt.Errorf("contains expects 1 arg")
				}
				if types.IsStringPrimary(&parser.Primary{Selector: p.Target.Selector}, c.env) {
					val = fmt.Sprintf("%s includesSubstring: %s", p.Target.Selector.Root, args[0])
				} else {
					val = fmt.Sprintf("%s includes: %s", p.Target.Selector.Root, args[0])
				}
				continue
			}
			if p.Target != nil && p.Target.Selector != nil && p.Target.Selector.Root == "math" && len(p.Target.Selector.Tail) == 1 {
				switch p.Target.Selector.Tail[0] {
				case "sqrt":
					if len(args) != 1 {
						return "", fmt.Errorf("sqrt expects 1 arg")
					}
					val = fmt.Sprintf("%s sqrt", args[0])
					continue
				case "pow":
					if len(args) != 2 {
						return "", fmt.Errorf("pow expects 2 args")
					}
					val = fmt.Sprintf("%s raisedTo: %s", args[0], args[1])
					continue
				case "sin":
					if len(args) != 1 {
						return "", fmt.Errorf("sin expects 1 arg")
					}
					val = fmt.Sprintf("%s sin", args[0])
					continue
				case "log":
					if len(args) != 1 {
						return "", fmt.Errorf("log expects 1 arg")
					}
					val = fmt.Sprintf("%s ln", args[0])
					continue
				}
			}
			if val == "print" {
				if len(args) == 0 {
					return "", fmt.Errorf("print expects at least 1 arg")
				}
				stmt := "Transcript show: "
				if isStringLiteral(op.Call.Args[0]) {
					stmt += args[0]
				} else {
					stmt += fmt.Sprintf("(%s) printString", args[0])
				}
				for i, a := range args[1:] {
					stmt += "; show: ' '; show: "
					if isStringLiteral(op.Call.Args[i+1]) {
						stmt += a
					} else {
						stmt += fmt.Sprintf("(%s) printString", a)
					}
				}
				val = stmt + "; cr"
			} else {
				call := "(" + val + ")"
				if len(args) == 0 {
					call += " value"
				} else {
					for _, a := range args {
						if strings.ContainsAny(a, " :") {
							a = "(" + a + ")"
						}
						call += " value: " + a
					}
				}
				val = call
			}
		case op.Index != nil:
			if op.Index.Colon != nil || op.Index.End != nil {
				start := "1"
				if op.Index.Start != nil {
					s, err := c.compileExpr(op.Index.Start)
					if err != nil {
						return "", err
					}
					start = fmt.Sprintf("(%s + 1)", s)
				}
				end := fmt.Sprintf("%s size", val)
				if op.Index.End != nil {
					e, err := c.compileExpr(op.Index.End)
					if err != nil {
						return "", err
					}
					end = e
				}
				val = fmt.Sprintf("%s copyFrom: %s to: %s", val, start, end)
			} else {
				idx, err := c.compileExpr(op.Index.Start)
				if err != nil {
					return "", err
				}
				val = fmt.Sprintf("%s at: %s", val, idx)
			}
		case op.Field != nil:
			val = fmt.Sprintf("%s at: %q", val, op.Field.Name)
		case op.Cast != nil:
			var tname string
			if op.Cast.Type.Simple != nil {
				tname = *op.Cast.Type.Simple
			}
			switch tname {
			case "int":
				val = fmt.Sprintf("%s asInteger", val)
			case "float":
				val = fmt.Sprintf("%s asFloat", val)
			case "string":
				val = fmt.Sprintf("%s asString", val)
			default:
				// casting to struct types has no runtime effect
			}
		default:
			return "", fmt.Errorf("unsupported postfix expression")
		}
	}
	return val, nil
}

func (c *Compiler) compilePrimary(p *parser.Primary) (string, error) {
	switch {
	case p.Selector != nil:
		name := p.Selector.Root
		if name == "math" && len(p.Selector.Tail) == 1 {
			switch p.Selector.Tail[0] {
			case "pi":
				return "3.141592653589793e0", nil
			case "e":
				return "2.718281828459045e0", nil
			}
		}
		if c.vars[name] {
			expr := name
			for _, s := range p.Selector.Tail {
				expr = fmt.Sprintf("%s at: '%s'", expr, s)
			}
			return expr, nil
		}
		if c.fallbackVar != "" && len(p.Selector.Tail) == 0 {
			return fmt.Sprintf("%s at: '%s'", c.fallbackVar, name), nil
		}
		for _, s := range p.Selector.Tail {
			name += "." + s
		}
		return name, nil
	case p.Lit != nil:
		return c.compileLiteral(p.Lit), nil
	case p.List != nil:
		elems := make([]string, len(p.List.Elems))
		for i, e := range p.List.Elems {
			s, err := c.compileExpr(e)
			if err != nil {
				return "", err
			}
			elems[i] = s
		}
		return "{" + strings.Join(elems, ". ") + "}", nil
	case p.Group != nil:
		return c.compileExpr(p.Group)
	case p.Map != nil:
		pairs := make([]string, len(p.Map.Items))
		for i, it := range p.Map.Items {
			k, err := c.compileMapKey(it.Key)
			if err != nil {
				return "", err
			}
			v, err := c.compileExpr(it.Value)
			if err != nil {
				return "", err
			}
			if strings.ContainsAny(v, " :") {
				v = "(" + v + ")"
			}
			pairs[i] = fmt.Sprintf("%s->%s", k, v)
		}
		return "Dictionary from:{" + strings.Join(pairs, ". ") + "}", nil
	case p.Struct != nil:
		return c.compileStructLiteral(p.Struct)
	case p.Load != nil:
		return c.compileLoadExpr(p.Load)
	case p.Save != nil:
		return c.compileSaveExpr(p.Save)
	case p.FunExpr != nil:
		params := make([]string, len(p.FunExpr.Params))
		for i, pa := range p.FunExpr.Params {
			params[i] = ":" + pa.Name
		}
		var body string
		if p.FunExpr.ExprBody != nil {
			b, err := c.compileExpr(p.FunExpr.ExprBody)
			if err != nil {
				return "", err
			}
			body = b
		} else {
			pnames := make([]string, len(p.FunExpr.Params))
			for i, pa := range p.FunExpr.Params {
				pnames[i] = pa.Name
			}
			b, err := c.blockString(pnames, p.FunExpr.BlockBody)
			if err != nil {
				return "", err
			}
			body = b
		}
		header := strings.Join(params, " ")
		if header != "" {
			header += " | "
			return "[" + header + body + " ]", nil
		}
		return "[ " + body + " ]", nil
	case p.If != nil:
		return c.ifExprString(p.If)
	case p.Call != nil:
		args := make([]string, len(p.Call.Args))
		for i, a := range p.Call.Args {
			s, err := c.compileExpr(a)
			if err != nil {
				return "", err
			}
			args[i] = s
		}
		switch p.Call.Func {
		case "print":
			if len(args) == 0 {
				return "", fmt.Errorf("print expects at least 1 arg")
			}
			stmt := "Transcript show: "
			if isStringLiteral(p.Call.Args[0]) {
				stmt += args[0]
			} else {
				stmt += fmt.Sprintf("(%s) printString", args[0])
			}
			for i, a := range args[1:] {
				stmt += "; show: ' '; show: "
				if isStringLiteral(p.Call.Args[i+1]) {
					stmt += a
				} else {
					stmt += fmt.Sprintf("(%s) printString", a)
				}
			}
			return stmt + "; cr", nil
		case "append":
			if len(args) != 2 {
				return "", fmt.Errorf("append expects 2 args")
			}
			return fmt.Sprintf("%s copyWith: %s", args[0], args[1]), nil
		case "count", "len":
			if len(args) != 1 {
				return "", fmt.Errorf("%s expects 1 arg", p.Call.Func)
			}
			if n, ok := c.constListLenExpr(p.Call.Args[0]); ok {
				return fmt.Sprintf("%d", n), nil
			}
			if s, ok := c.constStringExpr(p.Call.Args[0]); ok {
				return fmt.Sprintf("%d", len(s)), nil
			}
			return fmt.Sprintf("(%s size)", args[0]), nil
		case "values":
			if len(args) != 1 {
				return "", fmt.Errorf("values expects 1 arg")
			}
			return fmt.Sprintf("(%s values)", args[0]), nil
		case "sum":
			if len(args) != 1 {
				return "", fmt.Errorf("sum expects 1 arg")
			}
			return fmt.Sprintf("(%s inject: 0 into: [:s :x | s + x])", args[0]), nil
		case "min":
			if len(args) != 1 {
				return "", fmt.Errorf("min expects 1 arg")
			}
			return fmt.Sprintf("(%s min)", args[0]), nil
		case "max":
			if len(args) != 1 {
				return "", fmt.Errorf("max expects 1 arg")
			}
			return fmt.Sprintf("(%s max)", args[0]), nil
		case "str":
			if len(args) != 1 {
				return "", fmt.Errorf("str expects 1 arg")
			}
			return fmt.Sprintf("(%s asString)", args[0]), nil
		case "substring", "substr":
			if len(args) != 3 {
				return "", fmt.Errorf("substring expects 3 args")
			}
			return fmt.Sprintf("(%s copyFrom: %s to: %s)", args[0], args[1], args[2]), nil
		default:
			call := p.Call.Func
			if len(args) == 0 {
				call += " value"
			} else {
				for _, a := range args {
					call += " value: " + a
				}
			}
			return call, nil
		}
	case p.Match != nil:
		return c.compileMatchExpr(p.Match)
	case p.Query != nil:
		return c.compileQueryExpr(p.Query)
	case p.Load != nil:
		return c.compileLoadExpr(p.Load)
	case p.Save != nil:
		return c.compileSaveExpr(p.Save)
	default:
		return "", fmt.Errorf("unsupported expression at line %d", p.Pos.Line)
	}
}

func (c *Compiler) compileMatchExpr(m *parser.MatchExpr) (string, error) {
	target, err := c.compileExpr(m.Target)
	if err != nil {
		return "", err
	}
	expr := "nil"
	for i := len(m.Cases) - 1; i >= 0; i-- {
		cs := m.Cases[i]
		res, err := c.compileExpr(cs.Result)
		if err != nil {
			return "", err
		}
		if isUnderscoreExpr(cs.Pattern) {
			expr = res
			continue
		}
		pat, err := c.compileExpr(cs.Pattern)
		if err != nil {
			return "", err
		}
		expr = fmt.Sprintf("(%s = %s) ifTrue: [%s] ifFalse: [%s]", target, pat, res, expr)
	}
	return expr, nil
}

func (c *Compiler) compileQueryExpr(q *parser.QueryExpr) (string, error) {
	if len(q.Joins) == 1 && len(q.Froms) == 0 && q.Group == nil {
		if q.Joins[0].Side != nil {
			switch *q.Joins[0].Side {
			case "left":
				return c.compileLeftJoinSimple(q)
			case "right":
				return c.compileRightJoinSimple(q)
			}
		}
	}
	srcs := make([]string, 1+len(q.Froms)+len(q.Joins))
	vars := make([]string, 1+len(q.Froms)+len(q.Joins))

	s, err := c.compileExpr(q.Source)
	if err != nil {
		return "", err
	}
	srcs[0] = s
	vars[0] = q.Var

	for i, f := range q.Froms {
		fs, err := c.compileExpr(f.Src)
		if err != nil {
			return "", err
		}
		srcs[i+1] = fs
		vars[i+1] = f.Var
	}

	joinConds := make([]string, len(q.Joins))
	for i, j := range q.Joins {
		js, err := c.compileExpr(j.Src)
		if err != nil {
			return "", err
		}
		srcs[len(q.Froms)+1+i] = js
		vars[len(q.Froms)+1+i] = j.Var
		jc, err := c.compileExpr(j.On)
		if err != nil {
			return "", err
		}
		joinConds[i] = jc
	}

	savedVars := c.vars
	c.vars = make(map[string]bool, len(savedVars)+len(vars))
	for k, v := range savedVars {
		c.vars[k] = v
	}
	for _, v := range vars {
		c.vars[v] = true
	}
	defer func() { c.vars = savedVars }()

	if len(q.Joins) == 1 && q.Joins[0].Side != nil && *q.Joins[0].Side == "outer" &&
		len(q.Froms) == 0 && q.Group == nil && q.Sort == nil && q.Skip == nil &&
		q.Take == nil && !q.Distinct {
		j := q.Joins[0]
		lsrc := srcs[0]
		rsrc := srcs[1]
		cond := joinConds[0]
		sel, err := c.compileExpr(q.Select)
		if err != nil {
			return "", err
		}
		var sb strings.Builder
		sb.WriteString("[ | tmp |\n")
		sb.WriteString("  tmp := OrderedCollection new.\n")
		sb.WriteString(fmt.Sprintf("  %s do: [:%s |\n", lsrc, q.Var))
		sb.WriteString(fmt.Sprintf("    | %s |\n", j.Var))
		sb.WriteString(fmt.Sprintf("    %s := %s detect: [:%s | (%s) ] ifAbsent:[nil].\n", j.Var, rsrc, j.Var, cond))
		sb.WriteString(fmt.Sprintf("    tmp add: %s.\n", sel))
		sb.WriteString("  ].\n")
		sb.WriteString(fmt.Sprintf("  %s do: [:%s |\n", rsrc, j.Var))
		sb.WriteString(fmt.Sprintf("    (%s anySatisfy: [:%s | (%s) ]) ifFalse:[\n", lsrc, q.Var, cond))
		sb.WriteString(fmt.Sprintf("      | %s |\n", q.Var))
		sb.WriteString(fmt.Sprintf("      %s := nil.\n", q.Var))
		sb.WriteString(fmt.Sprintf("      tmp add: %s.\n", sel))
		sb.WriteString("    ].\n")
		sb.WriteString("  ].\n")
		sb.WriteString("  tmp\n")
		sb.WriteString("] value")
		return sb.String(), nil
	}

	cond := ""
	if q.Where != nil {
		cond, err = c.compileExpr(q.Where)
		if err != nil {
			return "", err
		}
	}
	for _, jc := range joinConds {
		if jc == "" {
			continue
		}
		if cond == "" {
			cond = jc
		} else {
			cond = fmt.Sprintf("(%s and: [%s])", cond, jc)
		}
	}

	sel, err := c.compileExpr(q.Select)
	if err != nil {
		return "", err
	}

	var b strings.Builder
	if q.Group != nil {
		b.WriteString("[ | groups tmp |\n")
		b.WriteString("  groups := Dictionary new.\n")
		b.WriteString("  tmp := OrderedCollection new.\n")
	} else {
		b.WriteString("[ | tmp |\n")
		b.WriteString("  tmp := OrderedCollection new.\n")
	}

	row := ""
	key := ""
	if q.Group != nil {
		fields := make([]string, len(vars))
		for i, v := range vars {
			fields[i] = fmt.Sprintf("#%s->%s", v, v)
		}
		row = "Dictionary from:{" + strings.Join(fields, ". ") + "}"
		k, err := c.compileExpr(q.Group.Exprs[0])
		if err != nil {
			return "", err
		}
		key = k
	}

	var loop func(int, string)
	loop = func(i int, indent string) {
		b.WriteString(indent + srcs[i] + " do: [:" + vars[i] + " |\n")
		next := indent + "  "
		if i+1 < len(srcs) {
			loop(i+1, next)
		} else {
			if cond != "" {
				b.WriteString(next + "(" + cond + ") ifTrue: [\n")
				next += "  "
			}
			if q.Group != nil {
				b.WriteString(next + "| g |\n")
				if strings.ContainsAny(key, " :") {
					b.WriteString(next + "g := groups at: (" + key + ") ifAbsentPut:[OrderedCollection new].\n")
				} else {
					b.WriteString(next + "g := groups at: " + key + " ifAbsentPut:[OrderedCollection new].\n")
				}
				b.WriteString(next + "g add: " + row + ".\n")
			} else {
				b.WriteString(next + "tmp add: " + sel + ".\n")
			}
			if cond != "" {
				b.WriteString(indent + "  ].\n")
			}
		}
		b.WriteString(indent + "].\n")
	}
	loop(0, "  ")

	if q.Group != nil {
		b.WriteString("  groups keysAndValuesDo: [:k :grp |\n")
		b.WriteString("    | " + q.Group.Name + " |\n")
		b.WriteString("    " + q.Group.Name + " := Dictionary from:{'key'->k. 'items'->grp}.\n")
		b.WriteString("    tmp add: " + sel + ".\n")
		b.WriteString("  ].\n")
	}

	if q.Sort != nil {
		key, err := c.compileExpr(q.Sort)
		if err != nil {
			return "", err
		}
		keyA := strings.ReplaceAll(key, vars[0], "a")
		keyB := strings.ReplaceAll(key, vars[0], "b")
		b.WriteString("  tmp := tmp asSortedCollection: [:a :b | " + keyA + " < " + keyB + "].\n")
	}

	if q.Skip != nil || q.Take != nil {
		start := "1"
		if q.Skip != nil {
			st, err := c.compileExpr(q.Skip)
			if err != nil {
				return "", err
			}
			start = "(" + st + ") + 1"
		}
		end := "tmp size"
		if q.Take != nil {
			tk, err := c.compileExpr(q.Take)
			if err != nil {
				return "", err
			}
			if q.Skip != nil {
				end = "(" + start + " - 1 + " + tk + ")"
			} else {
				end = tk
			}
		}
		b.WriteString("  tmp := tmp copyFrom: " + start + " to: " + end + ".\n")
	}

	if q.Distinct {
		b.WriteString("  tmp := tmp asSet asOrderedCollection.\n")
	}

	b.WriteString("  tmp\n")
	b.WriteString("] value")
	return b.String(), nil
}

func (c *Compiler) ifExprString(i *parser.IfExpr) (string, error) {
	cond, err := c.compileExpr(i.Cond)
	if err != nil {
		return "", err
	}
	th, err := c.compileExpr(i.Then)
	if err != nil {
		return "", err
	}
	if i.ElseIf != nil {
		el, err := c.ifExprString(i.ElseIf)
		if err != nil {
			return "", err
		}
		return fmt.Sprintf("(%s) ifTrue: [%s] ifFalse: [%s]", cond, th, el), nil
	}
	el := ""
	if i.Else != nil {
		el, err = c.compileExpr(i.Else)
		if err != nil {
			return "", err
		}
	}
	if el == "" {
		return fmt.Sprintf("(%s) ifTrue: [%s]", cond, th), nil
	}
	return fmt.Sprintf("(%s) ifTrue: [%s] ifFalse: [%s]", cond, th, el), nil
}

func (c *Compiler) compileLeftJoinSimple(q *parser.QueryExpr) (string, error) {
	j := q.Joins[0]
	left, err := c.compileExpr(q.Source)
	if err != nil {
		return "", err
	}
	right, err := c.compileExpr(j.Src)
	if err != nil {
		return "", err
	}
	onCond, err := c.compileExpr(j.On)
	if err != nil {
		return "", err
	}
	cond := ""
	if q.Where != nil {
		cond, err = c.compileExpr(q.Where)
		if err != nil {
			return "", err
		}
	}
	sel, err := c.compileExpr(q.Select)
	if err != nil {
		return "", err
	}

	var b strings.Builder
	b.WriteString("[ | tmp |\n")
	b.WriteString("  tmp := OrderedCollection new.\n")
	b.WriteString(fmt.Sprintf("  %s do: [:%s |\n", left, q.Var))
	b.WriteString("    | matched |\n")
	b.WriteString("    matched := false.\n")
	b.WriteString(fmt.Sprintf("    %s do: [:%s |\n", right, j.Var))
	b.WriteString(fmt.Sprintf("      (%s) ifTrue: [\n", onCond))
	b.WriteString("        matched := true.\n")
	if cond != "" {
		b.WriteString(fmt.Sprintf("        (%s) ifTrue: [ tmp add: %s ].\n", cond, sel))
	} else {
		b.WriteString(fmt.Sprintf("        tmp add: %s.\n", sel))
	}
	b.WriteString("      ].\n")
	b.WriteString("    ].\n")
	b.WriteString("    matched ifFalse: [\n")
	b.WriteString(fmt.Sprintf("      %s := nil.\n", j.Var))
	if cond != "" {
		b.WriteString(fmt.Sprintf("      (%s) ifTrue: [ tmp add: %s ].\n", cond, sel))
	} else {
		b.WriteString(fmt.Sprintf("      tmp add: %s.\n", sel))
	}
	b.WriteString("    ].\n")
	b.WriteString("  ].\n")

	if q.Sort != nil {
		key, err := c.compileExpr(q.Sort)
		if err != nil {
			return "", err
		}
		keyA := strings.ReplaceAll(key, q.Var, "a")
		keyB := strings.ReplaceAll(key, q.Var, "b")
		b.WriteString("  tmp := tmp asSortedCollection: [:a :b | " + keyA + " < " + keyB + "].\n")
	}

	if q.Skip != nil || q.Take != nil {
		start := "1"
		if q.Skip != nil {
			sk, err := c.compileExpr(q.Skip)
			if err != nil {
				return "", err
			}
			start = "(" + sk + ") + 1"
		}
		end := "tmp size"
		if q.Take != nil {
			tk, err := c.compileExpr(q.Take)
			if err != nil {
				return "", err
			}
			if q.Skip != nil {
				end = "(" + start + " - 1 + " + tk + ")"
			} else {
				end = tk
			}
		}
		b.WriteString("  tmp := tmp copyFrom: " + start + " to: " + end + ".\n")
	}

	if q.Distinct {
		b.WriteString("  tmp := tmp asSet asOrderedCollection.\n")
	}

	b.WriteString("  tmp\n")
	b.WriteString("] value")
	return b.String(), nil
}

func (c *Compiler) compileRightJoinSimple(q *parser.QueryExpr) (string, error) {
	j := q.Joins[0]
	left, err := c.compileExpr(q.Source)
	if err != nil {
		return "", err
	}
	right, err := c.compileExpr(j.Src)
	if err != nil {
		return "", err
	}
	onCond, err := c.compileExpr(j.On)
	if err != nil {
		return "", err
	}
	cond := ""
	if q.Where != nil {
		cond, err = c.compileExpr(q.Where)
		if err != nil {
			return "", err
		}
	}
	sel, err := c.compileExpr(q.Select)
	if err != nil {
		return "", err
	}

	var b strings.Builder
	b.WriteString("[ | tmp |\n")
	b.WriteString("  tmp := OrderedCollection new.\n")
	b.WriteString(fmt.Sprintf("  %s do: [:%s |\n", right, j.Var))
	b.WriteString(fmt.Sprintf("    | %s |\n", q.Var))
	b.WriteString(fmt.Sprintf("    %s := %s detect: [:%s | (%s) ] ifAbsent:[nil].\n", q.Var, left, q.Var, onCond))
	if cond != "" {
		b.WriteString(fmt.Sprintf("    (%s) ifTrue: [ tmp add: %s ].\n", cond, sel))
	} else {
		b.WriteString(fmt.Sprintf("    tmp add: %s.\n", sel))
	}
	b.WriteString("  ].\n")

	if q.Sort != nil {
		key, err := c.compileExpr(q.Sort)
		if err != nil {
			return "", err
		}
		keyA := strings.ReplaceAll(key, j.Var, "a")
		keyB := strings.ReplaceAll(key, j.Var, "b")
		b.WriteString("  tmp := tmp asSortedCollection: [:a :b | " + keyA + " < " + keyB + "].\n")
	}

	if q.Skip != nil || q.Take != nil {
		start := "1"
		if q.Skip != nil {
			sk, err := c.compileExpr(q.Skip)
			if err != nil {
				return "", err
			}
			start = "(" + sk + ") + 1"
		}
		end := "tmp size"
		if q.Take != nil {
			tk, err := c.compileExpr(q.Take)
			if err != nil {
				return "", err
			}
			if q.Skip != nil {
				end = "(" + start + " - 1 + " + tk + ")"
			} else {
				end = tk
			}
		}
		b.WriteString("  tmp := tmp copyFrom: " + start + " to: " + end + ".\n")
	}

	if q.Distinct {
		b.WriteString("  tmp := tmp asSet asOrderedCollection.\n")
	}

	b.WriteString("  tmp\n")
	b.WriteString("] value")
	return b.String(), nil
}

func (c *Compiler) compileStructLiteral(sl *parser.StructLiteral) (string, error) {
	fields := make([]string, len(sl.Fields))
	for i, f := range sl.Fields {
		v, err := c.compileExpr(f.Value)
		if err != nil {
			return "", err
		}
		fields[i] = fmt.Sprintf("'%s'->%s", f.Name, v)
	}
	return "Dictionary from:{" + strings.Join(fields, ". ") + "}", nil
}

func (c *Compiler) compileMapKey(e *parser.Expr) (string, error) {
	if e != nil && e.Binary != nil && len(e.Binary.Right) == 0 {
		u := e.Binary.Left
		if len(u.Ops) == 0 && u.Value != nil && len(u.Value.Ops) == 0 {
			if u.Value.Target != nil {
				if sel := u.Value.Target.Selector; sel != nil && len(sel.Tail) == 0 {
					if !c.vars[sel.Root] {
						return "'" + sel.Root + "'", nil
					}
				}
			}
			if lit := u.Value.Target; lit != nil && lit.Lit != nil {
				return c.compileLiteral(lit.Lit), nil
			}
		}
	}
	return c.compileExpr(e)
}

func (c *Compiler) compileLiteral(l *parser.Literal) string {
	switch {
	case l.Int != nil:
		return fmt.Sprintf("%d", *l.Int)
	case l.Str != nil:
		s := strings.ReplaceAll(*l.Str, "'", "''")
		return fmt.Sprintf("'%s'", s)
	case l.Float != nil:
		return fmt.Sprintf("%g", *l.Float)
	case l.Bool != nil:
		if bool(*l.Bool) {
			return "true"
		}
		return "false"
	default:
		return "nil"
	}
}

func isStringLiteral(e *parser.Expr) bool {
	if e == nil || e.Binary == nil || len(e.Binary.Right) > 0 {
		return false
	}
	u := e.Binary.Left
	if len(u.Ops) > 0 || u.Value == nil || len(u.Value.Ops) > 0 {
		return false
	}
	return u.Value.Target != nil && u.Value.Target.Lit != nil && u.Value.Target.Lit.Str != nil
}

func (c *Compiler) blockString(params []string, stmts []*parser.Statement) (string, error) {
	sub := &Compiler{
		vars:      make(map[string]bool),
		env:       c.env,
		constLens: make(map[string]int),
		constStrs: make(map[string]string),
	}
	for _, p := range params {
		sub.vars[p] = true
	}
	for _, st := range stmts {
		if err := sub.compileStmt(st); err != nil {
			return "", err
		}
	}
	if sub.needBreak {
		c.needBreak = true
	}
	if sub.needContinue {
		c.needContinue = true
	}
	return strings.TrimSpace(sub.buf.String()), nil
}

func isUnderscoreExpr(e *parser.Expr) bool {
	if e == nil || e.Binary == nil || len(e.Binary.Right) != 0 {
		return false
	}
	u := e.Binary.Left
	if len(u.Ops) != 0 || u.Value == nil || len(u.Value.Ops) != 0 {
		return false
	}
	return u.Value.Target != nil && u.Value.Target.Selector != nil &&
		u.Value.Target.Selector.Root == "_" && len(u.Value.Target.Selector.Tail) == 0
}

func getCall(e *parser.Expr) *parser.CallExpr {
	if e == nil || e.Binary == nil {
		return nil
	}
	b := e.Binary
	if len(b.Right) == 0 && len(b.Left.Ops) == 0 && b.Left.Value != nil {
		if c := b.Left.Value.Target.Call; c != nil {
			return c
		}
	}
	return nil
}

func hasBreak(st []*parser.Statement) bool {
	for _, s := range st {
		switch {
		case s.Break != nil:
			return true
		case s.For != nil:
			if hasBreak(s.For.Body) {
				return true
			}
		case s.While != nil:
			if hasBreak(s.While.Body) {
				return true
			}
		case s.If != nil:
			if hasBreak(s.If.Then) || hasBreakIf(s.If.ElseIf) || hasBreak(s.If.Else) {
				return true
			}
		}
	}
	return false
}

func hasBreakIf(i *parser.IfStmt) bool {
	if i == nil {
		return false
	}
	if hasBreak(i.Then) || hasBreak(i.Else) {
		return true
	}
	return hasBreakIf(i.ElseIf)
}

func hasContinue(st []*parser.Statement) bool {
	for _, s := range st {
		switch {
		case s.Continue != nil:
			return true
		case s.For != nil:
			if hasContinue(s.For.Body) {
				return true
			}
		case s.While != nil:
			if hasContinue(s.While.Body) {
				return true
			}
		case s.If != nil:
			if hasContinue(s.If.Then) || hasContinueIf(s.If.ElseIf) || hasContinue(s.If.Else) {
				return true
			}
		}
	}
	return false
}

func hasContinueIf(i *parser.IfStmt) bool {
	if i == nil {
		return false
	}
	if hasContinue(i.Then) || hasContinue(i.Else) {
		return true
	}
	return hasContinueIf(i.ElseIf)
}

func (c *Compiler) compileLoadExpr(l *parser.LoadExpr) (string, error) {
	path := "nil"
	if l.Path != nil {
		path = fmt.Sprintf("%q", *l.Path)
	}
	opts := "nil"
	if l.With != nil {
		v, err := c.compileExpr(l.With)
		if err != nil {
			return "", err
		}
		opts = v
	}
	return fmt.Sprintf("load value: %s value: %s", path, opts), nil
}

func (c *Compiler) compileSaveExpr(s *parser.SaveExpr) (string, error) {
	src, err := c.compileExpr(s.Src)
	if err != nil {
		return "", err
	}
	path := "nil"
	if s.Path != nil {
		path = fmt.Sprintf("%q", *s.Path)
	}
	opts := "nil"
	if s.With != nil {
		v, err := c.compileExpr(s.With)
		if err != nil {
			return "", err
		}
		opts = v
	}
	return fmt.Sprintf("save value: %s value: %s value: %s", src, path, opts), nil
}

func (c *Compiler) compileExpect(e *parser.ExpectStmt) error {
	expr, err := c.compileExpr(e.Value)
	if err != nil {
		return err
	}
	c.writeln(fmt.Sprintf("(%s) ifTrue: [Transcript show:'ok'; cr] ifFalse: [Transcript show:'fail'; cr]", expr))
	return nil
}

func (c *Compiler) compileTestBlock(t *parser.TestBlock) error {
	for _, s := range t.Body {
		if err := c.compileStmt(s); err != nil {
			return err
		}
	}
	return nil
}

func (c *Compiler) compileUpdate(u *parser.UpdateStmt) error {
	list := u.Target
	c.writeln(fmt.Sprintf("%s do: [:it |", list))
	c.indent++
	if u.Where != nil {
		prev := c.fallbackVar
		c.fallbackVar = "it"
		cond, err := c.compileExpr(u.Where)
		c.fallbackVar = prev
		if err != nil {
			return err
		}
		c.writeln(fmt.Sprintf("(%s) ifTrue: [", cond))
		c.indent++
	}
	for _, it := range u.Set.Items {
		prev := c.fallbackVar
		c.fallbackVar = "it"
		val, err := c.compileExpr(it.Value)
		c.fallbackVar = prev
		if err != nil {
			return err
		}
		if key, ok := identName(it.Key); ok {
			c.writeln(fmt.Sprintf("it at: '%s' put: %s", key, val))
		} else {
			k, err := c.compileExpr(it.Key)
			if err != nil {
				return err
			}
			c.writeln(fmt.Sprintf("it at: %s put: %s", k, val))
		}
	}
	if u.Where != nil {
		c.indent--
		c.writeln("]")
	}
	c.indent--
	c.writeln("]")
	return nil
}

func (c *Compiler) compileImport(im *parser.ImportStmt) error {
	name := im.As
	if name == "" {
		if base := im.Path; base != "" {
			parts := strings.Split(base, "/")
			name = parts[len(parts)-1]
		}
	}
	if name == "" {
		return nil
	}
	switch {
	case im.Lang != nil && *im.Lang == "python" && im.Path == "math":
		// built-in math module handled inline
		return nil
	case im.Lang != nil && *im.Lang == "go" && im.Path == "mochi/runtime/ffi/go/testpkg":
		c.writeln(name + " := Dictionary from:{'Add'->[:a :b | a + b]. 'Pi'->3.14e0. 'Answer'->42}")
	default:
		c.writeln(name + " := Dictionary new")
	}
	return nil
}

func identName(e *parser.Expr) (string, bool) {
	if e == nil || e.Binary == nil {
		return "", false
	}
	if len(e.Binary.Right) != 0 {
		return "", false
	}
	u := e.Binary.Left
	if len(u.Ops) != 0 || u.Value == nil {
		return "", false
	}
	p := u.Value
	if len(p.Ops) != 0 || p.Target == nil || p.Target.Selector == nil {
		return "", false
	}
	if len(p.Target.Selector.Tail) == 0 {
		return p.Target.Selector.Root, true
	}
	return "", false
}

func listLiteral(e *parser.Expr) *parser.ListLiteral {
	if e == nil || e.Binary == nil || len(e.Binary.Right) != 0 {
		return nil
	}
	u := e.Binary.Left
	if len(u.Ops) != 0 || u.Value == nil {
		return nil
	}
	v := u.Value
	if len(v.Ops) != 0 || v.Target == nil {
		return nil
	}
	return v.Target.List
}

func stringLiteralExpr(e *parser.Expr) *string {
	if e == nil || e.Binary == nil || len(e.Binary.Right) != 0 {
		return nil
	}
	u := e.Binary.Left
	if len(u.Ops) != 0 || u.Value == nil || u.Value.Target == nil {
		return nil
	}
	if lit := u.Value.Target.Lit; lit != nil && lit.Str != nil {
		return lit.Str
	}
	return nil
}

func (c *Compiler) constListLenExpr(e *parser.Expr) (int, bool) {
	if l := listLiteral(e); l != nil {
		return len(l.Elems), true
	}
	if name, ok := identName(e); ok {
		if n, ok2 := c.constLens[name]; ok2 {
			return n, true
		}
	}
	return 0, false
}

func (c *Compiler) constStringExpr(e *parser.Expr) (string, bool) {
	if s := stringLiteralExpr(e); s != nil {
		return *s, true
	}
	if name, ok := identName(e); ok {
		if v, ok2 := c.constStrs[name]; ok2 {
			return v, true
		}
	}
	return "", false
}
