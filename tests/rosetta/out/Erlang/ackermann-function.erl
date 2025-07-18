#!/usr/bin/env escript
% Generated by Mochi compiler v0.10.26 on 2025-07-16T09:59:13Z
% ackermann-function.erl - generated from ackermann-function.mochi

ackermann(M, N) ->
    (case (M == 0) of true -> (N + 1); _ -> ok end),
    (case (N == 0) of true -> ackermann((M - 1), 1); _ -> ok end),
    ackermann((M - 1), ackermann(M, (N - 1))).

main() ->
    io:format("~p~n", ["A(0, 0) = " ++ lists:flatten(io_lib:format("~p", [ackermann(0, 0)]))]),
    io:format("~p~n", ["A(1, 2) = " ++ lists:flatten(io_lib:format("~p", [ackermann(1, 2)]))]),
    io:format("~p~n", ["A(2, 4) = " ++ lists:flatten(io_lib:format("~p", [ackermann(2, 4)]))]),
    io:format("~p~n", ["A(3, 4) = " ++ lists:flatten(io_lib:format("~p", [ackermann(3, 4)]))]).

main(_) ->
    main().
