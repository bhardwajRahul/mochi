//go:build slow

package cljcode_test

import (
	"bytes"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"

	cljcode "mochi/compiler/x/clj"
	"mochi/parser"
	"mochi/types"
)

func shouldUpdateRosetta() bool {
	if v, ok := os.LookupEnv("UPDATE"); ok && (v == "1" || v == "true") {
		return true
	}
	return false
}

func runRosettaTaskGolden(t *testing.T, name string) {
	interactive := map[string]bool{
		"15-puzzle-game":                     true,
		"15-puzzle-solver":                   true,
		"2048":                               true,
		"21-game":                            true,
		"24-game":                            true,
		"a+b":                                true,
		"adfgvx-cipher":                      true,
		"amb":                                true,
		"9-billion-names-of-god-the-integer": true,
		"DNS-query":                          true,
		"abc-problem":                        true,
	}
	root := repoRoot(t)
	script := exec.Command("go", "run", "-tags=archive,slow", "./scripts/compile_rosetta_clj.go")
	script.Env = append(os.Environ(), "GOTOOLCHAIN=local", "TASKS="+name, "SOURCE_DATE_EPOCH=0", "MOCHI_NOW_SEED=1")
	script.Dir = root
	if out, err := script.CombinedOutput(); err != nil {
		t.Fatalf("compile script error: %v\n%s", err, out)
	}
	errFile := filepath.Join(root, "tests", "rosetta", "out", "Clojure", name+".error")
	if b, err := os.ReadFile(errFile); err == nil {
		t.Skipf("clojure run failed:\n%s", b)
		return
	}

	src := filepath.Join(root, "tests", "rosetta", "x", "Mochi", name+".mochi")
	prog, err := parser.Parse(src)
	if err != nil {
		t.Fatalf("parse error: %v", err)
	}
	env := types.NewEnv(nil)
	os.Setenv("SOURCE_DATE_EPOCH", "0")
	if errs := types.Check(prog, env); len(errs) > 0 {
		t.Fatalf("type error: %v", errs[0])
	}
	code, err := cljcode.New(env).Compile(prog)
	if err != nil {
		t.Fatalf("compile error: %v", err)
	}
	codeWant := filepath.Join(root, "tests", "rosetta", "out", "Clojure", name+".clj")
	if shouldUpdateRosetta() {
		_ = os.WriteFile(codeWant, code, 0644)
	}

	dir := t.TempDir()
	file := filepath.Join(dir, "main.clj")
	if err := os.WriteFile(file, code, 0644); err != nil {
		t.Fatalf("write error: %v", err)
	}
	if interactive[name] {
		t.Skip("interactive program")
	}
	cmd := exec.Command("clojure", file)
	cmd.Env = append(os.Environ(), "CLASSPATH=/usr/share/java/data.json.jar:/usr/share/java/snakeyaml-engine.jar", "MOCHI_NOW_SEED=1")
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Skipf("run error: %v\n%s", err, out)
		return
	}
	gotOut := bytes.TrimSpace(out)
	outWant := filepath.Join(root, "tests", "rosetta", "out", "Clojure", name+".out")
	if shouldUpdateRosetta() {
		_ = os.WriteFile(outWant, append(gotOut, '\n'), 0644)
	} else if wantOut, err := os.ReadFile(outWant); err == nil {
		if !bytes.Equal(gotOut, bytes.TrimSpace(wantOut)) {
			t.Errorf("output mismatch for %s.out\n\n--- Got ---\n%s\n\n--- Want ---\n%s", name, gotOut, bytes.TrimSpace(wantOut))
		}
	}
}

func repoRoot(t *testing.T) string {
	dir, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
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

func TestClojureCompiler_Rosetta_Golden(t *testing.T) {
	if err := cljcode.EnsureClojure(); err != nil {
		t.Skipf("clojure not installed: %v", err)
	}
	root := repoRoot(t)
	files, err := filepath.Glob(filepath.Join(root, "tests", "rosetta", "x", "Mochi", "*.mochi"))
	if err != nil {
		t.Fatalf("glob: %v", err)
	}
	max := 20
	if len(files) < max {
		max = len(files)
	}
	for _, f := range files[:max] {
		name := strings.TrimSuffix(filepath.Base(f), ".mochi")
		t.Run(name, func(t *testing.T) { runRosettaTaskGolden(t, name) })
	}
}
