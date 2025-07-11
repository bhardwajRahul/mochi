# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def findDuplicateEmails(emails: list[str]) -> list[str]:
	counts = {}
	for e in emails:
		c = 0
		if (e in counts):
			c = counts[e]
		counts[e] = (c + 1)
	result = []
	for e in emails:
		if (counts[e] > 1):
			exists = False
			for r in result:
				if (r == e):
					exists = True
					break
			if (not exists):
				result = (result + [e])
	return result

def example_duplicates():
	emails = ["a@x.com", "b@y.com", "a@x.com"]
	assert (findDuplicateEmails(emails) == ["a@x.com"])

def multiple_duplicates():
	emails = ["a@x.com", "b@y.com", "a@x.com", "b@y.com", "c@z.com", "a@x.com"]
	assert (findDuplicateEmails(emails) == ["a@x.com", "b@y.com"])

def no_duplicates():
	assert (findDuplicateEmails(["a@x.com", "b@y.com"]) == [])

def empty_list():
	assert (findDuplicateEmails([]) == [])

def main():
	example_duplicates()
	multiple_duplicates()
	no_duplicates()
	empty_list()

if __name__ == "__main__":
	main()
