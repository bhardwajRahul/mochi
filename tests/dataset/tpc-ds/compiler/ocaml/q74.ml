(* Generated by Mochi compiler v0.10.25 on 2025-07-15T04:50:17Z *)
let sum lst = List.fold_left (+) 0 lst
let sum_float lst = List.fold_left (+.) 0.0 lst
type ('k,'v) group = { key : 'k; items : 'v list }

type record1 = { mutable c_customer_sk : int; mutable c_customer_id : int; mutable c_first_name : string; mutable c_last_name : string }
type record2 = { mutable d_date_sk : int; mutable d_year : int }
type record3 = { mutable ss_customer_sk : int; mutable ss_sold_date_sk : int; mutable ss_net_paid : float }
type record4 = { mutable ws_bill_customer_sk : int; mutable ws_sold_date_sk : int; mutable ws_net_paid : float }
type record5 = { mutable id : int; mutable first : string; mutable last : string; mutable year : int }
type record6 = { mutable customer_id : Obj.t; mutable customer_first_name : Obj.t; mutable customer_last_name : Obj.t; mutable year : Obj.t; mutable year_total : float; mutable sale_type : string }
type record7 = { mutable customer_id : Obj.t; mutable customer_first_name : Obj.t; mutable customer_last_name : Obj.t }
type record8 = { mutable customer_id : int; mutable customer_first_name : string; mutable customer_last_name : string }

let customer : record1 list = [{ c_customer_sk = 1; c_customer_id = 1; c_first_name = "Alice"; c_last_name = "Smith" }]
let date_dim : record2 list = [{ d_date_sk = 1; d_year = 1998 };{ d_date_sk = 2; d_year = 1999 }]
let store_sales : record3 list = [{ ss_customer_sk = 1; ss_sold_date_sk = 1; ss_net_paid = 100. };{ ss_customer_sk = 1; ss_sold_date_sk = 2; ss_net_paid = 110. }]
let web_sales : record4 list = [{ ws_bill_customer_sk = 1; ws_sold_date_sk = 1; ws_net_paid = 40. };{ ws_bill_customer_sk = 1; ws_sold_date_sk = 2; ws_net_paid = 80. }]
let year_total : Obj.t list = concat (let (__groups0 : (record5 * record1 list) list ref) = ref [] in
  List.iter (fun (c : record1) ->
      List.iter (fun (ss : record3) ->
            List.iter (fun (d : record2) ->
                        if (c.c_customer_sk = ss.ss_customer_sk) && (d.d_date_sk = ss.ss_sold_date_sk) && ((d.d_year = 1998) || (d.d_year = 1999)) then (
          let (key : record5) = { id = c.c_customer_id; first = c.c_first_name; last = c.c_last_name; year = d.d_year } in
          let cur = try List.assoc key !__groups0 with Not_found -> [] in
          __groups0 := (key, c :: cur) :: List.remove_assoc key !__groups0);
            ) date_dim;
      ) store_sales;
  ) customer;
  let __res0 = ref [] in
  List.iter (fun ((gKey : record5), gItems) ->
    let g = { key = gKey; items = List.rev gItems } in
    __res0 := { customer_id = g.key.id; customer_first_name = g.key.first; customer_last_name = g.key.last; year = g.key.year; year_total = (sum_float (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.ss.ss_net_paid :: !__res1;
  ) g.items;
List.rev !__res1)
); sale_type = "s" } :: !__res0
  ) !__groups0;
  List.rev !__res0)
 (let (__groups2 : (record5 * record1 list) list ref) = ref [] in
  List.iter (fun (c : record1) ->
      List.iter (fun (ws : record4) ->
            List.iter (fun (d : record2) ->
                        if (c.c_customer_sk = ws.ws_bill_customer_sk) && (d.d_date_sk = ws.ws_sold_date_sk) && ((d.d_year = 1998) || (d.d_year = 1999)) then (
          let (key : record5) = { id = c.c_customer_id; first = c.c_first_name; last = c.c_last_name; year = d.d_year } in
          let cur = try List.assoc key !__groups2 with Not_found -> [] in
          __groups2 := (key, c :: cur) :: List.remove_assoc key !__groups2);
            ) date_dim;
      ) web_sales;
  ) customer;
  let __res2 = ref [] in
  List.iter (fun ((gKey : record5), gItems) ->
    let g = { key = gKey; items = List.rev gItems } in
    __res2 := { customer_id = g.key.id; customer_first_name = g.key.first; customer_last_name = g.key.last; year = g.key.year; year_total = (sum_float (let __res3 = ref [] in
  List.iter (fun x ->
      __res3 := x.ws.ws_net_paid :: !__res3;
  ) g.items;
List.rev !__res3)
); sale_type = "w" } :: !__res2
  ) !__groups2;
  List.rev !__res2)

let s_firstyear = first (let __res4 = ref [] in
  List.iter (fun y ->
      if ((y.sale_type = "s") && (y.year = 1998)) then
    __res4 := y :: !__res4;
  ) year_total;
List.rev !__res4)

let s_secyear = first (let __res5 = ref [] in
  List.iter (fun y ->
      if ((y.sale_type = "s") && (y.year = 1999)) then
    __res5 := y :: !__res5;
  ) year_total;
List.rev !__res5)

let w_firstyear = first (let __res6 = ref [] in
  List.iter (fun y ->
      if ((y.sale_type = "w") && (y.year = 1998)) then
    __res6 := y :: !__res6;
  ) year_total;
List.rev !__res6)

let w_secyear = first (let __res7 = ref [] in
  List.iter (fun y ->
      if ((y.sale_type = "w") && (y.year = 1999)) then
    __res7 := y :: !__res7;
  ) year_total;
List.rev !__res7)

let result = (if (((s_firstyear.year_total > 0) && (w_firstyear.year_total > 0)) && (((w_secyear.year_total / w_firstyear.year_total)) > ((s_secyear.year_total / s_firstyear.year_total)))) then [{ customer_id = s_secyear.customer_id; customer_first_name = s_secyear.customer_first_name; customer_last_name = s_secyear.customer_last_name }] else [])

let () =
  json result;
  assert ((result = [{ customer_id = 1; customer_first_name = "Alice"; customer_last_name = "Smith" }]))
