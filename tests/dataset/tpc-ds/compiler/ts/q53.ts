// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:46:15Z
// Source: tests/dataset/tpc-ds/q53.mochi

function abs(x: number): number {
  if ((x >= 0)) {
    return x;
  }
  return (-x);
}

let date_dim: { [key: string]: number }[];
let grouped: Record<string, any>[];
let item: { [key: string]: number }[];
let result: Record<string, any>[];
let store_sales: Record<string, any>[];

function test_TPCDS_Q53_simplified(): void {
  if (
    !(_equal(result, [
      {
        "i_manufact_id": 1,
        "sum_sales": 20,
      },
      {
        "i_manufact_id": 2,
        "sum_sales": 53,
      },
    ]))
  ) throw new Error("expect failed");
}

function main(): void {
  item = [
    {
      "i_item_sk": 1,
      "i_manufact_id": 1,
    },
    {
      "i_item_sk": 2,
      "i_manufact_id": 2,
    },
  ];
  store_sales = [
    {
      "item": 1,
      "date": 1,
      "price": 10,
    },
    {
      "item": 1,
      "date": 2,
      "price": 10,
    },
    {
      "item": 2,
      "date": 1,
      "price": 30,
    },
    {
      "item": 2,
      "date": 2,
      "price": 23,
    },
  ];
  date_dim = [
    {
      "d_date_sk": 1,
      "d_month_seq": 1,
    },
    {
      "d_date_sk": 2,
      "d_month_seq": 2,
    },
  ];
  grouped = (() => {
    const _src = store_sales;
    const _map = new Map<string, any>();
    var _items = [];
    for (const ss of _src) {
      for (const i of item) {
        if (!(ss.item == i.i_item_sk)) continue;
        for (const d of date_dim) {
          if (!(ss.date == d.d_date_sk)) continue;
          const _key = i.i_manufact_id;
          const _ks = JSON.stringify(_key);
          let _g = _map.get(_ks);
          if (!_g) {
            _g = { key: _key, items: [] };
            _map.set(_ks, _g);
          }
          _g.items.push({ ...ss, ...i, ...d, ss: ss, i: i, d: d });
        }
      }
    }
    let _groups = Array.from(_map.values());
    const _res = [];
    for (const g of _groups) {
      _res.push({
        "manu": g.key,
        "sum_sales": g.items.map((x) => x.price).reduce(
          (a, b) => a + Number(b),
          0,
        ),
        "avg_sales": (g.items.map((x) =>
          x.price
        ).reduce((a, b) => a + Number(b), 0) / g.items.map((x) =>
          x.price
        ).length),
      });
    }
    return _res;
  })();
  result = grouped.filter(
    (g) => ((g.avg_sales > 0) &&
      ((abs(g.sum_sales - g.avg_sales) / g.avg_sales) > 0.1))
  ).map((g) => ({
    "i_manufact_id": g.manu,
    "sum_sales": g.sum_sales,
  }));
  console.log(_json(result));
  test_TPCDS_Q53_simplified();
}
function _equal(a: unknown, b: unknown): boolean {
  if (typeof a === "number" && typeof b === "number") {
    return Math.abs(a - b) < 1e-9;
  }
  if (Array.isArray(a) && Array.isArray(b)) {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) if (!_equal(a[i], b[i])) return false;
    return true;
  }
  if (a && b && typeof a === "object" && typeof b === "object") {
    const ak = Object.keys(a);
    const bk = Object.keys(b);
    if (ak.length !== bk.length) return false;
    for (const k of ak) {
      if (!bk.includes(k) || !_equal((a as any)[k], (b as any)[k])) {
        return false;
      }
    }
    return true;
  }
  return a === b;
}

function _json(v: any): string {
  function _sort(x: any): any {
    if (Array.isArray(x)) return x.map(_sort);
    if (x && typeof x === "object") {
      const keys = Object.keys(x).sort();
      const o: any = {};
      for (const k of keys) o[k] = _sort(x[k]);
      return o;
    }
    return x;
  }
  return JSON.stringify(_sort(v));
}

main();
