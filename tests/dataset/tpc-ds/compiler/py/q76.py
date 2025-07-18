# Generated by Mochi compiler v0.10.27 on 2025-07-17T17:50:57Z
from __future__ import annotations
import dataclasses
import json


@dataclasses.dataclass
class Auto1:
    channel: str
    col_name: object
    d_year: int
    d_qoy: int
    i_category: str
    sales_cnt: int
    sales_amt: float

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Auto2:
    channel: str
    col_name: object
    d_year: int
    d_qoy: int
    i_category: str
    ext_sales_price: float

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Auto3:
    channel: object
    col_name: object
    d_year: object
    d_qoy: object
    i_category: object

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class CatalogSale:
    cs_bill_customer_sk: object
    cs_item_sk: int
    cs_ext_sales_price: float
    cs_sold_date_sk: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class DateDim:
    d_date_sk: int
    d_year: int
    d_qoy: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class Item:
    i_item_sk: int
    i_category: str

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class StoreSale:
    ss_customer_sk: object
    ss_item_sk: int
    ss_ext_sales_price: float
    ss_sold_date_sk: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class WebSale:
    ws_bill_customer_sk: object
    ws_item_sk: int
    ws_ext_sales_price: float
    ws_sold_date_sk: int

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


def _sum(v):
    if hasattr(v, "Items"):
        v = v.Items
    if not isinstance(v, list):
        raise Exception("sum() expects list or group")
    s = 0.0
    for it in v:
        if it is None:
            continue
        if isinstance(it, (int, float)):
            s += float(it)
        else:
            raise Exception("sum() expects numbers")
    return s


def test_TPCDS_Q76_simplified():
    assert result == [
        Auto1(
            channel="store",
            col_name=None,
            d_year=1998,
            d_qoy=1,
            i_category="CatA",
            sales_cnt=1,
            sales_amt=10.0,
        ),
        Auto1(
            channel="web",
            col_name=None,
            d_year=1998,
            d_qoy=1,
            i_category="CatB",
            sales_cnt=1,
            sales_amt=15.0,
        ),
        Auto1(
            channel="catalog",
            col_name=None,
            d_year=1998,
            d_qoy=1,
            i_category="CatC",
            sales_cnt=1,
            sales_amt=20.0,
        ),
    ]


date_dim = [DateDim(d_date_sk=1, d_year=1998, d_qoy=1)]
item = [
    Item(i_item_sk=1, i_category="CatA"),
    Item(i_item_sk=2, i_category="CatB"),
    Item(i_item_sk=3, i_category="CatC"),
]
store_sales = [
    StoreSale(
        ss_customer_sk=None, ss_item_sk=1, ss_ext_sales_price=10.0, ss_sold_date_sk=1
    )
]
web_sales = [
    WebSale(
        ws_bill_customer_sk=None,
        ws_item_sk=2,
        ws_ext_sales_price=15.0,
        ws_sold_date_sk=1,
    )
]
catalog_sales = [
    CatalogSale(
        cs_bill_customer_sk=None,
        cs_item_sk=3,
        cs_ext_sales_price=20.0,
        cs_sold_date_sk=1,
    )
]
store_part = _query(
    store_sales,
    [
        {"items": item, "on": lambda ss, i: i.i_item_sk == ss.ss_item_sk},
        {"items": date_dim, "on": lambda ss, i, d: d.d_date_sk == ss.ss_sold_date_sk},
    ],
    {
        "select": lambda ss, i, d: Auto2(
            channel="store",
            col_name=ss.ss_customer_sk,
            d_year=d.d_year,
            d_qoy=d.d_qoy,
            i_category=i.i_category,
            ext_sales_price=ss.ss_ext_sales_price,
        ),
        "where": lambda ss, i, d: ss.ss_customer_sk == None,
    },
)
web_part = _query(
    web_sales,
    [
        {"items": item, "on": lambda ws, i: i.i_item_sk == ws.ws_item_sk},
        {"items": date_dim, "on": lambda ws, i, d: d.d_date_sk == ws.ws_sold_date_sk},
    ],
    {
        "select": lambda ws, i, d: Auto2(
            channel="web",
            col_name=ws.ws_bill_customer_sk,
            d_year=d.d_year,
            d_qoy=d.d_qoy,
            i_category=i.i_category,
            ext_sales_price=ws.ws_ext_sales_price,
        ),
        "where": lambda ws, i, d: ws.ws_bill_customer_sk == None,
    },
)
catalog_part = _query(
    catalog_sales,
    [
        {"items": item, "on": lambda cs, i: i.i_item_sk == cs.cs_item_sk},
        {"items": date_dim, "on": lambda cs, i, d: d.d_date_sk == cs.cs_sold_date_sk},
    ],
    {
        "select": lambda cs, i, d: Auto2(
            channel="catalog",
            col_name=cs.cs_bill_customer_sk,
            d_year=d.d_year,
            d_qoy=d.d_qoy,
            i_category=i.i_category,
            ext_sales_price=cs.cs_ext_sales_price,
        ),
        "where": lambda cs, i, d: cs.cs_bill_customer_sk == None,
    },
)
all_rows = store_part + web_part + catalog_part


def _q0():
    _src = all_rows
    _rows = _query(_src, [], {"select": lambda r: r})
    _groups = _group_by(
        _rows,
        lambda r: Auto3(
            channel=r.get("channel") if isinstance(r, dict) else getattr(r, "channel"),
            col_name=(
                r.get("col_name") if isinstance(r, dict) else getattr(r, "col_name")
            ),
            d_year=r.get("d_year") if isinstance(r, dict) else getattr(r, "d_year"),
            d_qoy=r.get("d_qoy") if isinstance(r, dict) else getattr(r, "d_qoy"),
            i_category=(
                r.get("i_category") if isinstance(r, dict) else getattr(r, "i_category")
            ),
        ),
    )
    _items1 = _groups
    _items1 = sorted(_items1, key=lambda g: _sort_key(g.key["channel"]))
    return [
        Auto1(
            channel=g.key["channel"],
            col_name=g.key["col_name"],
            d_year=g.key["d_year"],
            d_qoy=g.key["d_qoy"],
            i_category=g.key["i_category"],
            sales_cnt=len(g),
            sales_amt=_sum(
                [
                    (
                        (x.get("r") if isinstance(x, dict) else getattr(x, "r")).get(
                            "ext_sales_price"
                        )
                        if isinstance(
                            x.get("r") if isinstance(x, dict) else getattr(x, "r"), dict
                        )
                        else getattr(
                            x.get("r") if isinstance(x, dict) else getattr(x, "r"),
                            "ext_sales_price",
                        )
                    )
                    for x in g
                ]
            ),
        )
        for g in _items1
    ]


result = _q0()
print(json.dumps(result, separators=(",", ":"), default=lambda o: vars(o)))
test_TPCDS_Q76_simplified()
