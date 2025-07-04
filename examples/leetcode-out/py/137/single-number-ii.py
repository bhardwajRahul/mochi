# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def singleNumber(nums: list[int]) -> int:
	counts = {}
	for n in nums:
		if (n in counts):
			counts[n] = (counts[n] + 1)
		else:
			counts[n] = 1
	for n in nums:
		if (counts[n] == 1):
			return n
	return 0

def example_1():
	assert (singleNumber([2, 2, 3, 2]) == 3)

def example_2():
	assert (singleNumber([0, 1, 0, 1, 0, 1, 99]) == 99)

def negative_numbers():
	assert (singleNumber([(-2), (-2), 1, (-2)]) == 1)

def main():
	example_1()
	example_2()
	negative_numbers()

if __name__ == "__main__":
	main()
