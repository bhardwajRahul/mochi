//go:build ignore

// Generated by Mochi v0.10.31 on 2025-07-20 01:34:50 GMT+7
package main

import (
	"fmt"
)

func main() {
	var nums []int = []int{3, 1, 4}
	fmt.Println(func(nums []int) int {
		if len(nums) == 0 {
			return 0
		}
		min := nums[0]
		for _, n := range nums[1:] {
			if n < min {
				min = n
			}
		}
		return min
	}(nums))
	fmt.Println(func(nums []int) int {
		if len(nums) == 0 {
			return 0
		}
		max := nums[0]
		for _, n := range nums[1:] {
			if n > max {
				max = n
			}
		}
		return max
	}(nums))
}
