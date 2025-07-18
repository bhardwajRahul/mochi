# Generated by Mochi compiler v0.10.30 on 1970-01-01T00:00:00Z
from __future__ import annotations
import time
from typing import Any, TypeVar, Generic, Callable

T = TypeVar("T")
K = TypeVar("K")
UNDEFINED = object()
import sys

sys.set_int_max_str_digits(0)
import os, time

_now_seeded = False
_now_seed = 0


def _now():
    global _now_seeded, _now_seed
    if not _now_seeded:
        s = os.getenv("MOCHI_NOW_SEED")
        if s and s.isdigit():
            _now_seed = int(s)
            _now_seeded = True
    if _now_seeded:
        _now_seed = (_now_seed * 1664525 + 1013904223) % 2147483647
        return _now_seed
    return int(time.time_ns())


def newNum(n):
    return {"op": OP_NUM, "value": {"num": n, "denom": 1}}


def exprEval(x):
    if x["op"] == OP_NUM:
        return x["value"]
    l = exprEval(x["left"])
    r = exprEval(x["right"])
    if x["op"] == OP_ADD:
        return {
            "num": l["num"] * r["denom"] + l["denom"] * r["num"],
            "denom": l["denom"] * r["denom"],
        }
    if x["op"] == OP_SUB:
        return {
            "num": l["num"] * r["denom"] - l["denom"] * r["num"],
            "denom": l["denom"] * r["denom"],
        }
    if x["op"] == OP_MUL:
        return {"num": l["num"] * r["num"], "denom": l["denom"] * r["denom"]}
    return {"num": l["num"] * r["denom"], "denom": l["denom"] * r["num"]}


def exprString(x):
    if x["op"] == OP_NUM:
        return str(x["value"]["num"])
    ls = exprString(x["left"])
    rs = exprString(x["right"])
    opstr = ""
    if x["op"] == OP_ADD:
        opstr = " + "
    elif x["op"] == OP_SUB:
        opstr = " - "
    elif x["op"] == OP_MUL:
        opstr = " * "
    else:
        opstr = " / "
    return "(" + ls + opstr + rs + ")"


def solve(xs):
    if len(xs) == 1:
        f = exprEval(xs[0])
        if f["denom"] != 0 and f["num"] == f["denom"] * goal:
            print(exprString(xs[0]))
            return True
        return False
    i = 0
    while i < len(xs):
        j = i + 1
        while j < len(xs):
            rest = []
            k = 0
            while k < len(xs):
                if k != i and k != j:
                    rest = rest + [xs[k]]
                k = k + 1
            a = xs[i]
            b = xs[j]
            for op in [OP_ADD, OP_SUB, OP_MUL, OP_DIV]:
                node = {"op": op, "left": a, "right": b}
                if solve(rest + [node]):
                    return True
            node = {"op": OP_SUB, "left": b, "right": a}
            if solve(rest + [node]):
                return True
            node = {"op": OP_DIV, "left": b, "right": a}
            if solve(rest + [node]):
                return True
            j = j + 1
        i = i + 1
    return False


def main():
    iter = 0
    while iter < 10:
        cards = []
        i = 0
        while i < n_cards:
            n = _now() % (digit_range - 1) + 1
            cards = cards + [newNum(n)]
            print(" " + str(n))
            i = i + 1
        print(":  ")
        if not solve(cards):
            print("No solution")
        iter = iter + 1


OP_NUM = 0
OP_ADD = 1
OP_SUB = 2
OP_MUL = 3
OP_DIV = 4
n_cards = 4
goal = 24
digit_range = 9
main()
