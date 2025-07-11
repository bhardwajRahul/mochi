const customers = [
  {id: 1, name: "Alice"},
  {id: 2, name: "Bob"},
  {id: 3, name: "Charlie"},
  {id: 4, name: "Diana"}
];
const orders = [
  {
  id: 100,
  customerId: 1,
  total: 250
},
  {
  id: 101,
  customerId: 2,
  total: 125
},
  {
  id: 102,
  customerId: 1,
  total: 300
},
  {
  id: 103,
  customerId: 5,
  total: 80
}
];
const result = (() => {
  const _tmp1: Array<{ customer: any; order: any }> = [];
  for (const o of orders) {
    for (const c of customers) {
      if (!((o.customerId == c.id))) continue;
      _tmp1.push({order: o, customer: c});
    }
  }
  return _tmp1;
})()
;
console.log("--- Outer Join using syntax ---");
for (const row of result) {
  if (row.order) {
    if (row.customer) {
      console.log("Order", row.order.id, "by", row.customer.name, "- $", row.order.total);
    } else {
      console.log("Order", row.order.id, "by", "Unknown", "- $", row.order.total);
    }
  } else {
    console.log("Customer", row.customer.name, "has no orders");
  }
}
