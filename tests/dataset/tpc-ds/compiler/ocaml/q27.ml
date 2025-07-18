(* Generated by Mochi compiler v0.10.25 on 2025-07-15T04:50:16Z *)
type ('k,'v) group = { key : 'k; items : 'v list }

type record1 = { mutable ss_item_sk : int; mutable ss_store_sk : int; mutable ss_cdemo_sk : int; mutable ss_sold_date_sk : int; mutable ss_quantity : int; mutable ss_list_price : float; mutable ss_coupon_amt : float; mutable ss_sales_price : float }
type record2 = { mutable cd_demo_sk : int; mutable cd_gender : string; mutable cd_marital_status : string; mutable cd_education_status : string }
type record3 = { mutable d_date_sk : int; mutable d_year : int }
type record4 = { mutable s_store_sk : int; mutable s_state : string }
type record5 = { mutable i_item_sk : int; mutable i_item_id : string }
type record6 = { mutable item_id : string; mutable state : string }
type record7 = { mutable i_item_id : Obj.t; mutable s_state : Obj.t; mutable agg1 : float; mutable agg2 : float; mutable agg3 : float; mutable agg4 : float }
type record8 = { mutable i_item_id : string; mutable s_state : string; mutable agg1 : float; mutable agg2 : float; mutable agg3 : float; mutable agg4 : float }

type storesale = { mutable ss_item_sk : int; mutable ss_store_sk : int; mutable ss_cdemo_sk : int; mutable ss_sold_date_sk : int; mutable ss_quantity : int; mutable ss_list_price : float; mutable ss_coupon_amt : float; mutable ss_sales_price : float }
type customerdemo = { mutable cd_demo_sk : int; mutable cd_gender : string; mutable cd_marital_status : string; mutable cd_education_status : string }
type datedim = { mutable d_date_sk : int; mutable d_year : int }
type store = { mutable s_store_sk : int; mutable s_state : string }
type item = { mutable i_item_sk : int; mutable i_item_id : string }
let store_sales : record1 list = [{ ss_item_sk = 1; ss_store_sk = 1; ss_cdemo_sk = 1; ss_sold_date_sk = 1; ss_quantity = 5; ss_list_price = 100.; ss_coupon_amt = 10.; ss_sales_price = 90. };{ ss_item_sk = 2; ss_store_sk = 2; ss_cdemo_sk = 2; ss_sold_date_sk = 1; ss_quantity = 2; ss_list_price = 50.; ss_coupon_amt = 5.; ss_sales_price = 45. }]
let customer_demographics : record2 list = [{ cd_demo_sk = 1; cd_gender = "F"; cd_marital_status = "M"; cd_education_status = "College" };{ cd_demo_sk = 2; cd_gender = "M"; cd_marital_status = "S"; cd_education_status = "College" }]
let date_dim : record3 list = [{ d_date_sk = 1; d_year = 2000 }]
let store : record4 list = [{ s_store_sk = 1; s_state = "CA" };{ s_store_sk = 2; s_state = "TX" }]
let item : record5 list = [{ i_item_sk = 1; i_item_id = "ITEM1" };{ i_item_sk = 2; i_item_id = "ITEM2" }]
let result : record8 list = (let (__groups0 : (record6 * record1 list) list ref) = ref [] in
  List.iter (fun (ss : record1) ->
      List.iter (fun (cd : record2) ->
            List.iter (fun (d : record3) ->
                    List.iter (fun (s : record4) ->
                              List.iter (fun (i : record5) ->
                                                  if (ss.ss_cdemo_sk = cd.cd_demo_sk) && (ss.ss_sold_date_sk = d.d_date_sk) && (ss.ss_store_sk = s.s_store_sk) && (ss.ss_item_sk = i.i_item_sk) && (List.mem (((((cd.cd_gender = "F") && (cd.cd_marital_status = "M")) && (cd.cd_education_status = "College")) && (d.d_year = 2000)) && s.s_state) ["CA"]) then (
              let (key : record6) = { item_id = i.i_item_id; state = s.s_state } in
              let cur = try List.assoc key !__groups0 with Not_found -> [] in
              __groups0 := (key, ss :: cur) :: List.remove_assoc key !__groups0);
                              ) item;
                    ) store;
            ) date_dim;
      ) customer_demographics;
  ) store_sales;
  let __res0 = ref [] in
  List.iter (fun ((gKey : record6), gItems) ->
    let g = { key = gKey; items = List.rev gItems } in
    __res0 := { i_item_id = g.key.item_id; s_state = g.key.state; agg1 = (float_of_int (List.fold_left (+) 0 (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.ss_quantity :: !__res1;
  ) g.items;
List.rev !__res1)
) /. float_of_int (List.length (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.ss_quantity :: !__res1;
  ) g.items;
List.rev !__res1)
)); agg2 = (List.fold_left (+.) 0.0 (let __res2 = ref [] in
  List.iter (fun x ->
      __res2 := x.ss_list_price :: !__res2;
  ) g.items;
List.rev !__res2)
 /. float_of_int (List.length (let __res2 = ref [] in
  List.iter (fun x ->
      __res2 := x.ss_list_price :: !__res2;
  ) g.items;
List.rev !__res2)
)); agg3 = (List.fold_left (+.) 0.0 (let __res3 = ref [] in
  List.iter (fun x ->
      __res3 := x.ss_coupon_amt :: !__res3;
  ) g.items;
List.rev !__res3)
 /. float_of_int (List.length (let __res3 = ref [] in
  List.iter (fun x ->
      __res3 := x.ss_coupon_amt :: !__res3;
  ) g.items;
List.rev !__res3)
)); agg4 = (List.fold_left (+.) 0.0 (let __res4 = ref [] in
  List.iter (fun x ->
      __res4 := x.ss_sales_price :: !__res4;
  ) g.items;
List.rev !__res4)
 /. float_of_int (List.length (let __res4 = ref [] in
  List.iter (fun x ->
      __res4 := x.ss_sales_price :: !__res4;
  ) g.items;
List.rev !__res4)
)) } :: !__res0
  ) !__groups0;
  List.rev !__res0)


let () =
  json result;
  assert ((result = [{ i_item_id = "ITEM1"; s_state = "CA"; agg1 = 5.; agg2 = 100.; agg3 = 10.; agg4 = 90. }]))
