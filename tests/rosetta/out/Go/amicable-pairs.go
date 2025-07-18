//go:build ignore

// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z

package main

import (
	"fmt"
	"strings"
)

type v map[string]any

// line 1
func pfacSum(i int) int {
	sum := 0
	p := 1
	for float64(p) <= (float64(i) / float64(2)) {
		if (i % p) == 0 {
			sum = (sum + p)
		}
		p = (p + 1)
	}
	return sum
}

// line 13
func pad(n int, width int) string {
	s := fmt.Sprint(any(n))
	for len(any(s)) < width {
		s = " " + s
	}
	return s
}

// line 21
func main() {
	var sums []int = []int{}
	i := 0
	for i < 20000 {
		sums = append(_toAnySlice(sums), any(0))
		i = (i + 1)
	}
	i = 1
	for i < 20000 {
		sums[i] = pfacSum(i)
		i = (i + 1)
	}
	fmt.Println(strings.TrimSuffix(fmt.Sprintln(any("The amicable pairs below 20,000 are:")), "\n"))
	n := 2
	for n < 19999 {
		m := sums[n]
		if ((m > n) && (m < 20000)) && (n == sums[m]) {
			fmt.Println(strings.TrimSuffix(fmt.Sprintln(any("  "+pad(n, 5)+" and "+pad(m, 5))), "\n"))
		}
		n = (n + 1)
	}
}

func main() {
	main()
}

func _toAnySlice[T any](s []T) []any {
	out := make([]any, len(s))
	for i, v := range s {
		out[i] = v
	}
	return out
}
