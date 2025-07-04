package any2mochi

import (
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"

	protocol "github.com/tliron/glsp/protocol_3_16"
	luaast "github.com/yuin/gopher-lua/ast"
	luaparse "github.com/yuin/gopher-lua/parse"
)

// ConvertLua converts lua source code to Mochi using the language server.
func ConvertLua(src string) ([]byte, error) {
	ls := Servers["lua"]
	syms, diags, err := EnsureAndParse(ls.Command, ls.Args, ls.LangID, src)
	if err != nil {
		return nil, err
	}
	if len(diags) > 0 {
		return nil, fmt.Errorf("%s", formatDiagnostics(src, diags))
	}
	chunk, _ := luaparse.Parse(bytes.NewReader([]byte(src)), "src.lua")
	fnMap := map[int]*luaast.FunctionExpr{}
	collectLuaFuncs(chunk, fnMap)

	var out strings.Builder
	writeLuaSymbols(&out, nil, syms, src, ls, fnMap)
	if out.Len() == 0 {
		return nil, fmt.Errorf("no convertible symbols found\n\nsource snippet:\n%s", numberedSnippet(src))
	}
	return []byte(out.String()), nil
}

func writeLuaSymbols(out *strings.Builder, prefix []string, syms []protocol.DocumentSymbol, src string, ls LanguageServer, fns map[int]*luaast.FunctionExpr) {
	for _, s := range syms {
		nameParts := prefix
		if s.Name != "" {
			nameParts = append(nameParts, s.Name)
		}
		switch s.Kind {
		case protocol.SymbolKindFunction, protocol.SymbolKindMethod:
			fn := fns[int(s.Range.Start.Line)]
			writeLuaFunc(out, strings.Join(nameParts, "."), s, src, ls, fn)
		case protocol.SymbolKindStruct, protocol.SymbolKindClass, protocol.SymbolKindInterface:
			writeLuaType(out, strings.Join(nameParts, "."), s, src, ls, fns)
		case protocol.SymbolKindVariable, protocol.SymbolKindConstant:
			if len(prefix) == 0 {
				out.WriteString("let ")
				out.WriteString(strings.Join(nameParts, "."))
				typ := parseLuaVarDetail(s.Detail)
				if typ == "" {
					typ = getLuaVarType(src, s.SelectionRange.Start, ls)
				}
				if typ != "" && typ != "Unknown" {
					out.WriteString(": ")
					out.WriteString(typ)
				}
				out.WriteByte('\n')
			}
		}
		if len(s.Children) > 0 {
			writeLuaSymbols(out, nameParts, s.Children, src, ls, fns)
		}
	}
}

type luaParam struct {
	name string
	typ  string
}

func writeLuaFunc(out *strings.Builder, name string, sym protocol.DocumentSymbol, src string, ls LanguageServer, fn *luaast.FunctionExpr) {
	params, ret := parseLuaDetail(sym.Detail)
	if len(params) == 0 && ret == "" {
		params, ret = luaHoverSignature(src, sym, ls)
	}
	if len(params) == 0 && ret == "" {
		params, ret = luaSourceSignature(src, sym)
	}
	out.WriteString("fun ")
	out.WriteString(name)
	out.WriteByte('(')
	for i, p := range params {
		if i > 0 {
			out.WriteString(", ")
		}
		out.WriteString(p.name)
		if p.typ != "" {
			out.WriteString(": ")
			out.WriteString(p.typ)
		}
	}
	out.WriteByte(')')
	if ret != "" && ret != "void" {
		out.WriteString(": ")
		out.WriteString(ret)
	}
	out.WriteString(" {")
	if fn != nil {
		out.WriteByte('\n')
		for _, line := range convertLuaStmts(fn.Stmts, 1) {
			out.WriteString(line)
			out.WriteByte('\n')
		}
	}
	out.WriteString("}\n")
}

func luaHoverSignature(src string, sym protocol.DocumentSymbol, ls LanguageServer) ([]luaParam, string) {
	hov, err := EnsureAndHover(ls.Command, ls.Args, ls.LangID, src, sym.SelectionRange.Start)
	if err != nil {
		return nil, ""
	}
	sig := hoverString(hov)
	return parseLuaSignature(sig)
}

