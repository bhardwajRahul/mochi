//go:build slow

package rustcode_test

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	rustcode "mochi/compiler/x/rust"
	"mochi/parser"
	"mochi/types"
)

func TestRustCompiler_TPCDSQueries(t *testing.T) {
	if _, err := exec.LookPath("rustc"); err != nil {
		t.Skip("rustc not installed")
	}
	root := findRepoRoot(t)
	for i := 1; i <= 99; i++ {
		base := fmt.Sprintf("q%d", i)
		src := filepath.Join(root, "tests", "dataset", "tpc-ds", base+".mochi")
		codeWant := filepath.Join(root, "tests", "dataset", "tpc-ds", "compiler", "rust", base+".rs")
		outWant := filepath.Join(root, "tests", "dataset", "tpc-ds", "compiler", "rust", base+".out")
		errFile := filepath.Join(root, "tests", "dataset", "tpc-ds", "compiler", "rust", base+".error")
		if _, err := os.Stat(codeWant); err != nil {
			continue
		}
		if _, err := os.Stat(outWant); err != nil {
			continue
		}
		t.Run(base, func(t *testing.T) {
			scriptCmd := exec.Command("go", "run", "-tags=slow,archive", "./scripts/compile_tpcds_rust.go")
			scriptCmd.Env = append(os.Environ(), "QUERIES="+fmt.Sprint(i))
			scriptCmd.Dir = root
			if out, err := scriptCmd.CombinedOutput(); err != nil {
				t.Fatalf("compile script error: %v\n%s", err, out)
			}
			if b, err := os.ReadFile(errFile); err == nil {
				t.Skipf("rust run failed:\n%s", b)
			}

			prog, err := parser.Parse(src)
			if err != nil {
				t.Fatalf("parse error: %v", err)
			}
			env := types.NewEnv(nil)
			if errs := types.Check(prog, env); len(errs) > 0 {
				t.Fatalf("type error: %v", errs[0])
			}
			code, err := rustcode.New(env).Compile(prog)
			if err != nil {
				t.Fatalf("compile error: %v", err)
			}
			_ = os.WriteFile(codeWant, code, 0644)
			dir := t.TempDir()
			file := filepath.Join(dir, "main.rs")
			if err := os.WriteFile(file, code, 0644); err != nil {
				t.Fatalf("write error: %v", err)
			}
			bin := filepath.Join(dir, "prog")
			if out, err := exec.Command("rustc", file, "-O", "-o", bin).CombinedOutput(); err != nil {
				t.Fatalf("rustc error: %v\n%s", err, out)
			}
			outBytes, err := exec.Command(bin).CombinedOutput()
			if err != nil {
				t.Fatalf("run error: %v\n%s", err, outBytes)
			}
			gotOut := bytes.TrimSpace(outBytes)
			wantOut, err := os.ReadFile(outWant)
			if err != nil {
				t.Fatalf("read golden: %v", err)
			}
			if !bytes.Equal(gotOut, bytes.TrimSpace(wantOut)) {
				t.Errorf("output mismatch for %s.out\n\n--- Got ---\n%s\n\n--- Want ---\n%s", base, gotOut, bytes.TrimSpace(wantOut))
			}
		})
	}
}
