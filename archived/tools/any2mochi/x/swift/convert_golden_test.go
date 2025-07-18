//go:build archive && slow

package swift

import (
	"path/filepath"
	"testing"

	gocode "mochi/archived/go"
	any2mochi "mochi/archived/tools/any2mochi"
	swiftcode "mochi/archived/x/swift"
)

func TestConvertSwift_Golden(t *testing.T) {
	root := any2mochi.FindRepoRoot(t)
	_ = swiftcode.EnsureSwift()
	errs := any2mochi.RunConvertRunGolden(t, filepath.Join(root, "tests/compiler/swift"), "*.swift.out", ConvertFile, "swift", ".mochi", ".error")
	any2mochi.WriteErrorsMarkdown(filepath.Join(root, "tests/any2mochi/swift"), errs)
}

func TestConvertSwiftCompile_Golden(t *testing.T) {
	root := any2mochi.FindRepoRoot(t)
	_ = gocode.EnsureGopls()
	_ = swiftcode.EnsureSwift()
	any2mochi.RunConvertCompileGolden(t, filepath.Join(root, "tests/compiler/swift"), "*.swift.out", ConvertFile, "swift", ".mochi", ".error")
}
