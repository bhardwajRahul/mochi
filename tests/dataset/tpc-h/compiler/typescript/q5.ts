function _json(v: any) {
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
const region = [
  {r_regionkey: 0, r_name: "ASIA"},
  {r_regionkey: 1, r_name: "EUROPE"}
];
const nation = [
  {
  n_nationkey: 10,
  n_regionkey: 0,
  n_name: "JAPAN"
},
  {
  n_nationkey: 20,
  n_regionkey: 0,
  n_name: "INDIA"
},
  {
  n_nationkey: 30,
  n_regionkey: 1,
  n_name: "FRANCE"
}
];
const customer = [
  {c_custkey: 1, c_nationkey: 10},
  {c_custkey: 2, c_nationkey: 20}
];
const supplier = [
  {s_suppkey: 100, s_nationkey: 10},
  {s_suppkey: 200, s_nationkey: 20}
];
const orders = [
  {
  o_orderkey: 1000,
  o_custkey: 1,
  o_orderdate: "1994-03-15"
},
  {
  o_orderkey: 2000,
  o_custkey: 2,
  o_orderdate: "1994-06-10"
},
  {
  o_orderkey: 3000,
  o_custkey: 2,
  o_orderdate: "1995-01-01"
}
];
const lineitem = [
  {
  l_orderkey: 1000,
  l_suppkey: 100,
  l_extendedprice: 1000,
  l_discount: 0.05
},
  {
  l_orderkey: 2000,
  l_suppkey: 200,
  l_extendedprice: 800,
  l_discount: 0.1
},
  {
  l_orderkey: 3000,
  l_suppkey: 200,
  l_extendedprice: 900,
  l_discount: 0.05
}
];
const asia_nations = (() => {
  const _tmp1: any[] = [];
  for (const r of region) {
    for (const n of nation) {
      if (!((n.n_regionkey == r.r_regionkey))) continue;
      if (!((r.r_name == "ASIA"))) continue;
      _tmp1.push(n);
    }
  }
  return _tmp1;
})()
;
const local_customer_supplier_orders = (() => {
  const _tmp2: Array<{ nation: any; revenue: any }> = [];
  for (const c of customer) {
    for (const n of asia_nations) {
      if (!((c.c_nationkey == n.n_nationkey))) continue;
      for (const o of orders) {
        if (!((o.o_custkey == c.c_custkey))) continue;
        for (const l of lineitem) {
          if (!((l.l_orderkey == o.o_orderkey))) continue;
          for (const s of supplier) {
            if (!((s.s_suppkey == l.l_suppkey))) continue;
            if (!((((o.o_orderdate >= "1994-01-01") && (o.o_orderdate < "1995-01-01")) && (s.s_nationkey == c.c_nationkey)))) continue;
            _tmp2.push({
  nation: n.n_name,
  revenue: (l.l_extendedprice * ((1 - l.l_discount)))
});
          }
        }
      }
    }
  }
  return _tmp2;
})()
;
const result = (() => {
  let _tmp3: Array<{ n_name: any; revenue: number }> = [];
  const groups = {};
  for (const r of local_customer_supplier_orders) {
    const _k = JSON.stringify(r.nation);
    let g = groups[_k];
    if (!g) { g = []; g.key = r.nation; g.items = g; groups[_k] = g; }
    g.push(r);
  }
  for (const _k in groups) {
    const g = groups[_k];
    _tmp3.push({item: {
  n_name: g.key,
  revenue: (g.map((x) => x.revenue).reduce((a,b)=>a+b,0))
}, key: (-(g.map((x) => x.revenue).reduce((a,b)=>a+b,0)))});
  }
  _tmp3 = _tmp3.sort((a,b)=> a.key < b.key ? -1 : a.key > b.key ? 1 : 0).map(x=>x.item);
  return _tmp3;
})()
;
console.log(_json(result));
if (!(JSON.stringify(result) === JSON.stringify([
  {n_name: "JAPAN", revenue: 950},
  {n_name: "INDIA", revenue: 720}
]))) { throw new Error("Q5 returns revenue per nation in ASIA with local suppliers failed"); }
