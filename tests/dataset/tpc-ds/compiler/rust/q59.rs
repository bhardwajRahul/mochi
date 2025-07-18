// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:22:50Z
#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Sales_year1 {
    week: i32,
    store: i32,
    amount: f64,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Sales_year2 {
    week: i32,
    store: i32,
    amount: f64,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Result {
    s_store_id1: i32,
    ratio: f64,
}

fn _json<T: std::fmt::Debug>(value: &T) {
    println!("{:?}", value);
}

fn main() {
    let sales_year1 = vec![Sales_year1 { week: 1, store: 1, amount: 100.0 }];
    let sales_year2 = vec![Sales_year2 { week: 53, store: 1, amount: 150.0 }];
    let join = { let mut tmp1 = Vec::new();for y1 in &sales_year1 { for y2 in &sales_year2 { if !(y1.store == y2.store && y1.week == y2.week - 52) { continue; } tmp1.push(Result { s_store_id1: y1.store, ratio: y2.amount / y1.amount }); } } tmp1 };
    let result = join;
    _json(&result);
    assert!(result == vec![Result { s_store_id1: 1, ratio: 1.5 }]);
}
