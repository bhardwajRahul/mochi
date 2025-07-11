# Generated by Mochi Python compiler
from __future__ import annotations

import dataclasses
import typing

def nthHighestSalary(employees: list[Employee], n: int) -> int:
	uniqList = []
	for e in employees:
		seen = False
		for s in uniqList:
			if (s == e.salary):
				seen = True
				break
		if (not seen):
			uniqList = (uniqList + [e.salary])
	_sorted = [ v for v in sorted([ v for v in uniqList ], key=lambda v: (-v)) ]
	if (n <= len(_sorted)):
		return _sorted[(n - 1)]
	return 0

@dataclasses.dataclass
class Employee:
	id: int
	salary: int

employees = [Employee(id=1, salary=100), Employee(id=2, salary=200), Employee(id=3, salary=300), Employee(id=4, salary=300)]

def first_highest():
	assert (nthHighestSalary(employees, 1) == 300)

def second_highest():
	assert (nthHighestSalary(employees, 2) == 200)

def too_high():
	assert (nthHighestSalary(employees, 5) == 0)

def main():
	employees = [Employee(id=1, salary=100), Employee(id=2, salary=200), Employee(id=3, salary=300), Employee(id=4, salary=300)]
	first_highest()
	second_highest()
	too_high()

if __name__ == "__main__":
	main()
