#!/usr/bin/env escript
%% Generated by Mochi compiler v0.10.27 on 2025-07-17T08:58:48Z
% right_join.erl - generated from right_join.mochi

main(_) ->
    Customers = [#{id => 1, name => "Alice"}, #{id => 2, name => "Bob"}, #{id => 3, name => "Charlie"}, #{id => 4, name => "Diana"}],
    Orders = [#{id => 100, customerId => 1, total => 250}, #{id => 101, customerId => 2, total => 125}, #{id => 102, customerId => 1, total => 300}],
    Result = [#{customerName => mochi_get(name, C), order => O} || {C, O} <- mochi_right_join(Customers, Orders, fun(C, O) -> (mochi_get(customerId, O) == mochi_get(id, C)) end)],
    io:format("~p~n", ["--- Right Join using syntax ---"]),
    lists:foreach(fun(Entry) -> (case mochi_get(order, Entry) of undefined -> io:format("~p ~p ~p~n", ["Customer", mochi_get(customerName, Entry), "has no orders"]); false -> io:format("~p ~p ~p~n", ["Customer", mochi_get(customerName, Entry), "has no orders"]); _ -> io:format("~p ~p ~p ~p ~p ~p~n", ["Customer", mochi_get(customerName, Entry), "has order", mochi_get(id, mochi_get(order, Entry)), "- $", mochi_get(total, mochi_get(order, Entry))]) end) end, Result).

mochi_right_join_item(B, A, Fun) ->
    Matches = [ {I, B} || I <- A, Fun(I, B) ],
    case Matches of
        [] -> [{undefined, B}];
        _ -> Matches
    end.

mochi_right_join(L, R, Fun) ->
    lists:flatmap(fun(Y) -> mochi_right_join_item(Y, L, Fun) end, R).

mochi_get(K, M) ->
    case maps:find(K, M) of
        {ok, V} -> V;
        error ->
            Name = atom_to_list(K),
            case string:tokens(Name, "_") of
                [Pref|_] ->
                    P = list_to_atom(Pref),
                    case maps:find(P, M) of
                        {ok, Sub} when is_map(Sub) -> maps:get(K, Sub, undefined);
                        _ -> undefined
                    end;
                _ -> undefined
            end
        end.
