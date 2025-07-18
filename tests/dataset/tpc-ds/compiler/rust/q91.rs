// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:22:56Z
#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct CallCenter {
        cc_call_center_sk: i32,
        cc_call_center_id: &'static str,
        cc_name: &'static str,
        cc_manager: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq)]
struct CatalogReturn {
        cr_call_center_sk: i32,
        cr_returned_date_sk: i32,
        cr_returning_customer_sk: i32,
        cr_net_loss: f64,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct DateDim {
        d_date_sk: i32,
        d_year: i32,
        d_moy: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct Customer {
        c_customer_sk: i32,
        c_current_cdemo_sk: i32,
        c_current_hdemo_sk: i32,
        c_current_addr_sk: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct CustomerAddress {
        ca_address_sk: i32,
        ca_gmt_offset: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct CustomerDemographics {
        cd_demo_sk: i32,
        cd_marital_status: &'static str,
        cd_education_status: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash)]
struct HouseholdDemographics {
        hd_demo_sk: i32,
        hd_buy_potential: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Call_center {
    cc_call_center_sk: i32,
    cc_call_center_id: &'static str,
    cc_name: &'static str,
    cc_manager: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Catalog_return {
    cr_call_center_sk: i32,
    cr_returned_date_sk: i32,
    cr_returning_customer_sk: i32,
    cr_net_loss: f64,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Date_dim {
    d_date_sk: i32,
    d_year: i32,
    d_moy: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer1 {
    c_customer_sk: i32,
    c_current_cdemo_sk: i32,
    c_current_hdemo_sk: i32,
    c_current_addr_sk: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer_demographic {
    cd_demo_sk: i32,
    cd_marital_status: &'static str,
    cd_education_status: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Household_demographic {
    hd_demo_sk: i32,
    hd_buy_potential: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Customer_addres {
    ca_address_sk: i32,
    ca_gmt_offset: i32,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Key {
    id: &'static str,
    name: &'static str,
    mgr: &'static str,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Item {
    cc: Call_center,
    cr: Catalog_return,
    d: Date_dim,
    c: Customer1,
    cd: Customer_demographic,
    hd: Household_demographic,
    ca: Customer_addres,
}

#[derive(Default, Debug, Clone, PartialEq, PartialOrd)]
struct Group {
    key: Key,
    items: Vec<Item>,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
struct Result {
    Call_Center: &'static str,
    Call_Center_Name: &'static str,
    Manager: &'static str,
    Returns_Loss: i32,
}

fn sum<T>(v: &[T]) -> T where T: std::iter::Sum<T> + Copy {
    v.iter().copied().sum()
}

fn _json<T: std::fmt::Debug>(value: &T) {
    println!("{:?}", value);
}

fn main() {
    let call_center = vec![Call_center { cc_call_center_sk: 1, cc_call_center_id: "CC1", cc_name: "Main", cc_manager: "Alice" }];
    let catalog_returns = vec![Catalog_return { cr_call_center_sk: 1, cr_returned_date_sk: 1, cr_returning_customer_sk: 1, cr_net_loss: 10.0 }];
    let date_dim = vec![Date_dim { d_date_sk: 1, d_year: 2001, d_moy: 5 }];
    let customer = vec![Customer1 { c_customer_sk: 1, c_current_cdemo_sk: 1, c_current_hdemo_sk: 1, c_current_addr_sk: 1 }];
    let customer_demographics = vec![Customer_demographic { cd_demo_sk: 1, cd_marital_status: "M", cd_education_status: "Unknown" }];
    let household_demographics = vec![Household_demographic { hd_demo_sk: 1, hd_buy_potential: "1001-5000" }];
    let customer_address = vec![Customer_addres { ca_address_sk: 1, ca_gmt_offset: -6 }];
    let result = first({ let mut tmp1 = std::collections::HashMap::new();for cc in &call_center { for cr in &catalog_returns { if !(cc.cc_call_center_sk == cr.cr_call_center_sk) { continue; } for d in &date_dim { if !(cr.cr_returned_date_sk == d.d_date_sk) { continue; } for c in &customer { if !(cr.cr_returning_customer_sk == c.c_customer_sk) { continue; } for cd in &customer_demographics { if !(c.c_current_cdemo_sk == cd.cd_demo_sk) { continue; } for hd in &household_demographics { if !(c.c_current_hdemo_sk == hd.hd_demo_sk) { continue; } for ca in &customer_address { if !(c.c_current_addr_sk == ca.ca_address_sk) { continue; } if !(d.d_year == 2001 && d.d_moy == 5 && cd.cd_marital_status == "M" && cd.cd_education_status == "Unknown" && hd.hd_buy_potential == "1001-5000" && ca.ca_gmt_offset == (-6)) { continue; } let key = Key { id: cc.cc_call_center_id, name: cc.cc_name, mgr: cc.cc_manager }; tmp1.entry(key).or_insert_with(Vec::new).push(Item {cc: cc.clone(), cr: cr.clone(), d: d.clone(), c: c.clone(), cd: cd.clone(), hd: hd.clone(), ca: ca.clone() }); } } } } } } } let mut tmp2 = Vec::<Group>::new(); for (k,v) in tmp1 { tmp2.push(Group { key: k, items: v }); } tmp2.sort_by(|a,b| a.key.partial_cmp(&b.key).unwrap()); let mut result = Vec::new(); for g in tmp2 { result.push(Result { Call_Center: g.key.id, Call_Center_Name: g.key.name, Manager: g.key.mgr, Returns_Loss: sum(&{ let mut tmp3 = Vec::new();for x in &g.clone().items { tmp3.push(x.cr_net_loss); } tmp3 }) }); } result });
    _json(&result.clone());
    assert!(result.clone() == Result { Call_Center: "CC1", Call_Center_Name: "Main", Manager: "Alice", Returns_Loss: 10.0 });
}
