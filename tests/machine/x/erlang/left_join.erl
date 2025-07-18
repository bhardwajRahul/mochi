#!/usr/bin/env escript
%% Generated by Mochi compiler v0.10.27 on 2025-07-17T08:58:30Z
% left_join.erl - generated from left_join.mochi

main(_) ->
    Customers = [#{id => 1, name => "Alice"}, #{id => 2, name => "Bob"}],
    Orders = [#{id => 100, customerId => 1, total => 250}, #{id => 101, customerId => 3, total => 80}],
    Result = [#{orderId => mochi_get(id, O), customer => C, total => mochi_get(total, O)} || O <- Orders, {O, C} <- mochi_left_join_item(O, Customers, fun(O, C) -> (mochi_get(customerId, O) == mochi_get(id, C)) end)],
    io:format("~p~n", ["--- Left Join ---"]),
    lists:foreach(fun(Entry) -> io:format("~p ~p ~p ~p ~p ~p~n", ["Order", mochi_get(orderId, Entry), "customer", mochi_get(customer, Entry), "total", mochi_get(total, Entry)]) end, Result).

mochi_left_join_item(A, B, Fun) ->
    Matches = [ {A, J} || J <- B, Fun(A, J) ],
    case Matches of
        [] -> [{A, undefined}];
        _ -> Matches
    end.

mochi_left_join(L, R, Fun) ->
    lists:flatmap(fun(X) -> mochi_left_join_item(X, R, Fun) end, L).

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
