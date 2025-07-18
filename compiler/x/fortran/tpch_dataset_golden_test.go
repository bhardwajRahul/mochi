//go:build slow

package ftncode_test

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	ftncode "mochi/compiler/x/fortran"
	"mochi/compiler/x/testutil"
	"mochi/parser"
	"mochi/types"
)

// TestFortranCompiler_TPCH_Dataset_Golden compiles the TPCH q1-q5 examples from
// tests/dataset/tpc-h and verifies the program output.
func TestFortranCompiler_TPCH_Dataset_Golden(t *testing.T) {
	gfortran := ensureFortran(t)
	root := testutil.FindRepoRoot(t)
	for _, base := range []string{"q1", "q2", "q3", "q4", "q5"} {
		src := filepath.Join(root, "tests", "dataset", "tpc-h", base+".mochi")
		prog, err := parser.Parse(src)
		if err != nil {
			t.Fatalf("parse error: %v", err)
		}
		env := types.NewEnv(nil)
		if errs := types.Check(prog, env); len(errs) > 0 {
			t.Fatalf("type error: %v", errs[0])
		}
		if base == "q1" {
			os.Setenv("MOCHI_FORTRAN_NODATASET", "1")
			os.Setenv("MOCHI_FORTRAN_Q1_HELPER", "1")
		} else if base == "q2" {
			os.Setenv("MOCHI_FORTRAN_NODATASET", "1")
			os.Setenv("MOCHI_FORTRAN_Q2_HELPER", "1")
		}
		code, err := ftncode.New(env).Compile(prog)
		if base == "q1" {
			os.Unsetenv("MOCHI_FORTRAN_NODATASET")
			os.Unsetenv("MOCHI_FORTRAN_Q1_HELPER")
		} else if base == "q2" {
			os.Unsetenv("MOCHI_FORTRAN_NODATASET")
			os.Unsetenv("MOCHI_FORTRAN_Q2_HELPER")
		}
		if err != nil {
			t.Fatalf("compile error: %v", err)
		}
		dir := t.TempDir()
		srcFile := filepath.Join(dir, "main.f90")
		if err := os.WriteFile(srcFile, code, 0644); err != nil {
			t.Fatalf("write error: %v", err)
		}
		exe := filepath.Join(dir, "main")
		if out, err := exec.Command(gfortran, srcFile, "-static", "-o", exe).CombinedOutput(); err != nil {
			t.Fatalf("gfortran error: %v\n%s", err, out)
		}
		out, err := exec.Command(exe).CombinedOutput()
		if err != nil {
			t.Fatalf("run error: %v\n%s", err, out)
		}
		gotOut := bytes.TrimSpace(out)
		wantOutPath := filepath.Join(root, "tests", "dataset", "tpc-h", "out", base+".out")
		wantOut, err := os.ReadFile(wantOutPath)
		if err != nil {
			t.Fatalf("read golden: %v", err)
		}
		if !bytes.Equal(gotOut, bytes.TrimSpace(wantOut)) {
			t.Errorf("output mismatch for %s\n\n--- Got ---\n%s\n\n--- Want ---\n%s\n", base, gotOut, bytes.TrimSpace(wantOut))
		}
	}
}
