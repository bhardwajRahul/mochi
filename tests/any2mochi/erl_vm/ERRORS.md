# Errors

- append_builtin: type error: error[T001]: assignment to undeclared variable: A
  --> :5:3

help:
  Declare `A` first using `let`.
- avg_builtin: type error: error[T003]: unknown function: mochi_avg
  --> :5:9

help:
  Ensure the function is defined before it's called.
- basic_compare: type error: error[T001]: assignment to undeclared variable: A
  --> :5:3

help:
  Declare `A` first using `let`.
- binary_precedence: ok
- bool_chain: parse error: parse error: 6:24: unexpected token "," (expected "}")
- break_continue: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	Numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9],
  7: 	mochi_foreach(fun(N) ->
  8: 				case ((N % 2) == 0) of
  9: 			true ->
 10: 				throw(mochi_continue);
- cast_string_to_int: ok
- cast_struct: parse error: parse error: 9:26: lexer: invalid input text "#{\"title\" => \"hi..."
- closure: parse error: parse error: 6:16: unexpected token "," (expected PostfixExpr)
- count_builtin: type error: error[T003]: unknown function: mochi_count
  --> :5:9

help:
  Ensure the function is defined before it's called.
- cross_join: parse error: parse error: 6:4: lexer: invalid input text "#{id => 1, name ..."
- cross_join_filter: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	Nums = [1, 2, 3],
  7: 	Letters = ["A", "B"],
  8: 	Pairs = [#{n => N, l => L} || N <- [N || N <- Nums, ((N % 2) == 0)], L <- Letters],
  9: 	mochi_print(["--- Even pairs ---"]),
 10: 	mochi_foreach(fun(P) ->
- cross_join_triple: parse error: parse error: 10:3: lexer: invalid input text "#{n => N, l => L..."
- dataset_sort_take_limit: parse error: parse error: 6:4: lexer: invalid input text "#{name => \"Lapto..."
- dataset_where_filter: compile error: unsupported expression
- exists_builtin: parse error: parse error: 9:6: unexpected token "-" (expected PostfixExpr)
- for_list_collection: parse error: parse error: 5:24: unexpected token "-" (expected "=>" Expr)
- for_loop: parse error: parse error: 5:24: unexpected token "-" (expected "=>" Expr)
- for_map_collection: parse error: parse error: 5:7: lexer: invalid input text "#{\"a\" => 1, \"b\" ..."
- fun_call: parse error: parse error: 6:16: unexpected token "," (expected PostfixExpr)
- fun_expr_in_let: parse error: parse error: 6:10: unexpected token "-" (expected "=>" Expr)
- fun_three_args: parse error: parse error: 6:16: unexpected token "," (expected PostfixExpr)
- group_by: parse error: parse error: 6:4: lexer: invalid input text "#{name => \"Alice..."
- group_by_conditional_sum: compile error: unsupported expression
- group_by_having: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	People = [#{name => "Alice", city => "Paris"}, #{name => "Bob", city => "Hanoi"}, #{name => "Charlie", city => "Paris"}, #{name => "Diana", city => "Hanoi"}, #{name => "Eve", city => "Paris"}, #{name => "Frank", city => "Hanoi"}, #{name => "George", city => "Paris"}],
  7: 	Big = [#{city => maps:get(key, G), num => mochi_count(G)} || G <- mochi_group_by(People, fun(P) -> maps:get(city, P) end)],
  8: 	mochi_json(Big).
  9: 
 10: mochi_count(X) when is_list(X) -> length(X);
- group_by_join: parse error: parse error: 5:16: lexer: invalid input text "#{id => 1, name ..."
- group_by_left_join: parse error: parse error: 6:4: lexer: invalid input text "#{id => 1, name ..."
- group_by_multi_join: parse error: parse error: 5:14: lexer: invalid input text "#{id => 1, name ..."
- group_by_multi_join_sort: parse error: parse error: 5:13: lexer: invalid input text "#{n_nationkey =>..."
- group_by_sort: parse error: parse error: 6:4: lexer: invalid input text "#{cat => \"a\", va..."
- group_items_iteration: parse error: parse error: 6:4: lexer: invalid input text "#{tag => \"a\", va..."
- if_else: parse error: parse error: 8:23: lexer: invalid input text ";\n  _ ->\n  mochi..."
- if_then_else: compile error: unsupported expression
- if_then_else_nested: compile error: unsupported expression
- in_operator: parse error: parse error: 6:14: unexpected token ":" (expected ")")
- in_operator_extended: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	Xs = [1, 2, 3],
  7: 	Ys = [X || X <- [X || X <- Xs, ((X % 2) == 1)]],
  8: 	mochi_print([lists:member(1, Ys)]),
  9: 	mochi_print([lists:member(2, Ys)]),
 10: 	M = #{a => 1},
- inner_join: parse error: parse error: 6:4: lexer: invalid input text "#{id => 1, name ..."
- join_multi: parse error: parse error: 5:16: lexer: invalid input text "#{id => 1, name ..."
- json_builtin: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	M = #{a => 1, b => 2},
  7: 	mochi_json(M).
  8: 
  9: 
 10: mochi_escape_json([]) -> [];
- left_join: parse error: parse error: 5:16: lexer: invalid input text "#{id => 1, name ..."
- left_join_multi: compile error: unsupported join side
- len_builtin: type error: error[T003]: unknown function: length
  --> :5:9

help:
  Ensure the function is defined before it's called.
- len_map: parse error: parse error: 5:16: lexer: invalid input text "#{\"a\" => 1, \"b\" ..."
- len_string: type error: error[T003]: unknown function: length
  --> :5:9

help:
  Ensure the function is defined before it's called.
- let_and_print: type error: error[T001]: assignment to undeclared variable: A
  --> :5:3

help:
  Declare `A` first using `let`.
- list_assign: type error: error[T001]: assignment to undeclared variable: Nums
  --> :5:3

help:
  Declare `Nums` first using `let`.
- list_index: type error: error[T001]: assignment to undeclared variable: Xs
  --> :5:3

help:
  Declare `Xs` first using `let`.
- list_nested_assign: type error: error[T001]: assignment to undeclared variable: Matrix
  --> :5:3

help:
  Declare `Matrix` first using `let`.
- list_set_ops: parse error: parse error: 8:21: unexpected token ":" (expected ")")
- load_yaml: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: -record(person, {name, age, email}).
  6: 
  7: main(_) ->
  8: 	People = mochi_load("../interpreter/valid/people.yaml", #{format => "yaml"}),
  9: 	Adults = [#{name => P#person.name, email => P#person.email} || P <- [P || P <- People, (P#person.age >= 18)]],
 10: 	mochi_foreach(fun(A) ->
- map_assign: parse error: parse error: 5:12: lexer: invalid input text "#{\"alice\" => 1}\n..."
- map_in_operator: parse error: parse error: 5:7: lexer: invalid input text "#{1 => \"a\", 2 =>..."
- map_index: parse error: parse error: 5:7: lexer: invalid input text "#{\"a\" => 1, \"b\" ..."
- map_int_key: parse error: parse error: 5:7: lexer: invalid input text "#{1 => \"a\", 2 =>..."
- map_literal_dynamic: parse error: parse error: 7:7: lexer: invalid input text "#{\"a\" => X, \"b\" ..."
- map_membership: parse error: parse error: 5:7: lexer: invalid input text "#{\"a\" => 1, \"b\" ..."
- map_nested_assign: parse error: parse error: 5:10: lexer: invalid input text "#{\"outer\" => #{\"..."
- match_expr: parse error: parse error: 11:8: lexer: invalid input text ";\n  2 ->\n  \"two\"..."
- match_full: parse error: parse error: 11:9: lexer: invalid input text ";\n  1 ->\n  \"one\"..."
- math_ops: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	mochi_print([(6 * 7)]),
  7: 	mochi_print([(7 / 2)]),
  8: 	mochi_print([(7 % 2)]).
  9: 
 10: mochi_print(Args) ->
- membership: parse error: parse error: 6:14: unexpected token ":" (expected ")")
- min_max_builtin: type error: error[T001]: assignment to undeclared variable: Nums
  --> :5:3

help:
  Declare `Nums` first using `let`.
- nested_function: parse error: parse error: 6:5: unexpected token "," (expected "}")
- order_by_map: parse error: parse error: 5:11: lexer: invalid input text "#{a => 1, b => 2..."
- outer_join: parse error: parse error: 6:4: lexer: invalid input text "#{id => 1, name ..."
- partial_application: parse error: parse error: 6:16: unexpected token "," (expected PostfixExpr)
- print_hello: ok
- pure_fold: parse error: parse error: 6:16: unexpected token "," (expected PostfixExpr)
- pure_global_fold: parse error: parse error: 6:16: unexpected token "," (expected PostfixExpr)
- query_sum_select: parse error: parse error: 9:6: unexpected token "-" (expected PostfixExpr)
- record_assign: parse error: parse error: 12:8: unexpected token ":" (expected "}")
- right_join: parse error: parse error: 6:4: lexer: invalid input text "#{id => 1, name ..."
- save_jsonl_stdout: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	People = [#{name => "Alice", age => 30}, #{name => "Bob", age => 25}],
  7: 	mochi_save(People, "-", #{format => "jsonl"}).
  8: 
  9: 
 10: mochi_load(Path, Opts) ->
- short_circuit: parse error: parse error: 6:24: unexpected token "," (expected "}")
- slice: type error: error[T003]: unknown function: mochi_slice
  --> :5:9

help:
  Ensure the function is defined before it's called.
- sort_stable: parse error: parse error: 5:12: lexer: invalid input text "#{n => 1, v => \"..."
- str_builtin: type error: error[T003]: unknown function: mochi_format
  --> :5:9

help:
  Ensure the function is defined before it's called.
- string_compare: parse error: parse error: 6:13: unexpected token "=" (expected ")")
- string_concat: ok
- string_contains: parse error: parse error: 6:15: unexpected token ":" (expected ")")
- string_in_operator: parse error: parse error: 6:15: unexpected token ":" (expected ")")
- string_index: type error: error[T001]: assignment to undeclared variable: S
  --> :5:3

help:
  Declare `S` first using `let`.
- string_prefix_slice: type error: error[T001]: assignment to undeclared variable: Prefix
  --> :5:3

help:
  Declare `Prefix` first using `let`.
- substring_builtin: ok
- sum_builtin: type error: error[T003]: unknown function: mochi_sum
  --> :5:9

help:
  Ensure the function is defined before it's called.
- tail_recursion: parse error: parse error: 8:23: lexer: invalid input text ";\n  _ ->\n  ok\n  ..."
- test_block: parse error: parse error: 7:9: unexpected token "-" (expected "=>" Expr)
- tree_sum: parse error: parse error: 20:4: lexer: invalid input text ";\n  Node {left :..."
- two-sum: parse error: parse error: 18:11: lexer: invalid input text ";\n  _ ->\n  ok\n  ..."
- typed_let: type error: error[T002]: undefined variable: undefined
  --> :5:7

help:
  Check if the variable was declared in this scope.
- typed_var: type error: error[T002]: undefined variable: undefined
  --> :5:7

help:
  Check if the variable was declared in this scope.
- unary_neg: parse error: parse error: 6:13: unexpected token "-" (expected PostfixExpr)
- update_stmt: parse error: parse error: 20:52: lexer: invalid input text ";\n  _ ->\n  Item\n..."
- user_type_literal: parse error: parse error: 16:13: unexpected token ":" (expected ")")
- values_builtin: parse error: parse error: 5:7: lexer: invalid input text "#{\"a\" => 1, \"b\" ..."
- var_assignment: type error: error[T001]: assignment to undeclared variable: X
  --> :5:3

help:
  Declare `X` first using `let`.
- while_loop: exit status 1
  1: #!/usr/bin/env escript
  2: -module(main).
  3: -export([main/1]).
  4: 
  5: main(_) ->
  6: 	I = 0,
  7: 	Loop = fun Loop(I) ->
  8: 		case (I < 3) of
  9: 			true ->
 10: 				try
