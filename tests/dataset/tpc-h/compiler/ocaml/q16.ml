(* Generated by Mochi compiler v0.10.28 on 2025-07-18T03:21:55Z *)
let string_contains s sub =
  let len_s = String.length s and len_sub = String.length sub in
  let rec aux i =
    if i + len_sub > len_s then false
    else if String.sub s i len_sub = sub then true
    else aux (i + 1)
  in aux 0

let rec __to_json v =
  let open Obj in
  let rec list_aux o =
    if is_int o && (magic (obj o) : int) = 0 then "" else
     let hd = field o 0 in
     let tl = field o 1 in
     let rest = list_aux tl in
     let cur = __to_json (obj hd) in
     if rest = "" then cur else cur ^ "," ^ rest
  in
  let r = repr v in
  if is_int r then string_of_int (magic v) else
  match tag r with
    | 0 -> if size r = 0 then "[]" else "[" ^ list_aux r ^ "]"
    | 252 -> Printf.sprintf "%S" (magic v : string)
    | 253 -> string_of_float (magic v)
    | _ -> "null"

let _json v = print_endline (__to_json v)


type record1 = { mutable s_suppkey : int; mutable s_name : string; mutable s_address : string; mutable s_comment : string }
type record2 = { mutable p_partkey : int; mutable p_brand : string; mutable p_type : string; mutable p_size : int }
type record3 = { mutable ps_partkey : int; mutable ps_suppkey : int }
type record4 = { mutable s_name : string; mutable s_address : string }

let supplier : record1 list = [{ s_suppkey = 100; s_name = "AlphaSupply"; s_address = "123 Hilltop"; s_comment = "Reliable and efficient" };{ s_suppkey = 200; s_name = "BetaSupply"; s_address = "456 Riverside"; s_comment = "Known for Customer Complaints" }]
let part : record2 list = [{ p_partkey = 1; p_brand = "Brand#12"; p_type = "SMALL ANODIZED"; p_size = 5 };{ p_partkey = 2; p_brand = "Brand#23"; p_type = "MEDIUM POLISHED"; p_size = 10 }]
let partsupp : record3 list = [{ ps_partkey = 1; ps_suppkey = 100 };{ ps_partkey = 2; ps_suppkey = 200 }]
let excluded_suppliers : int list = (let __res0 = ref [] in
  List.iter (fun (ps : record3) ->
    List.iter (fun (p : record2) ->
      if (p.p_partkey = ps.ps_partkey) then (
        if (((p.p_brand = "Brand#12") && string_contains p.p_type "SMALL") && (p.p_size = 5)) then __res0 := ps.ps_suppkey :: !__res0;
      )
    ) part;
  ) partsupp;
  List.rev !__res0)

let result : record4 list = (let __res1 = ref [] in
  List.iter (fun (s : record1) ->
      if ((not (((List.mem s.s_suppkey excluded_suppliers))) && (not (string_contains s.s_comment "Customer"))) && (not (string_contains s.s_comment "Complaints"))) then
    __res1 := { s_name = s.s_name; s_address = s.s_address } :: !__res1;
  ) supplier;
List.rev !__res1)


let () =
  _json result;
  assert ((result = []))
