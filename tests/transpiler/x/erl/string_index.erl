#!/usr/bin/env escript
-module(main).
-export([main/1]).

% Generated by Mochi transpiler v0.10.31 on 2025-07-19T18:36:54Z

main(_) ->
    S = "mochi",
    io:format("~s~n", [string:substr(S, 1 + 1, 1)]).
