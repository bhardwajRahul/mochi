//go:build archive && slow

package cpp

import (
	"fmt"
	"path/filepath"
	"testing"

	any2mochi "mochi/archived/tools/any2mochi"
	cppcode "mochi/archived/x/cpp"
	"mochi/parser"
	"mochi/types"
)

func compileMochiToCpp(path string) ([]byte, error) {
	prog, err := parser.Parse(path)
	if err != nil {
		return nil, fmt.Errorf("parse error: %w", err)
	}
	env := types.NewEnv(nil)
	if errs := types.Check(prog, env); len(errs) > 0 {
		return nil, fmt.Errorf("type error: %v", errs[0])
	}
	code, err := cppcode.New(env).Compile(prog)
	if err != nil {
		return nil, fmt.Errorf("compile error: %w", err)
	}
	return code, nil
}

func TestCpp_VM_RoundTrip(t *testing.T) {
	root := any2mochi.FindRepoRoot(t)
	status := any2mochi.RunCompileConvertRunStatus(
		t,
		filepath.Join(root, "tests/vm/valid"),
		"*.mochi",
		compileMochiToCpp,
		ConvertFile,
		"cpp",
	)
	any2mochi.WriteStatusMarkdown(filepath.Join(root, "tests/any2mochi/cpp_vm"), status)
}
