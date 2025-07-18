// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:46:13Z
// Source: tests/dataset/tpc-ds/q31.mochi

let counties: string[];
var result: any[];
let store_sales: Record<string, any>[];
let web_sales: Record<string, any>[];

function test_TPCDS_Q31_simplified(): void {
  if (
    !(_equal(result, [
      {
        "ca_county": "A",
        "d_year": 2000,
        "web_q1_q2_increase": 1.5,
        "store_q1_q2_increase": 1.2,
        "web_q2_q3_increase": 1.6666666666666667,
        "store_q2_q3_increase": 1.3333333333333333,
      },
    ]))
  ) throw new Error("expect failed");
}

function main(): void {
  store_sales = [
    {
      "ca_county": "A",
      "d_qoy": 1,
      "d_year": 2000,
      "ss_ext_sales_price": 100,
    },
    {
      "ca_county": "A",
      "d_qoy": 2,
      "d_year": 2000,
      "ss_ext_sales_price": 120,
    },
    {
      "ca_county": "A",
      "d_qoy": 3,
      "d_year": 2000,
      "ss_ext_sales_price": 160,
    },
    {
      "ca_county": "B",
      "d_qoy": 1,
      "d_year": 2000,
      "ss_ext_sales_price": 80,
    },
    {
      "ca_county": "B",
      "d_qoy": 2,
      "d_year": 2000,
      "ss_ext_sales_price": 90,
    },
    {
      "ca_county": "B",
      "d_qoy": 3,
      "d_year": 2000,
      "ss_ext_sales_price": 100,
    },
  ];
  web_sales = [
    {
      "ca_county": "A",
      "d_qoy": 1,
      "d_year": 2000,
      "ws_ext_sales_price": 100,
    },
    {
      "ca_county": "A",
      "d_qoy": 2,
      "d_year": 2000,
      "ws_ext_sales_price": 150,
    },
    {
      "ca_county": "A",
      "d_qoy": 3,
      "d_year": 2000,
      "ws_ext_sales_price": 250,
    },
    {
      "ca_county": "B",
      "d_qoy": 1,
      "d_year": 2000,
      "ws_ext_sales_price": 80,
    },
    {
      "ca_county": "B",
      "d_qoy": 2,
      "d_year": 2000,
      "ws_ext_sales_price": 90,
    },
    {
      "ca_county": "B",
      "d_qoy": 3,
      "d_year": 2000,
      "ws_ext_sales_price": 95,
    },
  ];
  counties = ["A", "B"];
  result = [];
  for (const county of counties) {
    let ss1 = store_sales.filter(
      (s) => ((s.ca_county == county) && (s.d_qoy == 1))
    ).map((s) => s.ss_ext_sales_price).reduce((a, b) => a + Number(b), 0);
    let ss2 = store_sales.filter(
      (s) => ((s.ca_county == county) && (s.d_qoy == 2))
    ).map((s) => s.ss_ext_sales_price).reduce((a, b) => a + Number(b), 0);
    let ss3 = store_sales.filter(
      (s) => ((s.ca_county == county) && (s.d_qoy == 3))
    ).map((s) => s.ss_ext_sales_price).reduce((a, b) => a + Number(b), 0);
    let ws1 = web_sales.filter(
      (w) => ((w.ca_county == county) && (w.d_qoy == 1))
    ).map((w) => w.ws_ext_sales_price).reduce((a, b) => a + Number(b), 0);
    let ws2 = web_sales.filter(
      (w) => ((w.ca_county == county) && (w.d_qoy == 2))
    ).map((w) => w.ws_ext_sales_price).reduce((a, b) => a + Number(b), 0);
    let ws3 = web_sales.filter(
      (w) => ((w.ca_county == county) && (w.d_qoy == 3))
    ).map((w) => w.ws_ext_sales_price).reduce((a, b) => a + Number(b), 0);
    let web_g1 = ws2 / ws1;
    let store_g1 = ss2 / ss1;
    let web_g2 = ws3 / ws2;
    let store_g2 = ss3 / ss2;
    if (((web_g1 > store_g1) && (web_g2 > store_g2))) {
      result = [...result, {
        "ca_county": county,
        "d_year": 2000,
        "web_q1_q2_increase": web_g1,
        "store_q1_q2_increase": store_g1,
        "web_q2_q3_increase": web_g2,
        "store_q2_q3_increase": store_g2,
      }];
    }
  }
  console.log(_json(result));
  test_TPCDS_Q31_simplified();
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
