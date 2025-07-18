// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:46:12Z
// Source: tests/dataset/tpc-ds/q16.mochi

type CatalogSale = {
  cs_order_number: number;
  cs_ship_date_sk: number;
  cs_ship_addr_sk: number;
  cs_call_center_sk: number;
  cs_warehouse_sk: number;
  cs_ext_ship_cost: number;
  cs_net_profit: number;
};

type DateDim = {
  d_date_sk: number;
  d_date: string;
};

type CustomerAddress = {
  ca_address_sk: number;
  ca_state: string;
};

type CallCenter = {
  cc_call_center_sk: number;
  cc_county: string;
};

type CatalogReturn = {
  cr_order_number: number;
};

function distinct(xs: any[]): any[] {
  var out = [];
  for (const x of xs) {
    if ((!out.includes(x))) {
      out = [...out, x];
    }
  }
  return out;
}

let call_center: Record<string, any>[];
let catalog_returns: any[];
let catalog_sales: Record<string, any>[];
let customer_address: Record<string, any>[];
let date_dim: Record<string, any>[];
let filtered: Record<string, any>[];

function test_TPCDS_Q16_shipping(): void {
  if (
    !(_equal(filtered, [
      {
        "order_count": 1,
        "total_shipping_cost": 5,
        "total_net_profit": 20,
      },
    ]))
  ) throw new Error("expect failed");
}

function main(): void {
  catalog_sales = [
    {
      "cs_order_number": 1,
      "cs_ship_date_sk": 1,
      "cs_ship_addr_sk": 1,
      "cs_call_center_sk": 1,
      "cs_warehouse_sk": 1,
      "cs_ext_ship_cost": 5,
      "cs_net_profit": 20,
    },
    {
      "cs_order_number": 1,
      "cs_ship_date_sk": 1,
      "cs_ship_addr_sk": 1,
      "cs_call_center_sk": 1,
      "cs_warehouse_sk": 2,
      "cs_ext_ship_cost": 0,
      "cs_net_profit": 0,
    },
  ];
  date_dim = [
    {
      "d_date_sk": 1,
      "d_date": "2000-03-01",
    },
  ];
  customer_address = [
    {
      "ca_address_sk": 1,
      "ca_state": "CA",
    },
  ];
  call_center = [
    {
      "cc_call_center_sk": 1,
      "cc_county": "CountyA",
    },
  ];
  catalog_returns = [];
  filtered = (() => {
    const _src = catalog_sales;
    const _map = new Map<string, any>();
    var _items = [];
    for (const cs1 of _src) {
      for (const d of date_dim) {
        if (
          !(((cs1.cs_ship_date_sk == d.d_date_sk) &&
            (d.d_date >= "2000-03-01")) && (d.d_date <= "2000-04-30"))
        ) continue;
        for (const ca of customer_address) {
          if (
            !((cs1.cs_ship_addr_sk == ca.ca_address_sk) &&
              (ca.ca_state == "CA"))
          ) continue;
          for (const cc of call_center) {
            if (
              !((cs1.cs_call_center_sk == cc.cc_call_center_sk) &&
                (cc.cc_county == "CountyA"))
            ) continue;
            if (
              !((catalog_sales.filter(
                (cs2) => ((cs1.cs_order_number == cs2.cs_order_number) &&
                  (cs1.cs_warehouse_sk != cs2.cs_warehouse_sk))
              ).map((cs2) => cs2).length > 0) &&
                ((catalog_returns.filter(
                  (cr) => (cs1.cs_order_number == cr.cr_order_number)
                ).map((cr) => cr).length > 0) == false))
            ) continue;
            const _key = {};
            const _ks = JSON.stringify(_key);
            let _g = _map.get(_ks);
            if (!_g) {
              _g = { key: _key, items: [] };
              _map.set(_ks, _g);
            }
            _g.items.push({
              ...cs1,
              ...d,
              ...ca,
              ...cc,
              cs1: cs1,
              d: d,
              ca: ca,
              cc: cc,
            });
          }
        }
      }
    }
    let _groups = Array.from(_map.values());
    const _res = [];
    for (const g of _groups) {
      _res.push({
        "order_count": distinct(g.items.map((x) => x.cs_order_number)).length,
        "total_shipping_cost": g.items.map((x) => x.cs_ext_ship_cost).reduce(
          (a, b) => a + Number(b),
          0,
        ),
        "total_net_profit": g.items.map((x) => x.cs_net_profit).reduce(
          (a, b) => a + Number(b),
          0,
        ),
      });
    }
    return _res;
  })();
  console.log(_json(filtered));
  test_TPCDS_Q16_shipping();
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