func parseLuaSignature(sig string) ([]luaParam, string) {
	sig = strings.ReplaceAll(sig, "\n", " ")
	if i := strings.Index(sig, "function"); i != -1 {
		sig = strings.TrimSpace(sig[i+len("function"):])
	}
	open := strings.Index(sig, "(")
	close := strings.LastIndex(sig, ")")
	if open == -1 || close == -1 || close < open {
		return nil, mapLuaType(strings.TrimSpace(sig))
	}
	paramsPart := strings.TrimSpace(sig[open+1 : close])
	rest := strings.TrimSpace(sig[close+1:])
	ret := ""
	if strings.HasPrefix(rest, ":") {
		ret = strings.TrimSpace(rest[1:])
	} else if strings.HasPrefix(rest, "->") {
		ret = strings.TrimSpace(rest[2:])
	}
	var params []luaParam
	if paramsPart != "" {
		for _, p := range strings.Split(paramsPart, ",") {
			p = strings.TrimSpace(p)
			if p == "" {
				continue
			}
			name := p
			typ := ""
			if colon := strings.Index(p, ":"); colon != -1 {
				name = strings.TrimSpace(p[:colon])
				typ = mapLuaType(strings.TrimSpace(p[colon+1:]))
			}
			params = append(params, luaParam{name: name, typ: typ})
		}
	}
	return params, mapLuaType(ret)
}

func parseLuaDetail(detail *string) ([]luaParam, string) {
	if detail == nil {
		return nil, ""
	}
	d := strings.TrimSpace(*detail)
	if strings.HasPrefix(d, "function") {
		d = strings.TrimSpace(d[len("function"):])
	}
	open := strings.Index(d, "(")
	close := strings.LastIndex(d, ")")
	if open == -1 || close == -1 || close < open {
		return nil, mapLuaType(strings.TrimSpace(d))
	}
	paramsPart := strings.TrimSpace(d[open+1 : close])
	rest := strings.TrimSpace(d[close+1:])
	ret := ""
	if strings.HasPrefix(rest, ":") {
		ret = strings.TrimSpace(rest[1:])
	} else if strings.HasPrefix(rest, "->") {
		ret = strings.TrimSpace(rest[2:])
	}
	var params []luaParam
	if paramsPart != "" {
		for _, p := range strings.Split(paramsPart, ",") {
			p = strings.TrimSpace(p)
			if p == "" {
				continue
			}
			name := p
			typ := ""
			if colon := strings.Index(p, ":"); colon != -1 {
				name = strings.TrimSpace(p[:colon])
				typ = mapLuaType(strings.TrimSpace(p[colon+1:]))
			}
			params = append(params, luaParam{name: name, typ: typ})
		}
	}
	return params, mapLuaType(ret)
}

func luaSourceSignature(src string, sym protocol.DocumentSymbol) ([]luaParam, string) {
	lines := strings.Split(src, "\n")
	if int(sym.Range.Start.Line) >= len(lines) {
		return nil, ""
	}
	line := strings.TrimSpace(lines[sym.Range.Start.Line])
	if !strings.HasPrefix(line, "function") {
		return nil, ""
	}
	if open := strings.Index(line, "("); open != -1 {
		if close := strings.Index(line, ")"); close > open {
			paramsPart := strings.TrimSpace(line[open+1 : close])
			var params []luaParam
			if paramsPart != "" {
				for _, p := range strings.Split(paramsPart, ",") {
					p = strings.TrimSpace(p)
					if p != "" {
						params = append(params, luaParam{name: p})
					}
				}
			}
			return params, ""
		}
	}
	return nil, ""
}

func parseLuaVarDetail(detail *string) string {
	if detail == nil {
		return ""
	}
	d := strings.TrimSpace(*detail)
	if colon := strings.Index(d, ":"); colon != -1 {
		return mapLuaType(strings.TrimSpace(d[colon+1:]))
	}
	return ""
}

func writeLuaType(out *strings.Builder, name string, sym protocol.DocumentSymbol, src string, ls LanguageServer, fns map[int]*luaast.FunctionExpr) {
	out.WriteString("type ")
	out.WriteString(name)
	if len(sym.Children) == 0 {
		out.WriteString(" {}\n")
		return
	}
	out.WriteString(" {\n")
	for _, c := range sym.Children {
		switch c.Kind {
		case protocol.SymbolKindField, protocol.SymbolKindVariable, protocol.SymbolKindConstant:
			out.WriteString("  ")
			out.WriteString(c.Name)
			typ := parseLuaVarDetail(c.Detail)
			if typ == "" {
				typ = getLuaVarType(src, c.SelectionRange.Start, ls)
			}
			if typ != "" && typ != "Unknown" {
				out.WriteString(": ")
				out.WriteString(typ)
			}
			out.WriteByte('\n')
		case protocol.SymbolKindFunction, protocol.SymbolKindMethod:
			var b strings.Builder
			fn := fns[int(c.Range.Start.Line)]
			writeLuaFunc(&b, c.Name, c, src, ls, fn)
			for _, line := range strings.Split(strings.TrimSuffix(b.String(), "\n"), "\n") {
				out.WriteString("  ")
				out.WriteString(line)
				out.WriteByte('\n')
			}
		}
	}
	out.WriteString("}\n")
}

