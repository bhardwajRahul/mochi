// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:22:37Z
#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Store_sale {
    ss_store_sk: i32,
    ss_sold_date_sk: i32,
    ss_net_profit: f64,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Date_dim {
    d_date_sk: i32,
    d_qoy: i32,
    d_year: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Store {
    s_store_sk: i32,
    s_store_name: &'static str,
    s_zip: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer_addres {
    ca_address_sk: i32,
    ca_zip: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer {
    c_customer_sk: i32,
    c_current_addr_sk: i32,
    c_preferred_cust_flag: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Item {
    ss: Store_sale,
    d: Date_dim,
    s: Store,
    ca: Customer_addres,
    c: Customer,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Group {
    key: &'static str,
    items: Vec<Item>,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Result {
    s_store_name: &'static str,
    net_profit: f64,
}

fn sum<T>(v: &[T]) -> T where T: std::iter::Sum<T> + Copy {
    v.iter().copied().sum()
}

fn _json<T: std::fmt::Debug>(value: &T) {
    println!("{:?}", value);
}

fn main() {
    let store_sales = vec![Store_sale { ss_store_sk: 1, ss_sold_date_sk: 1, ss_net_profit: 10.0 }];
    let date_dim = vec![Date_dim { d_date_sk: 1, d_qoy: 1, d_year: 1998 }];
    let store = vec![Store { s_store_sk: 1, s_store_name: "Store1", s_zip: "12345" }];
    let customer_address = vec![Customer_addres { ca_address_sk: 1, ca_zip: "12345" }];
    let customer = vec![Customer { c_customer_sk: 1, c_current_addr_sk: 1, c_preferred_cust_flag: "Y" }];
    reverse(substr("zip", 0, 2));
    let zip_list = vec!["12345"];
    let result = { let mut tmp1 = std::collections::HashMap::new();for ss in &store_sales { for d in &date_dim { if !(ss.ss_sold_date_sk == d.d_date_sk && d.d_qoy == 1 && d.d_year == 1998) { continue; } for s in &store { if !(ss.ss_store_sk == s.s_store_sk) { continue; } for ca in &customer_address { if !(substr(s.s_zip, 0, 2) == substr(ca.ca_zip, 0, 2)) { continue; } for c in &customer { if !(ca.ca_address_sk == c.c_current_addr_sk && c.c_preferred_cust_flag == "Y") { continue; } if !(zip_list.contains(&substr(ca.ca_zip, 0, 5))) { continue; } let key = s.s_store_name; tmp1.entry(key).or_insert_with(Vec::new).push(Item {ss: ss.clone(), d: d.clone(), s: s.clone(), ca: ca.clone(), c: c.clone() }); } } } } } let mut tmp2 = Vec::<Group>::new(); for (k,v) in tmp1 { tmp2.push(Group { key: k, items: v }); } tmp2.sort_by(|a,b| a.key.partial_cmp(&b.key).unwrap()); tmp2.sort_by(|a,b| (a.key).partial_cmp(&(b.key)).unwrap()); let mut result = Vec::new(); for g in tmp2 { result.push(Result { s_store_name: g.key, net_profit: sum(&{ let mut tmp3 = Vec::new();for x in &g.clone().items { tmp3.push(x.ss.ss_net_profit); } tmp3 }) }); } result };
    _json(&result);
    assert!(result == vec![Result { s_store_name: "Store1", net_profit: 10.0 }]);
}
