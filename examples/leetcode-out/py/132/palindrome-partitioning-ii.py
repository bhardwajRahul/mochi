# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def minCut(s: str) -> int:
	n = len(s)
	if (n <= 1):
		return 0
	dp = []
	i = 0
	while (i < n):
		dp = (dp + [i])
		i = (i + 1)
	isPal = []
	i = 0
	while (i < n):
		row = []
		j = 0
		while (j < n):
			row = (row + [False])
			j = (j + 1)
		isPal = (isPal + [row])
		i = (i + 1)
	i = 0
	while (i < n):
		j = 0
		while (j <= i):
			if (s[j] == s[i]):
				if ((i - j) <= 1):
					isPal[j][i] = True
				elif isPal[(j + 1)][(i - 1)]:
					isPal[j][i] = True
				if isPal[j][i]:
					if (j == 0):
						dp[i] = 0
					else:
						candidate = (dp[(j - 1)] + 1)
						if (candidate < dp[i]):
							dp[i] = candidate
			j = (j + 1)
		i = (i + 1)
	return dp[(n - 1)]

def example_1():
	assert (minCut("aab") == 1)

def example_2():
	assert (minCut("a") == 0)

def already_palindrome():
	assert (minCut("aba") == 0)

def all_same():
	assert (minCut("aaaa") == 0)

def main():
	example_1()
	example_2()
	already_palindrome()
	all_same()

if __name__ == "__main__":
	main()