func getLuaVarType(src string, pos protocol.Position, ls LanguageServer) string {
	hov, err := EnsureAndHover(ls.Command, ls.Args, ls.LangID, src, pos)
	if err != nil {
		return ""
	}
	sig := hoverString(hov)
	return parseLuaVarType(sig)
}

func parseLuaVarType(hov string) string {
	if i := strings.Index(hov, "\n"); i != -1 {
		hov = hov[:i]
	}
	if colon := strings.Index(hov, ":"); colon != -1 {
		typ := strings.TrimSpace(hov[colon+1:])
		return mapLuaType(typ)
	}
	return ""
}

func mapLuaType(t string) string {
	switch strings.TrimSpace(t) {
	case "number":
		return "float"
	case "integer":
		return "int"
	case "string":
		return "string"
	case "boolean":
		return "bool"
	default:
		return strings.TrimSpace(t)
	}
}

func collectLuaFuncs(stmts []luaast.Stmt, m map[int]*luaast.FunctionExpr) {
	for _, st := range stmts {
		switch s := st.(type) {
		case *luaast.FuncDefStmt:
			m[s.Line()-1] = s.Func
		case *luaast.DoBlockStmt:
			collectLuaFuncs(s.Stmts, m)
		case *luaast.WhileStmt:
			collectLuaFuncs(s.Stmts, m)
		case *luaast.RepeatStmt:
			collectLuaFuncs(s.Stmts, m)
		case *luaast.IfStmt:
			collectLuaFuncs(s.Then, m)
			collectLuaFuncs(s.Else, m)
		case *luaast.NumberForStmt:
			collectLuaFuncs(s.Stmts, m)
		case *luaast.GenericForStmt:
			collectLuaFuncs(s.Stmts, m)
		case *luaast.LocalAssignStmt:
			for _, e := range s.Exprs {
				if fn, ok := e.(*luaast.FunctionExpr); ok {
					m[e.Line()-1] = fn
				}
			}
		}
	}
}

func convertLuaStmts(stmts []luaast.Stmt, indent int) []string {
	ind := strings.Repeat("  ", indent)
	var out []string
	for _, st := range stmts {
		switch s := st.(type) {
		case *luaast.LocalAssignStmt:
			for i, n := range s.Names {
				if i < len(s.Exprs) {
					if fn, ok := s.Exprs[i].(*luaast.FunctionExpr); ok {
						out = append(out, ind+"fun "+n+luaFuncSignature(fn)+" {")
						out = append(out, convertLuaStmts(fn.Stmts, indent+1)...)
						out = append(out, ind+"}")
						continue
					}
				}
				val := ""
				if i < len(s.Exprs) {
					val = luaExprString(s.Exprs[i])
				}
				out = append(out, ind+"let "+n+" = "+val)
			}
		case *luaast.AssignStmt:
			for i, lh := range s.Lhs {
				name := luaExprString(lh)
				val := ""
				if i < len(s.Rhs) {
					val = luaExprString(s.Rhs[i])
				}
				out = append(out, ind+name+" = "+val)
			}
		case *luaast.ReturnStmt:
			if len(s.Exprs) == 0 {
				out = append(out, ind+"return")
			} else if len(s.Exprs) == 1 {
				out = append(out, ind+"return "+luaExprString(s.Exprs[0]))
			} else {
				var parts []string
				for _, e := range s.Exprs {
					parts = append(parts, luaExprString(e))
				}
				out = append(out, ind+"return ("+strings.Join(parts, ", ")+")")
			}
		case *luaast.FuncCallStmt:
			out = append(out, ind+luaExprString(s.Expr))
		case *luaast.BreakStmt:
			out = append(out, ind+"break")
		case *luaast.DoBlockStmt:
			out = append(out, ind+"do {")
			out = append(out, convertLuaStmts(s.Stmts, indent+1)...)
			out = append(out, ind+"}")
		case *luaast.WhileStmt:
			cond := luaExprString(s.Condition)
			out = append(out, ind+"while "+cond+" {")
			out = append(out, convertLuaStmts(s.Stmts, indent+1)...)
			out = append(out, ind+"}")
		case *luaast.RepeatStmt:
			out = append(out, ind+"do {")
			out = append(out, convertLuaStmts(s.Stmts, indent+1)...)
			cond := luaExprString(s.Condition)
			out = append(out, ind+"} while !("+cond+")")
		case *luaast.IfStmt:
			cond := luaExprString(s.Condition)
			out = append(out, ind+"if "+cond+" {")
			out = append(out, convertLuaStmts(s.Then, indent+1)...)
			if len(s.Else) > 0 {
				out = append(out, ind+"} else {")
				out = append(out, convertLuaStmts(s.Else, indent+1)...)
			}
			out = append(out, ind+"}")
		case *luaast.NumberForStmt:
			step := "1"
			if s.Step != nil {
				step = luaExprString(s.Step)
			}
			init := luaExprString(s.Init)
			limit := luaExprString(s.Limit)
			out = append(out, ind+fmt.Sprintf("for %s = %s; %s <= %s; %s += %s {", s.Name, init, s.Name, limit, s.Name, step))
			out = append(out, convertLuaStmts(s.Stmts, indent+1)...)
			out = append(out, ind+"}")
		case *luaast.GenericForStmt:
			iter := ""
			if len(s.Exprs) > 0 {
				iter = luaExprString(s.Exprs[0])
			}
			out = append(out, ind+"for "+strings.Join(s.Names, ", ")+" in "+iter+" {")
			out = append(out, convertLuaStmts(s.Stmts, indent+1)...)
			out = append(out, ind+"}")
		}
	}
	return out
}

