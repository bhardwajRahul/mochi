(* Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:48:05 GMT+7 *)

let rec boom () =
  print_endline ("boom");
  true

let () =
  print_endline (string_of_bool (if (((1 < 2) && (2 < 3)) && (3 < 4)) then true else false));
  print_endline (string_of_bool (if (((1 < 2) && (2 > 3)) && boom ()) then true else false));
  print_endline (string_of_bool (if ((((1 < 2) && (2 < 3)) && (3 > 4)) && boom ()) then true else false));
