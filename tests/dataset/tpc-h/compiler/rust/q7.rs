// Generated by Mochi compiler v0.10.25 on 2025-07-13T16:54:28Z
#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Nation {
    n_nationkey: i32,
    n_name: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Supplier {
    s_suppkey: i32,
    s_nationkey: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer {
    c_custkey: i32,
    c_nationkey: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Order {
    o_orderkey: i32,
    o_custkey: i32,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Lineitem {
    l_orderkey: i32,
    l_suppkey: i32,
    l_extendedprice: f64,
    l_discount: f64,
    l_shipdate: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Key {
    supp_nation: &'static str,
    cust_nation: &'static str,
    l_year: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Item {
    l: Lineitem,
    o: Order,
    c: Customer,
    s: Supplier,
    n1: Nation,
    n2: Nation,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Group {
    key: Key,
    items: Vec<Item>,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Result {
    supp_nation: &'static str,
    cust_nation: &'static str,
    l_year: &'static str,
    revenue: f64,
}

fn sum<T>(v: &[T]) -> T where T: std::iter::Sum<T> + Copy {
    v.iter().copied().sum()
}

fn _json<T: std::fmt::Debug>(value: &T) {
    println!("{:?}", value);
}

fn main() {
    let nation = vec![Nation { n_nationkey: 1, n_name: "FRANCE" }, Nation { n_nationkey: 2, n_name: "GERMANY" }];
    let supplier = vec![Supplier { s_suppkey: 100, s_nationkey: 1 }];
    let customer = vec![Customer { c_custkey: 200, c_nationkey: 2 }];
    let orders = vec![Order { o_orderkey: 1000, o_custkey: 200 }];
    let lineitem = vec![Lineitem { l_orderkey: 1000, l_suppkey: 100, l_extendedprice: 1000.0, l_discount: 0.1, l_shipdate: "1995-06-15" }, Lineitem { l_orderkey: 1000, l_suppkey: 100, l_extendedprice: 800.0, l_discount: 0.05, l_shipdate: "1997-01-01" }];
    let start_date = "1995-01-01";
    let end_date = "1996-12-31";
    let nation1 = "FRANCE";
    let nation2 = "GERMANY";
    let result = { let mut tmp1 = std::collections::HashMap::new();for l in &lineitem { for o in &orders { if !(o.o_orderkey == l.l_orderkey) { continue; } for c in &customer { if !(c.c_custkey == o.o_custkey) { continue; } for s in &supplier { if !(s.s_suppkey == l.l_suppkey) { continue; } for n1 in &nation { if !(n1.n_nationkey == s.s_nationkey) { continue; } for n2 in &nation { if !(n2.n_nationkey == c.c_nationkey) { continue; } if !((l.l_shipdate >= start_date && l.l_shipdate <= end_date && (n1.n_name == nation1 && n2.n_name == nation2) || (n1.n_name == nation2 && n2.n_name == nation1))) { continue; } let key = Key { supp_nation: n1.n_name, cust_nation: n2.n_name, l_year: &l.l_shipdate[0..4] }; tmp1.entry(key).or_insert_with(Vec::new).push(Item {l: l.clone(), o: o.clone(), c: c.clone(), s: s.clone(), n1: n1.clone(), n2: n2.clone() }); } } } } } } let mut tmp2 = Vec::<Group>::new(); for (k,v) in tmp1 { tmp2.push(Group { key: k, items: v }); } tmp2.sort_by(|a,b| a.key.partial_cmp(&b.key).unwrap()); tmp2.sort_by(|a,b| ((a.key.supp_nation, a.key.cust_nation, a.key.l_year)).partial_cmp(&((b.key.supp_nation, b.key.cust_nation, b.key.l_year))).unwrap()); let mut result = Vec::new(); for g in tmp2 { result.push(Result { supp_nation: g.key.supp_nation, cust_nation: g.key.cust_nation, l_year: g.key.l_year, revenue: sum(&{ let mut tmp3 = Vec::new();for x in &g.clone().items { tmp3.push(x.l.l_extendedprice * ((1 as f64) - x.l.l_discount as f64)); } tmp3 }) }); } result };
    _json(&result);
    assert!(result == vec![Result { supp_nation: "FRANCE", cust_nation: "GERMANY", l_year: "1995", revenue: 900.0 }]);
}
