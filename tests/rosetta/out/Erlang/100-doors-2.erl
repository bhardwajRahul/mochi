#!/usr/bin/env escript
%% Generated by Mochi compiler v0.10.30 on 2025-07-19T01:03:44Z
% 100-doors-2.erl - generated from 100-doors-2.mochi

main(_) ->
    Door0 = 1,
    Incrementer0 = 0,
    {Incrementer1, Door1} = lists:foldl(fun(Current, {Incrementer, Door}) -> Line0 = "Door " ++ lists:flatten(io_lib:format("~p", [Current])) ++ " ", (case (Current == Door) of true -> Line1 = Line0 ++ "Open", Incrementer1 = (Incrementer + 1), Door1 = ((Door + (2 * Incrementer1)) + 1); _ -> Door1 = Door, Incrementer1 = Incrementer, Line1 = Line0 ++ "Closed" end), io:format("~p~n", [Line1]), {Incrementer1, Door1} end, {Incrementer0, Door0}, lists:seq(1, (101)-1)).
