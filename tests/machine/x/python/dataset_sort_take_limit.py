# Generated by Mochi compiler v0.10.28 on 2025-07-18T04:03:33Z
from __future__ import annotations
import dataclasses


@dataclasses.dataclass
class Product:
    name: str
    price: int

    def __getitem__(self, key):
        return getattr(self, key)

    def __contains__(self, key):
        return hasattr(self, key)


products = [
    Product(name="Laptop", price=1500),
    Product(name="Smartphone", price=900),
    Product(name="Tablet", price=600),
    Product(name="Monitor", price=300),
    Product(name="Keyboard", price=100),
    Product(name="Mouse", price=50),
    Product(name="Headphones", price=200),
]
expensive = [
    p
    for p in sorted([p for p in products], key=lambda p: -p.price)[max(1, 0) :][
        : max(3, 0)
    ]
]
print("--- Top products (excluding most expensive) ---")
for item in expensive:
    print(item["name"], "costs $", item["price"])
