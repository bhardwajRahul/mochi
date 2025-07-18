//go:build slow

package kotlin_test

import (
	"bytes"
	"os"
	"path/filepath"
)

func stripHeader(b []byte) []byte {
	if i := bytes.IndexByte(b, '\n'); i != -1 && bytes.HasPrefix(b, []byte("// Generated by Mochi")) {
		return b[i+1:]
	}
	return b
}

// repoRoot walks up from the current directory to locate go.mod.
func repoRoot() string {
	dir, _ := os.Getwd()
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
	return dir
}
