# Generated by Mochi Python compiler
from __future__ import annotations

import typing

def canFinish(numCourses: int, prerequisites: list[list[int]]) -> bool:
	graph = []
	indegree = []
	for _ in range(0, numCourses):
		graph = (graph + [[]])
		indegree = (indegree + [0])
	for pair in prerequisites:
		a = pair[0]
		b = pair[1]
		graph[b] = (graph[b] + [a])
		indegree[a] = (indegree[a] + 1)
	queue = []
	for i in range(0, numCourses):
		if (indegree[i] == 0):
			queue = (queue + [i])
	visited = 0
	idx = 0
	while (idx < len(queue)):
		course = queue[idx]
		idx = (idx + 1)
		visited = (visited + 1)
		for _next in graph[course]:
			indegree[_next] = (indegree[_next] - 1)
			if (indegree[_next] == 0):
				queue = (queue + [_next])
	return (visited == numCourses)

def simple_acyclic():
	assert (canFinish(2, [[1, 0]]) == True)

def simple_cycle():
	assert (canFinish(2, [[1, 0], [0, 1]]) == False)

def long_chain():
	assert (canFinish(4, [[1, 0], [2, 1], [3, 2]]) == True)

def cycle_with_more_courses():
	assert (canFinish(3, [[0, 1], [1, 2], [2, 0]]) == False)

def main():
	simple_acyclic()
	simple_cycle()
	long_chain()
	cycle_with_more_courses()

if __name__ == "__main__":
	main()
