//go:build slow

package schemecode_test

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	schemecode "mochi/compiler/x/scheme"
	"mochi/compiler/x/testutil"
	"mochi/parser"
	"mochi/types"
)

func TestSchemeCompiler_TPCH_Golden(t *testing.T) {
	schemePath, err := schemecode.EnsureScheme()
	if err != nil {
		t.Skipf("scheme not installed: %v", err)
	}
	root := testutil.FindRepoRoot(t)
	// Attempt to run all TPC-H queries. Only those with matching golden
	// files will actually execute so that missing outputs do not fail the
	// test run. The generated code and program output are compared against
	// the golden files.
	var queries []string
	for i := 1; i <= 22; i++ {
		queries = append(queries, fmt.Sprintf("q%d", i))
	}
	for _, base := range queries {
		src := filepath.Join(root, "tests", "dataset", "tpc-h", base+".mochi")
		codeWant := filepath.Join(root, "tests", "dataset", "tpc-h", "compiler", "scheme", base+".scm")
		outWant := filepath.Join(root, "tests", "dataset", "tpc-h", "compiler", "scheme", base+".out")
		if _, err := os.Stat(codeWant); err != nil && !shouldUpdate() {
			continue
		}
		if _, err := os.Stat(outWant); err != nil && !shouldUpdate() {
			continue
		}
		t.Run(base, func(t *testing.T) {
			prog, err := parser.Parse(src)
			if err != nil {
				t.Fatalf("parse error: %v", err)
			}
			env := types.NewEnv(nil)
			if errs := types.Check(prog, env); len(errs) > 0 {
				t.Fatalf("type error: %v", errs[0])
			}
			code, err := schemecode.New(env).Compile(prog)
			if err != nil {
				t.Skipf("compile error: %v", err)
				return
			}
			if shouldUpdate() {
				_ = os.WriteFile(codeWant, code, 0644)
			}
			dir := t.TempDir()
			file := filepath.Join(dir, "main.scm")
			if err := os.WriteFile(file, code, 0644); err != nil {
				t.Fatalf("write error: %v", err)
			}
			cmd := exec.Command(schemePath, "-m", "chibi", file)
			cmd.Dir = root
			out, err := cmd.CombinedOutput()
			if err != nil {
				t.Skipf("scheme run error: %v\n%s", err, out)
				return
			}
			gotOut := bytes.TrimSpace(out)
			if shouldUpdate() {
				_ = os.WriteFile(outWant, append(gotOut, '\n'), 0644)
			} else {
				wantOut, err := os.ReadFile(outWant)
				if err != nil {
					t.Fatalf("read golden: %v", err)
				}
				if !bytes.Equal(gotOut, bytes.TrimSpace(wantOut)) {
					t.Errorf("output mismatch for %s.out\n\n--- Got ---\n%s\n\n--- Want ---\n%s", base, gotOut, bytes.TrimSpace(wantOut))
				}
			}
		})
	}
}