func luaExprString(e luaast.Expr) string {
	switch v := e.(type) {
	case *luaast.NumberExpr:
		return v.Value
	case *luaast.StringExpr:
		return strconv.Quote(v.Value)
	case *luaast.TrueExpr:
		return "true"
	case *luaast.FalseExpr:
		return "false"
	case *luaast.NilExpr:
		return "null"
	case *luaast.IdentExpr:
		return v.Value
	case *luaast.ArithmeticOpExpr:
		return luaExprString(v.Lhs) + " " + v.Operator + " " + luaExprString(v.Rhs)
	case *luaast.StringConcatOpExpr:
		return luaExprString(v.Lhs) + " + " + luaExprString(v.Rhs)
	case *luaast.LogicalOpExpr:
		op := v.Operator
		if op == "and" {
			op = "&&"
		} else if op == "or" {
			op = "||"
		}
		return luaExprString(v.Lhs) + " " + op + " " + luaExprString(v.Rhs)
	case *luaast.UnaryMinusOpExpr:
		return "-" + luaExprString(v.Expr)
	case *luaast.UnaryNotOpExpr:
		return "!" + luaExprString(v.Expr)
	case *luaast.FuncCallExpr:
		var args []string
		for _, a := range v.Args {
			args = append(args, luaExprString(a))
		}
		callee := luaExprString(v.Func)
		if v.Method != "" {
			callee = luaExprString(v.Receiver) + "." + v.Method
		}
		return callee + "(" + strings.Join(args, ", ") + ")"
	case *luaast.AttrGetExpr:
		if k, ok := v.Key.(*luaast.StringExpr); ok {
			return luaExprString(v.Object) + "[" + strconv.Quote(k.Value) + "]"
		}
		if _, ok := v.Key.(*luaast.IdentExpr); ok {
			return luaExprString(v.Object) + "." + luaExprString(v.Key)
		}
		return luaExprString(v.Object) + "[" + luaExprString(v.Key) + "]"
	case *luaast.TableExpr:
		isMap := false
		var items []string
		for _, f := range v.Fields {
			if f.Key != nil {
				isMap = true
				items = append(items, luaExprString(f.Key)+": "+luaExprString(f.Value))
			} else {
				items = append(items, luaExprString(f.Value))
			}
		}
		if isMap {
			return "{ " + strings.Join(items, ", ") + " }"
		}
		return "[" + strings.Join(items, ", ") + "]"
	}
	return ""
}

func luaFuncSignature(fn *luaast.FunctionExpr) string {
	var params []string
	if fn.ParList != nil {
		for _, n := range fn.ParList.Names {
			params = append(params, n)
		}
	}
	return "(" + strings.Join(params, ", ") + ")"
}

// ConvertLuaFile reads the lua file and converts it to Mochi.
func ConvertLuaFile(path string) ([]byte, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return ConvertLua(string(data))
}
