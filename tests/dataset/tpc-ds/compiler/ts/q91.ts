// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:46:17Z
// Source: tests/dataset/tpc-ds/q91.mochi

type CallCenter = {
  cc_call_center_sk: number;
  cc_call_center_id: string;
  cc_name: string;
  cc_manager: string;
};

type CatalogReturn = {
  cr_call_center_sk: number;
  cr_returned_date_sk: number;
  cr_returning_customer_sk: number;
  cr_net_loss: number;
};

type DateDim = {
  d_date_sk: number;
  d_year: number;
  d_moy: number;
};

type Customer = {
  c_customer_sk: number;
  c_current_cdemo_sk: number;
  c_current_hdemo_sk: number;
  c_current_addr_sk: number;
};

type CustomerAddress = {
  ca_address_sk: number;
  ca_gmt_offset: number;
};

type CustomerDemographics = {
  cd_demo_sk: number;
  cd_marital_status: string;
  cd_education_status: string;
};

type HouseholdDemographics = {
  hd_demo_sk: number;
  hd_buy_potential: string;
};

let call_center: Record<string, any>[];
let catalog_returns: Record<string, any>[];
let customer: { [key: string]: number }[];
let customer_address: { [key: string]: number }[];
let customer_demographics: Record<string, any>[];
let date_dim: { [key: string]: number }[];
let household_demographics: Record<string, any>[];
let result: any;

function test_TPCDS_Q91_returns(): void {
  if (
    !(_equal(result, {
      "Call_Center": "CC1",
      "Call_Center_Name": "Main",
      "Manager": "Alice",
      "Returns_Loss": 10,
    }))
  ) throw new Error("expect failed");
}

function main(): void {
  call_center = [
    {
      "cc_call_center_sk": 1,
      "cc_call_center_id": "CC1",
      "cc_name": "Main",
      "cc_manager": "Alice",
    },
  ];
  catalog_returns = [
    {
      "cr_call_center_sk": 1,
      "cr_returned_date_sk": 1,
      "cr_returning_customer_sk": 1,
      "cr_net_loss": 10,
    },
  ];
  date_dim = [
    {
      "d_date_sk": 1,
      "d_year": 2001,
      "d_moy": 5,
    },
  ];
  customer = [
    {
      "c_customer_sk": 1,
      "c_current_cdemo_sk": 1,
      "c_current_hdemo_sk": 1,
      "c_current_addr_sk": 1,
    },
  ];
  customer_demographics = [
    {
      "cd_demo_sk": 1,
      "cd_marital_status": "M",
      "cd_education_status": "Unknown",
    },
  ];
  household_demographics = [
    {
      "hd_demo_sk": 1,
      "hd_buy_potential": "1001-5000",
    },
  ];
  customer_address = [
    {
      "ca_address_sk": 1,
      "ca_gmt_offset": (-6),
    },
  ];
  result = ((() => {
    const _src = call_center;
    const _map = new Map<string, any>();
    var _items = [];
    for (const cc of _src) {
      for (const cr of catalog_returns) {
        if (!(cc.cc_call_center_sk == cr.cr_call_center_sk)) continue;
        for (const d of date_dim) {
          if (!(cr.cr_returned_date_sk == d.d_date_sk)) continue;
          for (const c of customer) {
            if (!(cr.cr_returning_customer_sk == c.c_customer_sk)) continue;
            for (const cd of customer_demographics) {
              if (!(c.c_current_cdemo_sk == cd.cd_demo_sk)) continue;
              for (const hd of household_demographics) {
                if (!(c.c_current_hdemo_sk == hd.hd_demo_sk)) continue;
                for (const ca of customer_address) {
                  if (!(c.c_current_addr_sk == ca.ca_address_sk)) continue;
                  if (
                    !((((((d.d_year == 2001) && (d.d_moy == 5)) &&
                      (cd.cd_marital_status == "M")) &&
                      (cd.cd_education_status == "Unknown")) &&
                      (hd.hd_buy_potential == "1001-5000")) &&
                      (ca.ca_gmt_offset == (-6)))
                  ) continue;
                  const _key = {
                    "id": cc.cc_call_center_id,
                    "name": cc.cc_name,
                    "mgr": cc.cc_manager,
                  };
                  const _ks = JSON.stringify(_key);
                  let _g = _map.get(_ks);
                  if (!_g) {
                    _g = { key: _key, items: [] };
                    _map.set(_ks, _g);
                  }
                  _g.items.push({
                    ...cc,
                    ...cr,
                    ...d,
                    ...c,
                    ...cd,
                    ...hd,
                    ...ca,
                    cc: cc,
                    cr: cr,
                    d: d,
                    c: c,
                    cd: cd,
                    hd: hd,
                    ca: ca,
                  });
                }
              }
            }
          }
        }
      }
    }
    let _groups = Array.from(_map.values());
    const _res = [];
    for (const g of _groups) {
      _res.push({
        "Call_Center": g.key.id,
        "Call_Center_Name": g.key.name,
        "Manager": g.key.mgr,
        "Returns_Loss": g.items.map((x) => x.cr_net_loss).reduce(
          (a, b) => a + Number(b),
          0,
        ),
      });
    }
    return _res;
  })())[0];
  console.log(_json(result));
  test_TPCDS_Q91_returns();
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
