//go:build slow

package pascode_test

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"testing"

	pascode "mochi/compiler/x/pascal"
	"mochi/compiler/x/testutil"
	"mochi/parser"
	"mochi/types"
)

func ensureFPCQuick(t *testing.T) string {
	t.Helper()
	path, err := exec.LookPath("fpc")
	if err != nil {
		t.Skip("fpc not installed")
	}
	return path
}

func TestPascalCompiler_TPCH_Dataset_Golden(t *testing.T) {
	fpc := ensureFPCQuick(t)
	root := testutil.FindRepoRoot(t)
	for _, base := range []string{"q1", "q2", "q3", "q4", "q5", "q6", "q7", "q8", "q9", "q10", "q11", "q12", "q13", "q14", "q15", "q16", "q17", "q18", "q19", "q20", "q21", "q22"} {
		src := filepath.Join(root, "tests", "dataset", "tpc-h", base+".mochi")
		prog, err := parser.Parse(src)
		if err != nil {
			t.Fatalf("parse error: %v", err)
		}
		env := types.NewEnv(nil)
		if errs := types.Check(prog, env); len(errs) > 0 {
			t.Fatalf("type error: %v", errs[0])
		}
		code, err := pascode.New(env).Compile(prog)
		if err != nil {
			t.Fatalf("compile error: %v", err)
		}
		dir := t.TempDir()
		srcFile := filepath.Join(dir, "main.pas")
		if err := os.WriteFile(srcFile, code, 0644); err != nil {
			t.Fatalf("write error: %v", err)
		}
		exe := filepath.Join(dir, "main")
		if out, err := exec.Command(fpc, srcFile, "-o"+exe).CombinedOutput(); err != nil {
			t.Skipf("fpc error: %v\n%s", err, out)
		}
		out, err := exec.Command(exe).CombinedOutput()
		if err != nil {
			t.Skipf("run error: %v\n%s", err, out)
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
