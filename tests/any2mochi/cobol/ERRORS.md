# Errors

- append_builtin: type2 error: error[T001]: assignment to undeclared variable: a
  --> :2:3

help:
  Declare `a` first using `let`.
- avg_builtin: parse2 error: parse error: 11:11: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- basic_compare: parse2 error: parse error: 5:16: unexpected token "=" (expected "}")
- binary_precedence: output mismatch
- bool_chain: type2 error: error[T020]: operator `*` cannot be used on types bool and bool
  --> :2:22

help:
  Choose an operator that supports these operand types.
- break_continue: parse2 error: parse error: 14:17: unexpected token "MOD" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- cast_string_to_int: output mismatch
- cast_struct: type2 error: error[T002]: undefined variable: TODO_TITLE
  --> :3:9

help:
  Check if the variable was declared in this scope.
- closure: type2 error: error[T003]: unknown function: fmakeadder
  --> :3:3

help:
  Ensure the function is defined before it's called.
- count_builtin: output mismatch
- cross_join: convert error: unsupported feature at line 42:  unsupported for-in loop
  41 |     DISPLAY "--- Cross Join: All order-customer pairs ---"
  42 |     *> unsupported for-in loop
  43 |     STOP RUN.
- cross_join_filter: convert error: unsupported feature at line 43:  unsupported for-in loop
  42 |     DISPLAY "--- Even pairs ---"
  43 |     *> unsupported for-in loop
  44 |     STOP RUN.
- cross_join_triple: convert error: unsupported feature at line 49:  unsupported for-in loop
  48 |     DISPLAY "--- Cross Join of three lists ---"
  49 |     *> unsupported for-in loop
  50 |     STOP RUN.
- dataset_sort_take_limit: convert error: unsupported feature at line 36:  unsupported for-in loop
  35 |     DISPLAY "--- Top products (excluding most expensive) ---"
  36 |     *> unsupported for-in loop
  37 |     STOP RUN.
- dataset_where_filter: convert error: unsupported feature at line 35:  unsupported for-in loop
  34 |     DISPLAY "--- Adults ---"
  35 |     *> unsupported for-in loop
  36 |     STOP RUN.
- exists_builtin: type2 error: error[T001]: assignment to undeclared variable: data
  --> :2:3

help:
  Declare `data` first using `let`.
- for_list_collection: type2 error: error[T001]: assignment to undeclared variable: tmp0
  --> :2:3

help:
  Declare `tmp0` first using `let`.
- for_loop: output mismatch
- for_map_collection: convert error: unsupported feature at line 11:  unsupported for-in loop
  10 |     COMPUTE M = 0
  11 |     *> unsupported for-in loop
  12 |     STOP RUN.
- fun_call: output mismatch
- fun_expr_in_let: type2 error: error[T003]: unknown function: flambda0
  --> :3:3

help:
  Ensure the function is defined before it's called.
- fun_three_args: type2 error: error[T003]: unknown function: fsum3
  --> :5:3

help:
  Ensure the function is defined before it's called.
- group_by: convert error: unsupported feature at line 35:  unsupported for-in loop
  34 |     DISPLAY "--- People grouped by city ---"
  35 |     *> unsupported for-in loop
  36 |     STOP RUN.
- group_by_conditional_sum: parse2 error: parse error: 12:12: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- group_by_having: parse2 error: parse error: 16:12: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- group_by_join: convert error: unsupported feature at line 43:  unsupported for-in loop
  42 |     DISPLAY "--- Orders per customer ---"
  43 |     *> unsupported for-in loop
  44 |     STOP RUN.
- group_by_left_join: convert error: unsupported feature at line 44:  unsupported for-in loop
  43 |     DISPLAY "--- Group Left Join ---"
  44 |     *> unsupported for-in loop
  45 |     STOP RUN.
- group_by_multi_join: parse2 error: parse error: 20:19: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- group_by_multi_join_sort: parse2 error: parse error: 24:86: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- group_by_sort: parse2 error: parse error: 13:12: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- group_items_iteration: convert error: unsupported feature at line 36:  unsupported for-in loop
  35 |     END-PERFORM
  36 |     *> unsupported for-in loop
  37 |     MOVE 0 TO TMP2
- if_else: output mismatch
- if_then_else: type2 error: error[T002]: undefined variable: tmp0
  --> :8:13

help:
  Check if the variable was declared in this scope.
- if_then_else_nested: type2 error: error[T002]: undefined variable: tmp0
  --> :13:13

help:
  Check if the variable was declared in this scope.
- in_operator: type2 error: error[T001]: assignment to undeclared variable: xs
  --> :2:3

help:
  Declare `xs` first using `let`.
- in_operator_extended: parse2 error: parse error: 10:17: unexpected token "MOD" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- inner_join: convert error: unsupported feature at line 45:  unsupported for-in loop
  44 |     DISPLAY "--- Orders with customer info ---"
  45 |     *> unsupported for-in loop
  46 |     STOP RUN.
- join_multi: convert error: unsupported feature at line 51:  unsupported for-in loop
  50 |     DISPLAY "--- Multi Join ---"
  51 |     *> unsupported for-in loop
  52 |     STOP RUN.
- json_builtin: output mismatch
- left_join: convert error: unsupported feature at line 42:  unsupported for-in loop
  41 |     DISPLAY "--- Left Join ---"
  42 |     *> unsupported for-in loop
  43 |     STOP RUN.
- left_join_multi: convert error: unsupported feature at line 50:  unsupported for-in loop
  49 |     DISPLAY "--- Left Join Multi ---"
  50 |     *> unsupported for-in loop
  51 |     STOP RUN.
- len_builtin: output mismatch
- len_map: type2 error: error[T002]: undefined variable: FUNCTION
  --> :2:14

