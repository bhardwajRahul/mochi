#!/usr/bin/env escript
%% Generated by Mochi compiler v0.10.27 on 2020-01-02T15:04:05Z
% q8.erl - generated from q8.mochi

main(_) ->
    Region = [#{r_regionkey => 0, r_name => "AMERICA"}],
    Nation = [#{n_nationkey => 10, n_regionkey => 0, n_name => "BRAZIL"}, #{n_nationkey => 20, n_regionkey => 0, n_name => "CANADA"}],
    Customer = [#{c_custkey => 1, c_nationkey => 10}, #{c_custkey => 2, c_nationkey => 20}],
    Orders = [#{o_orderkey => 100, o_custkey => 1, o_orderdate => "1995-04-10"}, #{o_orderkey => 200, o_custkey => 2, o_orderdate => "1995-07-15"}],
    Lineitem = [#{l_orderkey => 100, l_suppkey => 1000, l_partkey => 5000, l_extendedprice => 1000, l_discount => 0.1}, #{l_orderkey => 200, l_suppkey => 2000, l_partkey => 5000, l_extendedprice => 500, l_discount => 0.05}],
    Supplier = [#{s_suppkey => 1000}, #{s_suppkey => 2000}],
    Part = [#{p_partkey => 5000, p_type => "ECONOMY ANODIZED STEEL"}, #{p_partkey => 6000, p_type => "SMALL BRASS"}],
    Result = [V || {_, V} <- lists:keysort(1, [{Key0, #{o_year => Key0, mkt_share => (lists:sum([(case (maps:get(n_name, maps:get(n, X, undefined), undefined) == "BRAZIL") of true -> (maps:get(l_extendedprice, maps:get(l, X, undefined), undefined) * ((1 - maps:get(l_discount, maps:get(l, X, undefined), undefined)))); _ -> 0 end) || X <- Val0]) / lists:sum([(maps:get(l_extendedprice, maps:get(l, X, undefined), undefined) * ((1 - maps:get(l_discount, maps:get(l, X, undefined), undefined)))) || X <- Val0]))}} || {Key0, Val0} <- maps:to_list(lists:foldl(fun({Key0, Val0}, Acc0) -> L = maps:get(Key0, Acc0, []), maps:put(Key0, [Val0 | L], Acc0) end, #{}, [{string:substr(maps:get(o_orderdate, O, undefined), (0)+1, (4)-(0)), #{l => L, p => P, s => S, o => O, c => C, n => N, r => R}} || L <- Lineitem, P <- Part, S <- Supplier, O <- Orders, C <- Customer, N <- Nation, R <- Region, (maps:get(p_partkey, P, undefined) == maps:get(l_partkey, L, undefined)), (maps:get(s_suppkey, S, undefined) == maps:get(l_suppkey, L, undefined)), (maps:get(o_orderkey, O, undefined) == maps:get(l_orderkey, L, undefined)), (maps:get(c_custkey, C, undefined) == maps:get(o_custkey, O, undefined)), (maps:get(n_nationkey, N, undefined) == maps:get(c_nationkey, C, undefined)), (maps:get(r_regionkey, R, undefined) == maps:get(n_regionkey, N, undefined)), (case (((((maps:get(p_type, P, undefined) == "ECONOMY ANODIZED STEEL") andalso (maps:get(o_orderdate, O, undefined) >= "1995-01-01")) andalso (maps:get(o_orderdate, O, undefined) =< "1996-12-31")) andalso (maps:get(r_name, R, undefined) == "AMERICA"))) of undefined -> false; false -> false; _ -> true end)]))])],
    mochi_json(Result),
    Numerator = (1000 * 0.9), Denominator = (Numerator + ((500 * 0.95))), Share = (Numerator / Denominator), (case (Result == [#{o_year => "1995", mkt_share => Share}]) of true -> ok; _ -> erlang:error(test_failed) end).

mochi_escape_json([]) -> [];
mochi_escape_json([H|T]) ->
    E = case H of
        $\ -> "\\";
        $" -> "\"";
        _ -> [H]
    end,
    E ++ mochi_escape_json(T).

mochi_to_json(true) -> "true";
mochi_to_json(false) -> "false";
mochi_to_json(V) when is_integer(V); is_float(V) -> lists:flatten(io_lib:format("~p", [V]));
mochi_to_json(V) when is_binary(V) -> "\"" ++ mochi_escape_json(binary_to_list(V)) ++ "\"";
mochi_to_json(V) when is_list(V), (V =:= [] orelse is_integer(hd(V))) -> "\"" ++ mochi_escape_json(V) ++ "\"";
mochi_to_json(V) when is_list(V) -> "[" ++ lists:join(",", [mochi_to_json(X) || X <- V]) ++ "]";
mochi_to_json(V) when is_map(V) -> "{" ++ lists:join(",", ["\"" ++ atom_to_list(K) ++ "\":" ++ mochi_to_json(Val) || {K,Val} <- maps:to_list(V)]) ++ "}".

mochi_json(V) -> io:format("~s
", [mochi_to_json(V)]).
