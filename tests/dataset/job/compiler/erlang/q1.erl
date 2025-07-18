#!/usr/bin/env escript
% Generated by Mochi compiler v0.10.25 on 2025-07-13T12:57:35Z
% q1.erl - generated from q1.mochi

main(_) ->
    Company_type = [#{id => 1, kind => "production companies"}, #{id => 2, kind => "distributors"}],
    Info_type = [#{id => 10, info => "top 250 rank"}, #{id => 20, info => "bottom 10 rank"}],
    Title = [#{id => 100, title => "Good Movie", production_year => 1995}, #{id => 200, title => "Bad Movie", production_year => 2000}],
    Movie_companies = [#{movie_id => 100, company_type_id => 1, note => "ACME (co-production)"}, #{movie_id => 200, company_type_id => 1, note => "MGM (as Metro-Goldwyn-Mayer Pictures)"}],
    Movie_info_idx = [#{movie_id => 100, info_type_id => 10}, #{movie_id => 200, info_type_id => 20}],
    Filtered = [#{note => maps:get(note, Mc), title => maps:get(title, T), year => maps:get(production_year, T)} || Ct <- Company_type, Mc <- Movie_companies, T <- Title, Mi <- Movie_info_idx, It <- Info_type, (maps:get(id, Ct) == maps:get(company_type_id, Mc)), (maps:get(id, T) == maps:get(movie_id, Mc)), (maps:get(movie_id, Mi) == maps:get(id, T)), (maps:get(id, It) == maps:get(info_type_id, Mi)), ((((maps:get(kind, Ct) == "production companies") andalso (maps:get(info, It) == "top 250 rank")) andalso (not (string:str(maps:get(note, Mc), "(as Metro-Goldwyn-Mayer Pictures)") > 0))) andalso (((string:str(maps:get(note, Mc), "(co-production)") > 0) orelse (string:str(maps:get(note, Mc), "(presents)") > 0))))],
    Result = #{production_note => lists:min([maps:get(note, R) || R <- Filtered]), movie_title => lists:min([maps:get(title, R) || R <- Filtered]), movie_year => lists:min([maps:get(year, R) || R <- Filtered])},
    mochi_json([Result]),
    (case (Result == #{production_note => "ACME (co-production)", movie_title => "Good Movie", movie_year => 1995}) of true -> ok; _ -> erlang:error(test_failed) end).

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
