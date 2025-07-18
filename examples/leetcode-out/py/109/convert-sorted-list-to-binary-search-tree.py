# Generated by Mochi Python compiler
from __future__ import annotations

import dataclasses
import typing

def sortedListToBST(nums: list[int]) -> Tree:
	def build(lo: int, hi: int) -> Tree:
		if (lo >= hi):
			return Leaf()
		mid = (((lo + hi)) // 2)
		return Node(left=build(lo, mid), value=nums[mid], right=build((mid + 1), hi))
	return build(0, len(nums))

def inorder(t: Tree) -> list[int]:
	return (lambda _t0=t: [] if isinstance(_t0, Leaf) else (lambda l, v, r: ((inorder(l) + [v]) + inorder(r)))(_t0.left, _t0.value, _t0.right) if isinstance(_t0, Node) else None)()

class Tree:
	pass
@dataclasses.dataclass
class Leaf(Tree):
	pass
@dataclasses.dataclass
class Node(Tree):
	left: Tree
	value: int
	right: Tree

def example():
	nums = [(-10), (-3), 0, 5, 9]
	tree = sortedListToBST(nums)
	assert (inorder(tree) == nums)

def empty():
	assert (inorder(sortedListToBST([])) == [])

def single():
	assert (inorder(sortedListToBST([1])) == [1])

def main():
	example()
	empty()
	single()

if __name__ == "__main__":
	main()
