// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:22:56Z
#[derive(Default, Debug, Clone, PartialEq)]
struct WebSale {
        ws_order_number: i32,
        ws_warehouse_sk: i32,
        ws_ship_date_sk: i32,
        ws_ship_addr_sk: i32,
        ws_web_site_sk: i32,
        ws_ext_ship_cost: f64,
        ws_net_profit: f64,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct WebReturn {
        wr_order_number: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct DateDim {
        d_date_sk: i32,
        d_date: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct CustomerAddress {
        ca_address_sk: i32,
        ca_state: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct WebSite {
        web_site_sk: i32,
        web_company_name: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Web_sale {
    ws_order_number: i32,
    ws_warehouse_sk: i32,
    ws_ship_date_sk: i32,
    ws_ship_addr_sk: i32,
    ws_web_site_sk: i32,
    ws_ext_ship_cost: f64,
    ws_net_profit: f64,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Web_return {
    wr_order_number: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Date_dim {
    d_date_sk: i32,
    d_date: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer_addres {
    ca_address_sk: i32,
    ca_state: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Web_site {
    web_site_sk: i32,
    web_company_name: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Result {
    ws_order_number: i32,
}

fn append<T: Clone>(mut v: Vec<T>, item: T) -> Vec<T> {
    v.push(item);
    v
}

fn sum<T>(v: &[T]) -> T where T: std::iter::Sum<T> + Copy {
    v.iter().copied().sum()
}

fn _json<T: std::fmt::Debug>(value: &T) {
    println!("{:?}", value);
}

fn main() {
    fn distinct(xs: Vec<i32>) -> Vec<i32> {
        let mut out = vec![];
        for x in xs {
            if !contains(out, x) {
                out = append(out, x);
            }
        }
        return out;
    }
    let web_sales = vec![Web_sale { ws_order_number: 1, ws_warehouse_sk: 1, ws_ship_date_sk: 1, ws_ship_addr_sk: 1, ws_web_site_sk: 1, ws_ext_ship_cost: 2.0, ws_net_profit: 5.0 }, Web_sale { ws_order_number: 1, ws_warehouse_sk: 2, ws_ship_date_sk: 1, ws_ship_addr_sk: 1, ws_web_site_sk: 1, ws_ext_ship_cost: 0.0, ws_net_profit: 0.0 }];
    let web_returns = vec![Web_return { wr_order_number: 1 }];
    let date_dim = vec![Date_dim { d_date_sk: 1, d_date: "2001-02-01" }];
    let customer_address = vec![Customer_addres { ca_address_sk: 1, ca_state: "CA" }];
    let web_site = vec![Web_site { web_site_sk: 1, web_company_name: "pri" }];
    let ws_wh = { let mut tmp1 = Vec::new();for ws1 in &web_sales { for ws2 in &web_sales { if !(ws1.ws_order_number == ws2.ws_order_number && ws1.ws_warehouse_sk != ws2.ws_warehouse_sk) { continue; } tmp1.push(Result { ws_order_number: ws1.ws_order_number }); } } tmp1 };
    let filtered = { let mut tmp4 = Vec::new();for ws in &web_sales { for d in &date_dim { if !(ws.ws_ship_date_sk == d.d_date_sk) { continue; } for ca in &customer_address { if !(ws.ws_ship_addr_sk == ca.ca_address_sk) { continue; } for w in &web_site { if !(ws.ws_web_site_sk == w.web_site_sk) { continue; } if !(({ let mut tmp3 = Vec::new();for wr in &web_returns { tmp3.push(wr.wr_order_number); } tmp3 }).contains(&({ let mut tmp2 = Vec::new();for x in &ws_wh { tmp2.push(x.ws_order_number); } tmp2 }).contains(&ca.ca_state == "CA" && w.web_company_name == "pri" && ws.ws_order_number) && ws.ws_order_number)) { continue; } tmp4.push(ws.clone()); } } } } tmp4 };
    let result = { let mut m = std::collections::BTreeMap::new(); m.insert("order_count", distinct({ let mut tmp5 = Vec::new();for x in &filtered { tmp5.push(x.ws_order_number); } tmp5 }).len() as i32); m.insert("total_shipping_cost", sum(&{ let mut tmp6 = Vec::new();for x in &filtered { tmp6.push(x.ws_ext_ship_cost); } tmp6 })); m.insert("total_net_profit", sum(&{ let mut tmp7 = Vec::new();for x in &filtered { tmp7.push(x.ws_net_profit); } tmp7 })); m };
    _json(&result.clone());
    assert!(result.clone() == { let mut m = std::collections::BTreeMap::new(); m.insert("order_count", 1); m.insert("total_shipping_cost", 2.0); m.insert("total_net_profit", 5.0); m });
}
