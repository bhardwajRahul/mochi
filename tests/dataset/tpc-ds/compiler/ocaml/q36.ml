(* Generated by Mochi compiler v0.10.25 on 2025-07-15T04:50:16Z *)
let sum lst = List.fold_left (+) 0 lst
let sum_float lst = List.fold_left (+.) 0.0 lst
type ('k,'v) group = { key : 'k; items : 'v list }

type record1 = { mutable ss_item_sk : int; mutable ss_store_sk : int; mutable ss_sold_date_sk : int; mutable ss_ext_sales_price : float; mutable ss_net_profit : float }
type record2 = { mutable i_item_sk : int; mutable i_category : string; mutable i_class : string }
type record3 = { mutable s_store_sk : int; mutable s_state : string }
type record4 = { mutable d_date_sk : int; mutable d_year : int }
type record5 = { mutable category : string; mutable class : string }
type record6 = { mutable i_category : Obj.t; mutable i_class : Obj.t; mutable gross_margin : float }
type record7 = { mutable i_category : string; mutable i_class : string; mutable gross_margin : float }

let store_sales : record1 list = [{ ss_item_sk = 1; ss_store_sk = 1; ss_sold_date_sk = 1; ss_ext_sales_price = 100.; ss_net_profit = 20. };{ ss_item_sk = 2; ss_store_sk = 1; ss_sold_date_sk = 1; ss_ext_sales_price = 200.; ss_net_profit = 50. };{ ss_item_sk = 3; ss_store_sk = 2; ss_sold_date_sk = 1; ss_ext_sales_price = 150.; ss_net_profit = 30. }]
let item : record2 list = [{ i_item_sk = 1; i_category = "Books"; i_class = "C1" };{ i_item_sk = 2; i_category = "Books"; i_class = "C2" };{ i_item_sk = 3; i_category = "Electronics"; i_class = "C3" }]
let store : record3 list = [{ s_store_sk = 1; s_state = "A" };{ s_store_sk = 2; s_state = "B" }]
let date_dim : record4 list = [{ d_date_sk = 1; d_year = 2000 }]
let result : record7 list = (let (__groups0 : (record5 * record1 list) list ref) = ref [] in
  List.iter (fun (ss : record1) ->
      List.iter (fun (d : record4) ->
            List.iter (fun (i : record2) ->
                    List.iter (fun (s : record3) ->
                                    if (ss.ss_sold_date_sk = d.d_date_sk) && (ss.ss_item_sk = i.i_item_sk) && (ss.ss_store_sk = s.s_store_sk) && ((d.d_year = 2000) && (((s.s_state = "A") || (s.s_state = "B")))) then (
            let (key : record5) = { category = i.i_category; class = i.i_class } in
            let cur = try List.assoc key !__groups0 with Not_found -> [] in
            __groups0 := (key, ss :: cur) :: List.remove_assoc key !__groups0);
                    ) store;
            ) item;
      ) date_dim;
  ) store_sales;
  let __res0 = ref [] in
  List.iter (fun ((gKey : record5), gItems) ->
    let g = { key = gKey; items = List.rev gItems } in
    __res0 := { i_category = g.key.category; i_class = g.key.class; gross_margin = ((sum_float (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.ss_net_profit :: !__res1;
  ) g.items;
List.rev !__res1)
) /. (sum_float (let __res2 = ref [] in
  List.iter (fun x ->
      __res2 := x.ss_ext_sales_price :: !__res2;
  ) g.items;
List.rev !__res2)
)) } :: !__res0
  ) !__groups0;
  List.rev !__res0)


let () =
  json result;
  assert ((result = [{ i_category = "Books"; i_class = "C1"; gross_margin = 0.2 };{ i_category = "Books"; i_class = "C2"; gross_margin = 0.25 };{ i_category = "Electronics"; i_class = "C3"; gross_margin = 0.2 }]))
