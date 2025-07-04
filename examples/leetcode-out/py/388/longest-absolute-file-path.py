# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def splitLines(s: str) -> list[str]:
	lines = []
	current = ""
	i = 0
	while (i < len(s)):
		c = s[i]
		if (c == "\n"):
			lines = (lines + [current])
			current = ""
		else:
			current = (current + c)
		i = (i + 1)
	lines = (lines + [current])
	return lines

def lengthLongestPath(input: str) -> int:
	if (input == ""):
		return 0
	lines = splitLines(input)
	maxLen = 0
	levels = {}
	i = 0
	while (i < len(lines)):
		line = lines[i]
		depth = 0
		while ((depth < len(line)) and (line[depth] == "\t")):
			depth = (depth + 1)
		name = line[depth:len(line)]
		curr = len(name)
		if (depth > 0):
			curr = ((levels[(depth - 1)] + 1) + len(name))
		levels[depth] = curr
		if ("." in name):
			if (curr > maxLen):
				maxLen = curr
		i = (i + 1)
	return maxLen

def example_1():
	input = "dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext"
	assert (lengthLongestPath(input) == 20)

def example_2():
	input = "dir\n\tsubdir1\n\t\tfile1.ext\n\t\tsubsubdir1\n\tsubdir2\n\t\tsubsubdir2\n\t\t\tfile2.ext"
	assert (lengthLongestPath(input) == 32)

def no_files():
	assert (lengthLongestPath("dir\n\tsubdir") == 0)

def main():
	example_1()
	example_2()
	no_files()

if __name__ == "__main__":
	main()
