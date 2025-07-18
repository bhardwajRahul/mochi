# Generated by Mochi compiler v0.10.28 on 2025-07-18T04:03:57Z
from __future__ import annotations
import dataclasses


@dataclasses.dataclass
class Auto1:
    tag: object
    total: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Data:
    tag: str
    val: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


from typing import Any, TypeVar, Generic, Callable

T = TypeVar("T")
K = TypeVar("K")
UNDEFINED = object()


class _Group(Generic[K, T]):

    def __init__(self, key: K):
        self.key = key
        self.Items: list[T] = []
        self.items = self.Items

    def __iter__(self):
        return iter(self.Items)

    def __len__(self):
        return len(self.Items)


def _sort_key(k):
    if hasattr(k, "__dataclass_fields__"):
        return str(k)
    if isinstance(k, list):
        return tuple((_sort_key(x) for x in k))
    if isinstance(k, tuple):
        return tuple((_sort_key(x) for x in k))
    if isinstance(k, dict):
        return str(k)
    return k


data = [Data(tag="a", val=1), Data(tag="a", val=2), Data(tag="b", val=3)]


def _q0():
    _groups = {}
    _order = []
    for d in data:
        _k = d.tag
        _ks = str(_k)
        g = _groups.get(_ks)
        if not g:
            g = _Group(_k)
            _groups[_ks] = g
            _order.append(_ks)
        g.Items.append(d)
    _items1 = [_groups[k] for k in _order]
    return [g for g in _items1]


groups = _q0()
tmp = []
for g in groups:
    total = 0
    for x in g.Items:
        total = total + x["val"]
    tmp = tmp + [Auto1(tag=g.key, total=total)]
result = [
    r
    for r in sorted(
        [r for r in tmp],
        key=lambda r: _sort_key(
            r.get("tag") if isinstance(r, dict) else getattr(r, "tag")
        ),
    )
]
print(result)
