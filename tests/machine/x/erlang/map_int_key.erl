#!/usr/bin/env escript
%% Generated by Mochi compiler v0.10.27 on 2025-07-17T08:58:38Z
% map_int_key.erl - generated from map_int_key.mochi

main(_) ->
    M = #{1 => "a", 2 => "b"},
    io:format("~p~n", [maps:get(1, M, undefined)]).
