#!/usr/bin/env escript
%% Generated by Mochi compiler v0.10.30 on 2025-07-19T01:03:50Z
% 100-prisoners.erl - generated from 100-prisoners.mochi

shuffle(Xs) ->
    Arr0 = Xs,
    I0 = 99,
    {Arr2, I1} = (fun Loop0(Arr, I) -> case (I > 0) of true -> J = (now() rem ((I + 1))), Tmp = lists:nth((I)+1, Arr), Arr1 = lists:sublist(Arr, I) ++ [lists:nth((J)+1, Arr)] ++ lists:nthtail((I)+1, Arr), Arr2 = lists:sublist(Arr, J) ++ [Tmp] ++ lists:nthtail((J)+1, Arr), I1 = (I - 1), Loop0(Arr2, I1); _ -> {Arr, I} end end)(Arr0, I0),
    Arr2.

doTrials(Trials, Np, Strategy) ->
    Pardoned0 = 0,
    T0 = 0,
    {Drawers2, T1} = (fun Loop7(Drawers, T) -> case (T < Trials) of true -> Drawers0 = [], I2 = 0, {Drawers1, I3} = (fun Loop1(Drawers, I) -> case (I < 100) of true -> Drawers1 = Drawers ++ [I], I3 = (I + 1), Loop1(Drawers1, I3); _ -> {Drawers, I} end end)(Drawers0, I2), Drawers2 = shuffle(Drawers1), P0 = 0, Success0 = true, {P1} = (fun Loop6(P) -> case (P < Np) of true -> Found0 = false, (case (Strategy == "optimal") of true -> Prev0 = P, D0 = 0, {Prev0, D0} = (fun Loop2(Prev, D) -> case (D < 50) of true -> This = lists:nth((Prev)+1, Drawers2), (case (This == P) of true -> Found1 = true, throw(break); _ -> Found1 = Found0 end), Prev0 = This, D0 = (D + 1), Loop2(Prev0, D0); _ -> {Prev, D} end end)(Prev0, D0); _ -> Prev0 = Prev, Opened0 = [], K0 = 0, {Opened0, K0} = (fun Loop3(Opened, K) -> case (K < 100) of true -> Opened0 = Opened ++ [false], K0 = (K + 1), Loop3(Opened0, K0); _ -> {Opened, K} end end)(Opened0, K0), D0 = 0, {Opened0, D0} = (fun Loop5(Opened, D) -> case (D < 50) of true -> N0 = (now() rem 100), {N0} = (fun Loop4(N) -> case lists:nth((N)+1, Opened) of true -> N0 = (now() rem 100), Loop4(N0); _ -> {N} end end)(N0), Opened0 = lists:sublist(Opened, N0) ++ [true] ++ lists:nthtail((N0)+1, Opened), (case (lists:nth((N0)+1, Drawers2) == P) of true -> Found2 = true, throw(break); _ -> Found2 = Found0 end), D0 = (D + 1), Loop5(Opened0, D0); _ -> {Opened, D} end end)(Opened0, D0) end), (case not Found1 of true -> Success1 = false, throw(break); _ -> Success1 = Success0 end), P1 = (P + 1), Loop6(P1); _ -> {P} end end)(P0), (case Success1 of undefined -> Pardoned1 = Pardoned0; false -> Pardoned1 = Pardoned0; _ -> Pardoned1 = (Pardoned0 + 1) end), T1 = (T + 1), Loop7(Drawers2, T1); _ -> {Drawers, T} end end)(Drawers, T0),
    Rf = (((Pardoned1) / (Trials)) * 100),
    io:format("~p~n", ["  strategy = " ++ Strategy ++ "  pardoned = " ++ lists:flatten(io_lib:format("~p", [Pardoned1])) ++ " relative frequency = " ++ lists:flatten(io_lib:format("~p", [Rf])) ++ "%"]).

main() ->
    lists:foreach(fun(Np) -> io:format("~p~n", ["Results from " ++ lists:flatten(io_lib:format("~p", [Trials])) ++ " trials with " ++ lists:flatten(io_lib:format("~p", [Np])) ++ " prisoners:\n"]), lists:foreach(fun(Strat) -> doTrials(Trials, Np, Strat) end, ["random", "optimal"]) end, [10, 100]).

main(_) ->
    main().
