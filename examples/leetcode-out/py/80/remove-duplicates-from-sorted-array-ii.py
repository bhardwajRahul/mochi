# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def removeDuplicates(nums: list[int]) -> int:
	n = len(nums)
	if (n <= 2):
		return n
	write = 2
	read = 2
	while (read < n):
		if (nums[read] != nums[(write - 2)]):
			nums[write] = nums[read]
			write = (write + 1)
		read = (read + 1)
	return write

def example_1():
	nums = [1, 1, 1, 2, 2, 3]
	k = removeDuplicates(nums)
	assert (k == 5)
	assert (nums[0:k] == [1, 1, 2, 2, 3])

def example_2():
	nums = [0, 0, 1, 1, 1, 1, 2, 3, 3]
	k = removeDuplicates(nums)
	assert (k == 7)
	assert (nums[0:k] == [0, 0, 1, 1, 2, 3, 3])

def main():
	example_1()
	example_2()

if __name__ == "__main__":
	main()
