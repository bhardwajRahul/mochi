# Generated by Mochi compiler v0.10.28 on 2025-07-18T04:05:19Z
from __future__ import annotations
import dataclasses


@dataclasses.dataclass
class Person:
    name: str
    age: int
    status: str

    def __contains__(self, key):
        return hasattr(self, key)


def test_update_adult_status():
    assert people == [
        Person(name="Alice", age=17, status="minor"),
        Person(name="Bob", age=26, status="adult"),
        Person(name="Charlie", age=19, status="adult"),
        Person(name="Diana", age=16, status="minor"),
    ]


people: list[Person] = [
    Person(name="Alice", age=17, status="minor"),
    Person(name="Bob", age=25, status="unknown"),
    Person(name="Charlie", age=18, status="unknown"),
    Person(name="Diana", age=16, status="minor"),
]
for _i0, _it1 in enumerate(people):
    name = _it1.name
    age = _it1.age
    status = _it1.status
    if age >= 18:
        setattr(_it1, "status", "adult")
        setattr(_it1, "age", age + 1)
    people[_i0] = _it1
print("ok")
test_update_adult_status()
