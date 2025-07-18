(* Generated by Mochi compiler v0.10.25 on 2025-07-15T04:50:17Z *)
type ('k,'v) group = { key : 'k; items : 'v list }

type record1 = { mutable cust : int; mutable state : string; mutable amt : float }
type record2 = { mutable state : Obj.t; mutable avg_amt : float }
type record3 = { mutable state : string; mutable avg_amt : float }

let catalog_returns : record1 list = [{ cust = 1; state = "CA"; amt = 40. };{ cust = 2; state = "CA"; amt = 50. };{ cust = 3; state = "CA"; amt = 81. };{ cust = 4; state = "TX"; amt = 30. };{ cust = 5; state = "TX"; amt = 20. }]
let avg_list : record3 list = (let (__groups0 : (string * record1 list) list ref) = ref [] in
  List.iter (fun (r : record1) ->
      let (key : string) = r.state in
      let cur = try List.assoc key !__groups0 with Not_found -> [] in
      __groups0 := (key, r :: cur) :: List.remove_assoc key !__groups0;
  ) catalog_returns;
  let __res0 = ref [] in
  List.iter (fun ((gKey : string), gItems) ->
    let g = { key = gKey; items = List.rev gItems } in
    __res0 := { state = g.key; avg_amt = (List.fold_left (+.) 0.0 (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.amt :: !__res1;
  ) g.items;
List.rev !__res1)
 /. float_of_int (List.length (let __res1 = ref [] in
  List.iter (fun x ->
      __res1 := x.amt :: !__res1;
  ) g.items;
List.rev !__res1)
)) } :: !__res0
  ) !__groups0;
  List.rev !__res0)

let avg_state : (string * Obj.t) list = first (let __res2 = ref [] in
  List.iter (fun (a : record3) ->
      if (a.state = "CA") then
    __res2 := a :: !__res2;
  ) avg_list;
List.rev !__res2)

let result_list : Obj.t list = (let __res3 = ref [] in
  List.iter (fun (r : record1) ->
      if (((r.state = "CA") && (r.amt > avg_state.avg_amt)) *. 1.2) then
    __res3 := r.amt :: !__res3;
  ) catalog_returns;
List.rev !__res3)

let result = first result_list

let () =
  json result;
  assert ((result = 81.))