help:
  Check if the variable was declared in this scope.
- len_string: type2 error: error[T002]: undefined variable: FUNCTION
  --> :2:14

help:
  Check if the variable was declared in this scope.
- let_and_print: type2 error: error[T002]: undefined variable: b
  --> :3:18

help:
  Check if the variable was declared in this scope.
- list_assign: compile panic: interface conversion: interface {} is nil, not string
- list_index: type2 error: error[T001]: assignment to undeclared variable: xs
  --> :2:3

help:
  Declare `xs` first using `let`.
- list_nested_assign: compile panic: interface conversion: interface {} is nil, not string
- list_set_ops: parse2 error: parse error: 8:32: unexpected token "union_all" (expected ")")
- load_yaml: convert error: unsupported feature at line 31:  unsupported for-in loop
  30 |     END-PERFORM
  31 |     *> unsupported for-in loop
  32 |     STOP RUN.
- map_assign: compile panic: interface conversion: interface {} is nil, not string
- map_in_operator: type2 error: error[T020]: operator `in` cannot be used on types int and int
  --> :3:16

help:
  Choose an operator that supports these operand types.
- map_index: type2 error: error[T018]: type int does not support indexing
  --> :3:14

help:
  Only `list<T>` and `map<K,V>` can be indexed.
- map_int_key: type2 error: error[T018]: type int does not support indexing
  --> :3:14

help:
  Only `list<T>` and `map<K,V>` can be indexed.
- map_literal_dynamic: output mismatch
- map_membership: type2 error: error[T020]: operator `in` cannot be used on types string and int
  --> :3:18

help:
  Choose an operator that supports these operand types.
- map_nested_assign: compile panic: interface conversion: interface {} is nil, not string
- match_expr: parse2 error: parse error: 4:11: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- match_full: parse2 error: parse error: 4:11: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- math_ops: type2 error: error[T002]: undefined variable: FUNCTION
  --> :6:14

help:
  Check if the variable was declared in this scope.
- membership: type2 error: error[T001]: assignment to undeclared variable: nums
  --> :2:3

help:
  Declare `nums` first using `let`.
- min_max_builtin: type2 error: error[T001]: assignment to undeclared variable: nums
  --> :2:3

help:
  Declare `nums` first using `let`.
- nested_function: type2 error: error[T003]: unknown function: fouter
  --> :3:3

help:
  Ensure the function is defined before it's called.
- order_by_map: parse2 error: parse error: 12:12: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- outer_join: convert error: unsupported feature at line 46:  unsupported for-in loop
  45 |     DISPLAY "--- Outer Join using syntax ---"
  46 |     *> unsupported for-in loop
  47 |     STOP RUN.
- partial_application: type2 error: error[T001]: assignment to undeclared variable: add_p0
  --> :2:3

help:
  Declare `add_p0` first using `let`.
- print_hello: output mismatch
- pure_fold: type2 error: error[T003]: unknown function: ftriple
  --> :4:3

help:
  Ensure the function is defined before it's called.
- pure_global_fold: type2 error: error[T003]: unknown function: finc
  --> :4:3

help:
  Ensure the function is defined before it's called.
- query_sum_select: convert error: unsupported feature at line 25:  unsupported reduce
  24 |     IF N > 1
  25 |             *> unsupported reduce
  26 |             COMPUTE TMP2 = 0
- record_assign: type2 error: error[T002]: undefined variable: C
  --> :3:16

help:
  Check if the variable was declared in this scope.
- right_join: convert error: unsupported feature at line 45:  unsupported for-in loop
  44 |     DISPLAY "--- Right Join using syntax ---"
  45 |     *> unsupported for-in loop
  46 |     STOP RUN.
- save_jsonl_stdout: type2 error: error[T001]: assignment to undeclared variable: people
  --> :2:3

help:
  Declare `people` first using `let`.
- short_circuit: type2 error: error[T003]: unknown function: fboom
  --> :4:3

help:
  Ensure the function is defined before it's called.
- slice: parse2 error: parse error: 12:26: unexpected token ":" (expected ")")
- sort_stable: parse2 error: parse error: 12:12: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- str_builtin: output mismatch
- string_compare: output mismatch
- string_concat: parse2 error: parse error: 2:23: lexer: invalid input text "& \"world\"\n  prin..."
- string_contains: output mismatch
- string_in_operator: output mismatch
- string_index: output mismatch
- string_prefix_slice: parse2 error: parse error: 8:19: unexpected token "=" (expected "}")
- substring_builtin: output mismatch
- sum_builtin: type2 error: error[T001]: assignment to undeclared variable: tmp0
  --> :2:3

help:
  Declare `tmp0` first using `let`.
- tail_recursion: type2 error: error[T003]: unknown function: fsum_rec
  --> :4:3

help:
  Ensure the function is defined before it's called.
- test_block: parse2 error: parse error: 4:13: unexpected token "=" (expected ")")
- tree_sum: type2 error: error[T002]: undefined variable: LEAF
  --> :2:16

help:
  Check if the variable was declared in this scope.
- two-sum: parse2 error: parse error: 14:36: unexpected token "=" (expected "{" Statement* "}" (("else" IfStmt) | ("else" "{" Statement* "}"))?)
- typed_let: output mismatch
- typed_var: output mismatch
- unary_neg: parse2 error: parse error: 3:18: unexpected token "-" (expected PostfixExpr)
- update_stmt: convert error: unsupported feature at line 10:  unsupported update statement
   9 | PROCEDURE DIVISION.
  10 |     *> unsupported update statement
  11 | DISPLAY "-- TEST update adult status --"
- user_type_literal: output mismatch
- values_builtin: output mismatch
- var_assignment: output mismatch
- while_loop: output mismatch
