// Generated by Mochi TypeScript compiler

let filtered: any[];
let grouped: any[];
let nations: any[];
let partsupp: any[];
let suppliers: any[];

function main(): void {
  nations = [
    {
      "id": 1,
      "name": "A",
    },
    {
      "id": 2,
      "name": "B",
    },
  ];
  suppliers = [
    {
      "id": 1,
      "nation": 1,
    },
    {
      "id": 2,
      "nation": 2,
    },
  ];
  partsupp = [
    {
      "part": 100,
      "supplier": 1,
      "cost": 10,
      "qty": 2,
    },
    {
      "part": 100,
      "supplier": 2,
      "cost": 20,
      "qty": 1,
    },
    {
      "part": 200,
      "supplier": 1,
      "cost": 5,
      "qty": 3,
    },
  ];
  filtered = (() => {
    const _src = partsupp;
    const _res = [];
    for (const ps of _src) {
      for (const s of suppliers) {
        if (!(s.id == ps.supplier)) continue;
        for (const n of nations) {
          if (!(n.id == s.nation)) continue;
          if (!(n.name == "A")) continue;
          _res.push({
            "part": ps.part,
            "value": (ps.cost * ps.qty),
          });
        }
      }
    }
    return _res;
  })();
  grouped = (() => {
    const _src = filtered;
    const _map = new Map<string, any>();
    const _order: string[] = [];
    var _items = [];
    for (const x of _src) {
      const _key = x.part;
      const _ks = JSON.stringify(_key);
      let _g = _map.get(_ks);
      if (!_g) {
        _g = { key: _key, items: [] };
        _map.set(_ks, _g);
        _order.push(_ks);
      }
      _g.items.push({ ...x, x: x });
    }
    let _groups = _order.map((k) => _map.get(k)!);
    const _res = [];
    for (const g of _groups) {
      _res.push({
        "part": g.key,
        "total": _sum(g.items.map((r) => r.value)),
      });
    }
    return _res;
  })();
  console.log(Array.isArray(grouped) ? grouped.join(" ") : grouped);
}
function _sum(v: any): number {
  let list: any[] | null = null;
  if (Array.isArray(v)) list = v;
  else if (v && typeof v === "object") {
    if (Array.isArray((v as any).items)) list = (v as any).items;
    else if (Array.isArray((v as any).Items)) list = (v as any).Items;
  }
  if (!list || list.length === 0) return 0;
  let sum = 0;
  for (const n of list) sum += Number(n);
  return sum;
}

main();
