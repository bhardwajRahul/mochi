# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def insertionSortList(nums: list[int]) -> list[int]:
	arr = nums
	i = 1
	while (i < len(arr)):
		key = arr[i]
		j = (i - 1)
		while ((j >= 0) and (arr[j] > key)):
			arr[(j + 1)] = arr[j]
			j = (j - 1)
		arr[(j + 1)] = key
		i = (i + 1)
	return arr

def example_1():
	assert (insertionSortList([4, 2, 1, 3]) == [1, 2, 3, 4])

def example_2():
	assert (insertionSortList([(-1), 5, 3, 4, 0]) == [(-1), 0, 3, 4, 5])

def already_sorted():
	assert (insertionSortList([1, 2, 3, 4]) == [1, 2, 3, 4])

def single_element():
	assert (insertionSortList([1]) == [1])

def empty():
	assert (insertionSortList([]) == [])

def main():
	example_1()
	example_2()
	already_sorted()
	single_element()
	empty()

if __name__ == "__main__":
	main()
