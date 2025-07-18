//go:build ignore

// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z

package main

import (
	"fmt"
	"strings"
)

type v map[string]any

func main() {
	partList := []string{
		"A",
		"B",
		"C",
		"D",
	}
	nAssemblies := 3
	for cycle := 1; cycle < (nAssemblies + 1); cycle++ {
		fmt.Println(strings.TrimSuffix(fmt.Sprintln(any("begin assembly cycle "+fmt.Sprint(any(cycle)))), "\n"))
		for _, p := range partList {
			fmt.Println(strings.TrimSuffix(fmt.Sprintln(any(p+" worker begins part")), "\n"))
		}
		for _, p := range partList {
			fmt.Println(strings.TrimSuffix(fmt.Sprintln(any(p+" worker completes part")), "\n"))
		}
		fmt.Println(strings.TrimSuffix(fmt.Sprintln(any("assemble.  cycle "+fmt.Sprint(any(cycle))+" complete")), "\n"))
	}
}
