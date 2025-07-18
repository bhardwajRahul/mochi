// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:46:11Z
// Source: tests/dataset/tpc-ds/q1.mochi

let customer: Record<string, any>[];
let customer_total_return: Record<string, any>[];
let date_dim: { [key: string]: number }[];
let result: Record<string, any>[];
let store: Record<string, any>[];
let store_returns: Record<string, any>[];

function test_TPCDS_Q1_result(): void {
  if (
    !(_equal(result, [
      { "c_customer_id": "C2" },
    ]))
  ) throw new Error("expect failed");
}

function main(): void {
  store_returns = [
    {
      "sr_returned_date_sk": 1,
      "sr_customer_sk": 1,
      "sr_store_sk": 10,
      "sr_return_amt": 20,
    },
    {
      "sr_returned_date_sk": 1,
      "sr_customer_sk": 2,
      "sr_store_sk": 10,
      "sr_return_amt": 50,
    },
  ];
  date_dim = [
    {
      "d_date_sk": 1,
      "d_year": 1998,
    },
  ];
  store = [
    {
      "s_store_sk": 10,
      "s_state": "TN",
    },
  ];
  customer = [
    {
      "c_customer_sk": 1,
      "c_customer_id": "C1",
    },
    {
      "c_customer_sk": 2,
      "c_customer_id": "C2",
    },
  ];
  customer_total_return = (() => {
    const _src = store_returns;
    const _map = new Map<string, any>();
    var _items = [];
    for (const sr of _src) {
      for (const d of date_dim) {
        if (!((sr.sr_returned_date_sk == d.d_date_sk) && (d.d_year == 1998))) {
          continue;
        }
        const _key = {
          "customer_sk": sr.sr_customer_sk,
          "store_sk": sr.sr_store_sk,
        };
        const _ks = JSON.stringify(_key);
        let _g = _map.get(_ks);
        if (!_g) {
          _g = { key: _key, items: [] };
          _map.set(_ks, _g);
        }
        _g.items.push({ ...sr, ...d, sr: sr, d: d });
      }
    }
    let _groups = Array.from(_map.values());
    const _res = [];
    for (const g of _groups) {
      _res.push({
        "ctr_customer_sk": g.key.customer_sk,
        "ctr_store_sk": g.key.store_sk,
        "ctr_total_return": g.items.map((x) => x.sr_return_amt).reduce(
          (a, b) => a + Number(b),
          0,
        ),
      });
    }
    return _res;
  })();
  result = (() => {
    const _src = customer_total_return;
    var _items = [];
    for (const ctr1 of _src) {
      for (const s of store) {
        if (!(ctr1.ctr_store_sk == s.s_store_sk)) continue;
        for (const c of customer) {
          if (!(ctr1.ctr_customer_sk == c.c_customer_sk)) continue;
          if (
            !((ctr1.ctr_total_return >
              ((customer_total_return.filter(
                (ctr2) => (ctr1.ctr_store_sk == ctr2.ctr_store_sk)
              ).map((ctr2) => ctr2.ctr_total_return).reduce((a, b) =>
                a + Number(b), 0) /
                customer_total_return.filter(
                  (ctr2) => (ctr1.ctr_store_sk == ctr2.ctr_store_sk)
                ).map((ctr2) =>
                  ctr2.ctr_total_return
                ).length) * 1.2)) && (s.s_state == "TN"))
          ) continue;
          _items.push({ ctr1: ctr1, s: s, c: c });
        }
      }
    }
    let _pairs = _items.map((it) => {
      const { ctr1, s, c } = it;
      return { item: it, key: c.c_customer_id };
    });
    _pairs.sort((a, b) => _cmp(a.key, b.key));
    _items = _pairs.map((p) => p.item);
    const _res = [];
    for (const _it of _items) {
      const ctr1 = _it.ctr1;
      const s = _it.s;
      const c = _it.c;
      _res.push({ "c_customer_id": c.c_customer_id });
    }
    return _res;
  })();
  console.log(_json(result));
  test_TPCDS_Q1_result();
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
