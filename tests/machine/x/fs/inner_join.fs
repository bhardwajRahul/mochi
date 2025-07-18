// Generated by Mochi compiler v0.10.27 on 2025-07-17T07:47:20Z
open System

type Anon1 = {
    id: int
    name: string
}
type Anon2 = {
    id: int
    customerId: int
    total: int
}
type Anon3 = {
    orderId: obj
    customerName: obj
    total: obj
}
type Anon4 = {
    orderId: int
    customerName: string
    total: int
}
let customers: Anon1 list = [{ id = 1; name = "Alice" }; { id = 2; name = "Bob" }; { id = 3; name = "Charlie" }]
let orders: Anon2 list = [{ id = 100; customerId = 1; total = 250 }; { id = 101; customerId = 2; total = 125 }; { id = 102; customerId = 1; total = 300 }; { id = 103; customerId = 4; total = 80 }]
let result: Anon4 list = [ for o in orders do 
  for c in customers do if o.customerId = c.id then yield { orderId = o.id; customerName = c.name; total = o.total } ]
printfn "%s" "--- Orders with customer info ---"
for entry in result do
    printfn "%s" (String.concat " " [string "Order"; string entry.orderId; string "by"; string entry.customerName; string "- $"; string entry.total])
