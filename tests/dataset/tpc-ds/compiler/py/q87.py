# Generated by Mochi compiler v0.10.27 on 2025-07-17T17:51:10Z
from __future__ import annotations
import dataclasses
import json


@dataclasses.dataclass
class CatalogSale:
    cust: str

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


@dataclasses.dataclass
class StoreSale:
    cust: str
    price: float

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


def test_TPCDS_Q87_sample():
    assert result == 87.0


store_sales = [
    StoreSale(cust="A", price=5.0),
    StoreSale(cust="B", price=30.0),
    StoreSale(cust="C", price=57.0),
]
catalog_sales = [CatalogSale(cust="A")]
web_sales = []
store_customers = [s.cust for s in store_sales]
catalog_customers = [s.cust for s in catalog_sales]
web_customers = [
    s.get("cust") if isinstance(s, dict) else getattr(s, "cust") for s in web_sales
]
store_only = [
    c
    for c in store_customers
    if len([x for x in catalog_customers if x == c]) == 0
    and len([x for x in web_customers if x == c]) == 0
]
result = sum(
    [s.price for s in store_sales if len([x for x in store_only if x == s.cust]) > 0]
)
print(json.dumps(result, separators=(",", ":"), default=lambda o: vars(o)))
test_TPCDS_Q87_sample()
