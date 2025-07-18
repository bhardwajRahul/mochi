//go:build slow

package rb_test

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"mochi/parser"
	rb "mochi/transpiler/x/rb"
	"mochi/types"
)

func repoRoot(t *testing.T) string {
	dir, err := os.Getwd()
	if err != nil {
		t.Fatal("cannot determine working directory")
	}
	for i := 0; i < 10; i++ {
		if _, err := os.Stat(filepath.Join(dir, "go.mod")); err == nil {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}
	t.Fatal("go.mod not found")
	return ""
}

func TestTranspilePrograms(t *testing.T) {
	if _, err := exec.LookPath("ruby"); err != nil {
		t.Skip("ruby not installed")
	}
	tests := []string{
		"print_hello",
		"append_builtin",
		"avg_builtin",
		"count_builtin",
		"len_builtin",
		"len_string",
		"sum_builtin",
		"let_and_print",
		"if_else",
		"basic_compare",
		"binary_precedence",
		"math_ops",
		"unary_neg",
		"string_compare",
		"string_concat",
		"if_then_else",
		"if_then_else_nested",
		"for_loop",
		"for_list_collection",
		"while_loop",
		"var_assignment",
		"break_continue",
		"list_assign",
		"len_map",
		"map_literal_dynamic",
		"fun_call",
		"fun_three_args",
		"cast_string_to_int",
		"cast_struct",
		"list_index",
		"map_index",
		"map_assign",
	}
	root := repoRoot(t)
	outDir := filepath.Join(root, "tests", "transpiler", "x", "rb")
	os.MkdirAll(outDir, 0o755)
	for _, name := range tests {
		t.Run(name, func(t *testing.T) {
			src := filepath.Join(root, "tests", "vm", "valid", name+".mochi")
			prog, err := parser.Parse(src)
			if err != nil {
				t.Fatalf("parse: %v", err)
			}
			env := types.NewEnv(nil)
			if errs := types.Check(prog, env); len(errs) > 0 {
				t.Fatalf("type: %v", errs[0])
			}
			ast, err := rb.Transpile(prog, env)
			if err != nil {
				t.Fatalf("transpile: %v", err)
			}
			var buf bytes.Buffer
			if err := rb.Emit(&buf, ast); err != nil {
				t.Fatalf("emit: %v", err)
			}
			code := buf.Bytes()
			rbFile := filepath.Join(outDir, name+".rb")
			if err := os.WriteFile(rbFile, code, 0o644); err != nil {
				t.Fatalf("write: %v", err)
			}
			cmd := exec.Command("ruby", rbFile)
			cmd.Env = append(os.Environ(), "MOCHI_ROOT="+root)
			out, err := cmd.CombinedOutput()
			got := bytes.TrimSpace(out)
			if err != nil {
				_ = os.WriteFile(filepath.Join(outDir, name+".error"), out, 0o644)
				t.Fatalf("run: %v", err)
			}
			_ = os.Remove(filepath.Join(outDir, name+".error"))
			wantPath := filepath.Join(root, "tests", "vm", "valid", name+".out")
			want, err := os.ReadFile(wantPath)
			if err != nil {
				t.Fatalf("read want: %v", err)
			}
			want = bytes.TrimSpace(want)
			if !bytes.Equal(got, want) {
				t.Errorf("output mismatch:\nGot: %s\nWant: %s", got, want)
			}
			if err := os.WriteFile(filepath.Join(outDir, name+".out"), got, 0o644); err != nil {
				t.Fatal(err)
			}
		})
	}
}

func TestMain(m *testing.M) {
	code := m.Run()
	updateReadme()
	updateTasks()
	os.Exit(code)
}

func updateReadme() {
	root := repoRoot(&testing.T{})
	srcDir := filepath.Join(root, "tests", "vm", "valid")
	outDir := filepath.Join(root, "tests", "transpiler", "x", "rb")
	readmePath := filepath.Join(root, "transpiler", "x", "rb", "README.md")
	files, _ := filepath.Glob(filepath.Join(srcDir, "*.mochi"))
	total := len(files)
	compiled := 0
	var lines []string
	for _, f := range files {
		name := strings.TrimSuffix(filepath.Base(f), ".mochi")
		mark := "[ ]"
		if _, err := os.Stat(filepath.Join(outDir, name+".out")); err == nil {
			compiled++
			mark = "[x]"
		}
		lines = append(lines, fmt.Sprintf("- %s %s", mark, name))
	}
	var buf bytes.Buffer
	buf.WriteString("# Mochi Ruby Transpiler\n\n")
	buf.WriteString("This directory contains Ruby code generated by the Mochi transpiler.\n\n")
	fmt.Fprintf(&buf, "## Golden Test Checklist (%d/%d)\n\n", compiled, total)
	buf.WriteString(strings.Join(lines, "\n"))
	buf.WriteString("\n")
	_ = os.WriteFile(readmePath, buf.Bytes(), 0o644)
}

func updateTasks() {
	root := repoRoot(&testing.T{})
	taskFile := filepath.Join(root, "transpiler", "x", "rb", "TASKS.md")
	out, err := exec.Command("git", "log", "-1", "--format=%cI").Output()
	ts := ""
	if err == nil {
		if t, perr := time.Parse(time.RFC3339, strings.TrimSpace(string(out))); perr == nil {
			ts = t.Format("2006-01-02 15:04 MST")
		}
	}
	var buf bytes.Buffer
	buf.WriteString(fmt.Sprintf("## Progress (%s)\n", ts))
	buf.WriteString("- VM valid golden test results updated\n\n")
	if data, err := os.ReadFile(taskFile); err == nil {
		buf.Write(data)
	}
	_ = os.WriteFile(taskFile, buf.Bytes(), 0o644)
}
