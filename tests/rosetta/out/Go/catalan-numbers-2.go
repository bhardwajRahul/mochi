//go:build ignore

// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z

package main

import (
	"fmt"
	"strings"
)

type v map[string]any

// line 3
func catalanRec(n int) int {
	if n == 0 {
		return 1
	}
	t1 := (2 * n)
	t2 := (t1 - 1)
	t3 := (2 * t2)
	t5 := (t3 * catalanRec((n - 1)))
	return int((float64(t5) / float64((n + 1))))
}

// line 12
func main() {
	for i := 1; i < 16; i++ {
		fmt.Println(strings.TrimSuffix(fmt.Sprintln(any(fmt.Sprint(any(catalanRec(i))))), "\n"))
	}
}

func main() {
	main()
}
