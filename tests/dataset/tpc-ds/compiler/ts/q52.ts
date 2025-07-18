// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:46:15Z
// Source: tests/dataset/tpc-ds/q52.mochi

let date_dim: { [key: string]: number }[];
let filtered: Record<string, any>[];
let item: Record<string, any>[];
let result: Record<string, any>[];
let store_sales: Record<string, any>[];

function test_TPCDS_Q52_simplified(): void {
  if (
    !(_equal(result, [
      {
        "d_year": 2001,
        "brand_id": 1,
        "ext_price": 30,
      },
      {
        "d_year": 2001,
        "brand_id": 2,
        "ext_price": 22,
      },
    ]))
  ) throw new Error("expect failed");
}

function main(): void {
  store_sales = [
    {
      "item": 1,
      "sold_date": 1,
      "price": 10,
    },
    {
      "item": 2,
      "sold_date": 1,
      "price": 22,
    },
    {
      "item": 1,
      "sold_date": 1,
      "price": 20,
    },
  ];
  item = [
    {
      "i_item_sk": 1,
      "i_brand_id": 1,
      "i_brand": "B1",
      "i_manager_id": 1,
    },
    {
      "i_item_sk": 2,
      "i_brand_id": 2,
      "i_brand": "B2",
      "i_manager_id": 1,
    },
  ];
  date_dim = [
    {
      "d_date_sk": 1,
      "d_year": 2001,
      "d_moy": 11,
    },
  ];
  filtered = (() => {
    const _src = store_sales;
    const _map = new Map<string, any>();
    var _items = [];
    for (const ss of _src) {
      for (const i of item) {
        if (!((ss.item == i.i_item_sk) && (i.i_manager_id == 1))) continue;
        for (const d of date_dim) {
          if (
            !(((ss.sold_date == d.d_date_sk) && (d.d_year == 2001)) &&
              (d.d_moy == 11))
          ) continue;
          const _key = {
            "year": d.d_year,
            "brand_id": i.i_brand_id,
            "brand": i.i_brand,
          };
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
        "d_year": g.key.year,
        "brand_id": g.key.brand_id,
        "ext_price": g.items.map((x) => x.price).reduce(
          (a, b) => a + Number(b),
          0,
        ),
      });
    }
    return _res;
  })();
  result = (() => {
    const _src = filtered;
    var _items = [];
    for (const r of _src) {
      _items.push({ r: r });
    }
    let _pairs = _items.map((it) => {
      const { r } = it;
      return { item: it, key: [r.d_year, -r.ext_price, r.brand_id] };
    });
    _pairs.sort((a, b) => _cmp(a.key, b.key));
    _items = _pairs.map((p) => p.item);
    const _res = [];
    for (const _it of _items) {
      const r = _it.r;
      _res.push(r);
    }
    return _res;
  })();
  console.log(_json(result));
  test_TPCDS_Q52_simplified();
}
function _cmp(a: unknown, b: unknown): number {
  if (Array.isArray(a) && Array.isArray(b)) {
    const n = Math.min(a.length, b.length);
    for (let i = 0; i < n; i++) {
      const c = _cmp(a[i], b[i]);
      if (c !== 0) return c;
    }
    return a.length - b.length;
  }
  if (typeof a === "number" && typeof b === "number") return a - b;
  if (typeof a === "string" && typeof b === "string") {
    const order: Record<string, number> = { store: 0, web: 1, catalog: 2 };
    if (order[a] !== undefined && order[b] !== undefined) {
      return order[a] - order[b];
    }
    return a < b ? -1 : (a > b ? 1 : 0);
  }
  return String(a) < String(b) ? -1 : (String(a) > String(b) ? 1 : 0);
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
