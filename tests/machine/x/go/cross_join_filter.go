//go:build ignore

// Generated by Mochi compiler v0.10.28 on 1970-01-01T00:00:00Z

package main

import (
	"fmt"
	"strings"
)

type v = Pair

type Pair struct {
	N int    `json:"n"`
	L string `json:"l"`
}

func main() {
	nums := []int{1, 2, 3}
	letters := []string{"A", "B"}
	pairs := func() []Pair {
		results := []Pair{}
		for _, n := range nums {
			if (n % 2) == 0 {
				for _, l := range letters {
					results = append(results, Pair{
						N: n,
						L: l,
					})
				}
			}
		}
		return results
	}()
	fmt.Println(strings.TrimSpace(fmt.Sprintln(any("--- Even pairs ---"))))
	for _, p := range pairs {
		fmt.Println(strings.TrimSpace(fmt.Sprintln(any(p.N), p.L)))
	}
}
