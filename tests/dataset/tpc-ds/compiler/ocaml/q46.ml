(* Generated by Mochi compiler v0.10.25 on 2025-07-15T04:50:17Z *)
let sum lst = List.fold_left (+) 0 lst
let sum_float lst = List.fold_left (+.) 0.0 lst
type ('k,'v) group = { key : 'k; items : 'v list }

type record1 = { mutable ss_ticket_number : int; mutable ss_customer_sk : int; mutable ss_addr_sk : int; mutable ss_hdemo_sk : int; mutable ss_store_sk : int; mutable ss_sold_date_sk : int; mutable ss_coupon_amt : float; mutable ss_net_profit : float }
type record2 = { mutable d_date_sk : int; mutable d_dow : int; mutable d_year : int }
type record3 = { mutable s_store_sk : int; mutable s_city : string }
type record4 = { mutable hd_demo_sk : int; mutable hd_dep_count : int; mutable hd_vehicle_count : int }
type record5 = { mutable ca_address_sk : int; mutable ca_city : string }
type record6 = { mutable c_customer_sk : int; mutable c_last_name : string; mutable c_first_name : string; mutable c_current_addr_sk : int }
type record7 = { mutable ss_ticket_number : int; mutable ss_customer_sk : int; mutable ca_city : string }
type record8 = { mutable ss_ticket_number : Obj.t; mutable ss_customer_sk : Obj.t; mutable bought_city : Obj.t; mutable amt : float; mutable profit : float }
type record9 = { mutable ss_ticket_number : int; mutable ss_customer_sk : int; mutable bought_city : string; mutable amt : float; mutable profit : float }
type record10 = { mutable c_last_name : string; mutable c_first_name : string; mutable ca_city : string; mutable bought_city : string; mutable ss_ticket_number : int; mutable amt : float; mutable profit : float }

let store_sales : record1 list = [{ ss_ticket_number = 1; ss_customer_sk = 1; ss_addr_sk = 1; ss_hdemo_sk = 1; ss_store_sk = 1; ss_sold_date_sk = 1; ss_coupon_amt = 5.; ss_net_profit = 20. }]
let date_dim : record2 list = [{ d_date_sk = 1; d_dow = 6; d_year = 2020 }]
let store : record3 list = [{ s_store_sk = 1; s_city = "CityA" }]
let household_demographics : record4 list = [{ hd_demo_sk = 1; hd_dep_count = 2; hd_vehicle_count = 0 }]
let customer_address : record5 list = [{ ca_address_sk = 1; ca_city = "Portland" };{ ca_address_sk = 2; ca_city = "Seattle" }]
let customer : record6 list = [{ c_customer_sk = 1; c_last_name = "Doe"; c_first_name = "John"; c_current_addr_sk = 2 }]
let depcnt : int = 2
let vehcnt : int = 0
let year : int = 2020
let cities : string list = ["CityA"]
let dn : record9 list = (let (__groups0 : (record7 * record1 list) list ref) = ref [] in
  List.iter (fun (ss : record1) ->
      List.iter (fun (d : record2) ->
            List.iter (fun (s : record3) ->
                    List.iter (fun (hd : record4) ->
                              List.iter (fun (ca : record5) ->
                                                  if (ss.ss_sold_date_sk = d.d_date_sk) && (ss.ss_store_sk = s.s_store_sk) && (ss.ss_hdemo_sk = hd.hd_demo_sk) && (ss.ss_addr_sk = ca.ca_address_sk) && (List.mem (((List.mem ((((hd.hd_dep_count = depcnt) || (hd.hd_vehicle_count = vehcnt))) && d.d_dow) [6;0]) && (d.d_year = year)) && s.s_city) cities) then (
              let (key : record7) = { ss_ticket_number = ss.ss_ticket_number; ss_customer_sk = ss.ss_customer_sk; ca_city = ca.ca_city } in
              let cur = try List.assoc key !__groups0 with Not_found -> [] in
              __groups0 := (key, ss :: cur) :: List.remove_assoc key !__groups0);
                              ) customer_address;
                    ) household_demographics;
            ) store;
      ) date_dim;
  ) store_sales;
  let __res0 = ref [] in
  List.iter (fun ((gKey : record7), gItems) ->
    let g = { key = gKey; items = List.rev gItems } in
    __res0 := { ss_ticket_number = g.key.ss_ticket_number; ss_customer_sk = g.key.ss_customer_sk; bought_city = g.key.ca_city; amt = (sum_float (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.ss.ss_coupon_amt :: !__res1;
  ) g.items;
List.rev !__res1)
); profit = (sum_float (let __res2 = ref [] in
  List.iter (fun x ->
      __res2 := x.ss.ss_net_profit :: !__res2;
  ) g.items;
List.rev !__res2)
) } :: !__res0
  ) !__groups0;
  List.rev !__res0)

let base : record10 list = (let __res3 = ref [] in
  List.iter (fun (dnrec : record9) ->
      List.iter (fun (c : record6) ->
            List.iter (fun (current_addr : record5) ->
                        if (dnrec.ss_customer_sk = c.c_customer_sk) && (c.c_current_addr_sk = current_addr.ca_address_sk) && (current_addr.ca_city <> dnrec.bought_city) then
        __res3 := { c_last_name = c.c_last_name; c_first_name = c.c_first_name; ca_city = current_addr.ca_city; bought_city = dnrec.bought_city; ss_ticket_number = dnrec.ss_ticket_number; amt = dnrec.amt; profit = dnrec.profit } :: !__res3;
            ) customer_address;
      ) customer;
  ) dn;
List.rev !__res3)

let result : (string * Obj.t) list list = base

let () =
  json result;
  assert ((result = [{ c_last_name = "Doe"; c_first_name = "John"; ca_city = "Seattle"; bought_city = "Portland"; ss_ticket_number = 1; amt = 5.; profit = 20. }]))
