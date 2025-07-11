#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct Item {
    n: i32,
    v: &'static str,
}

fn main() {
    let items = vec![Item { n: 1, v: "a" }, Item { n: 1, v: "b" }, Item { n: 2, v: "c" }];
    let result = { let mut tmp1 = Vec::new();for i in &items { let tmp2 = i.v; let tmp3 = i.n; tmp1.push((tmp3, tmp2)); } tmp1.sort_by(|a,b| a.0.partial_cmp(&b.0).unwrap()); let mut tmp4 = Vec::new(); for p in tmp1 { tmp4.push(p.1); } tmp4 };
    println!("{:?}", result);
}
