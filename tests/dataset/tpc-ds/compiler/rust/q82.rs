// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:22:54Z
#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Item {
    id: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Inventory {
    item: i32,
    qty: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Store_sale {
    item: i32,
}

fn _json<T: std::fmt::Debug>(value: &T) {
    println!("{:?}", value);
}

fn main() {
    let item = vec![Item { id: 1 }, Item { id: 2 }, Item { id: 3 }];
    let inventory = vec![Inventory { item: 1, qty: 20 }, Inventory { item: 1, qty: 22 }, Inventory { item: 1, qty: 5 }, Inventory { item: 2, qty: 30 }, Inventory { item: 2, qty: 5 }, Inventory { item: 3, qty: 10 }];
    let store_sales = vec![Store_sale { item: 1 }, Store_sale { item: 2 }];
    let mut result = 0;
    for inv in inventory {
        for s in store_sales {
            if inv.item == s.item {
                result += inv.qty;
            }
        }
    }
    _json(&result);
    assert!(result == 82);
}
