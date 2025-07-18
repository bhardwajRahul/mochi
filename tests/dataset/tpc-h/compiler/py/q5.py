# Generated by Mochi compiler v0.10.27 on 1970-01-01T00:00:00Z
from __future__ import annotations
import dataclasses
import json


@dataclasses.dataclass
class Auto1:
    n_name: str
    revenue: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Auto2:
    nation: object
    revenue: float

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Customer:
    c_custkey: int
    c_nationkey: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Lineitem:
    l_orderkey: int
    l_suppkey: int
    l_extendedprice: float
    l_discount: float

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Nation:
    n_nationkey: int
    n_regionkey: int
    n_name: str

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Order:
    o_orderkey: int
    o_custkey: int
    o_orderdate: str

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Region:
    r_regionkey: int
    r_name: str

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Supplier:
    s_suppkey: int
    s_nationkey: int

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


def _group_by(src: list[T], keyfn: Callable[[T], K]) -> list[_Group[K, T]]:
    groups: dict[str, _Group[K, T]] = {}
    order: list[str] = []
    for it in src:
        if isinstance(it, (list, tuple)):
            key = keyfn(*it)
        else:
            key = keyfn(it)
        if isinstance(key, dict):
            import types

            key = types.SimpleNamespace(**key)
        ks = str(key)
        g = groups.get(ks)
        if not g:
            g = _Group(key)
            groups[ks] = g
            order.append(ks)
        g.Items.append(it)
    return [groups[k] for k in order]


def _query(src, joins, opts):
    items = [[v] for v in src]
    for j in joins:
        joined = []
        if j.get("right") and j.get("left"):
            matched = [False] * len(j["items"])
            for left in items:
                m = False
                for ri, right in enumerate(j["items"]):
                    keep = True
                    if j.get("on"):
                        keep = j["on"](*left, right)
                    if not keep:
                        continue
                    m = True
                    matched[ri] = True
                    joined.append(left + [right])
                if not m:
                    joined.append(left + [None])
            for ri, right in enumerate(j["items"]):
                if not matched[ri]:
                    undef = [None] * (len(items[0]) if items else 0)
                    joined.append(undef + [right])
        elif j.get("right"):
            for right in j["items"]:
                m = False
                for left in items:
                    keep = True
                    if j.get("on"):
                        keep = j["on"](*left, right)
                    if not keep:
                        continue
                    m = True
                    joined.append(left + [right])
                if not m:
                    undef = [None] * (len(items[0]) if items else 0)
                    joined.append(undef + [right])
        else:
            for left in items:
                m = False
                for right in j["items"]:
                    keep = True
                    if j.get("on"):
                        keep = j["on"](*left, right)
                    if not keep:
                        continue
                    m = True
                    joined.append(left + [right])
                if j.get("left") and (not m):
                    joined.append(left + [None])
        items = joined
    if opts.get("where"):
        items = [r for r in items if opts["where"](*r)]
    if opts.get("sortKey"):

        def _key(it):
            k = opts["sortKey"](*it)
            if isinstance(k, (list, tuple, dict)):
                return str(k)
            return k

        items.sort(key=_key)
    if "skip" in opts:
        n = opts["skip"]
        if n < 0:
            n = 0
        items = items[n:] if n < len(items) else []
    if "take" in opts:
        n = opts["take"]
        if n < 0:
            n = 0
        items = items[:n] if n < len(items) else items
    res = []
    for r in items:
        res.append(opts["select"](*r))
    return res


def test_Q5_returns_revenue_per_nation_in_ASIA_with_local_suppliers():
    assert result == [
        Auto1(n_name="JAPAN", revenue=950),
        Auto1(n_name="INDIA", revenue=720),
    ]


region = [Region(r_regionkey=0, r_name="ASIA"), Region(r_regionkey=1, r_name="EUROPE")]
nation = [
    Nation(n_nationkey=10, n_regionkey=0, n_name="JAPAN"),
    Nation(n_nationkey=20, n_regionkey=0, n_name="INDIA"),
    Nation(n_nationkey=30, n_regionkey=1, n_name="FRANCE"),
]
customer = [
    Customer(c_custkey=1, c_nationkey=10),
    Customer(c_custkey=2, c_nationkey=20),
]
supplier = [
    Supplier(s_suppkey=100, s_nationkey=10),
    Supplier(s_suppkey=200, s_nationkey=20),
]
orders = [
    Order(o_orderkey=1000, o_custkey=1, o_orderdate="1994-03-15"),
    Order(o_orderkey=2000, o_custkey=2, o_orderdate="1994-06-10"),
    Order(o_orderkey=3000, o_custkey=2, o_orderdate="1995-01-01"),
]
lineitem = [
    Lineitem(l_orderkey=1000, l_suppkey=100, l_extendedprice=1000.0, l_discount=0.05),
    Lineitem(l_orderkey=2000, l_suppkey=200, l_extendedprice=800.0, l_discount=0.1),
    Lineitem(l_orderkey=3000, l_suppkey=200, l_extendedprice=900.0, l_discount=0.05),
]
asia_nations = _query(
    region,
    [{"items": nation, "on": lambda r, n: n.n_regionkey == r.r_regionkey}],
    {"select": lambda r, n: n, "where": lambda r, n: r.r_name == "ASIA"},
)
local_customer_supplier_orders = _query(
    customer,
    [
        {"items": asia_nations, "on": lambda c, n: c.c_nationkey == n["n_nationkey"]},
        {"items": orders, "on": lambda c, n, o: o.o_custkey == c.c_custkey},
        {"items": lineitem, "on": lambda c, n, o, l: l.l_orderkey == o.o_orderkey},
        {"items": supplier, "on": lambda c, n, o, l, s: s.s_suppkey == l.l_suppkey},
    ],
    {
        "select": lambda c, n, o, l, s: Auto2(
            nation=n["n_name"], revenue=l.l_extendedprice * (1 - l.l_discount)
        ),
        "where": lambda c, n, o, l, s: (
            o.o_orderdate >= "1994-01-01" and o.o_orderdate < "1995-01-01"
        )
        and s.s_nationkey == c.c_nationkey,
    },
)


def _q0():
    _src = local_customer_supplier_orders
    _rows = _query(_src, [], {"select": lambda r: r})
    _groups = _group_by(_rows, lambda r: r.nation)
    _items1 = _groups
    _items1 = sorted(_items1, key=lambda g: -sum([x.revenue for x in g]))
    return [Auto1(n_name=g.key, revenue=sum([x.revenue for x in g])) for g in _items1]


result = _q0()
print(json.dumps(result, separators=(",", ":"), default=lambda o: vars(o)))
test_Q5_returns_revenue_per_nation_in_ASIA_with_local_suppliers()
