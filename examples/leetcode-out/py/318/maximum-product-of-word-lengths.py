# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def buildSet(word: str) -> dict[str, bool]:
	m = {}
	for ch in word:
		m[ch] = True
	return m

def shareLetters(a: dict[str, bool], b: dict[str, bool]) -> bool:
	for ch in a:
		if (ch in b):
			return True
	return False

def maxProduct(words: list[str]) -> int:
	n = len(words)
	sets = []
	i = 0
	while (i < n):
		sets = (sets + [buildSet(words[i])])
		i = (i + 1)
	best = 0
	i = 0
	while (i < n):
		j = (i + 1)
		while (j < n):
			if (not shareLetters(sets[i], sets[j])):
				prod = (len(words[i]) * len(words[j]))
				if (prod > best):
					best = prod
			j = (j + 1)
		i = (i + 1)
	return best

def example_1():
	assert (maxProduct(["abcw", "baz", "foo", "bar", "xtfn", "abcdef"]) == 16)

def example_2():
	assert (maxProduct(["a", "ab", "abc", "d", "cd", "bcd", "abcd"]) == 4)

def example_3():
	assert (maxProduct(["a", "aa", "aaa", "aaaa"]) == 0)

def main():
	example_1()
	example_2()
	example_3()

if __name__ == "__main__":
	main()
