#!/usr/bin/env escript
% Generated by Mochi compiler v0.10.26 on 2025-07-15T07:26:06Z
% q72.erl - generated from q72.mochi

main(_) ->
    Catalog_sales = [#{cs_item_sk => 1, cs_order_number => 1, cs_quantity => 1, cs_sold_date_sk => 1, cs_ship_date_sk => 3, cs_bill_cdemo_sk => 1, cs_bill_hdemo_sk => 1, cs_promo_sk => undefined}],
    Inventory = [#{inv_item_sk => 1, inv_warehouse_sk => 1, inv_date_sk => 2, inv_quantity_on_hand => 0}],
    Warehouse = [#{w_warehouse_sk => 1, w_warehouse_name => "Main"}],
    Item = [#{i_item_sk => 1, i_item_desc => "ItemA"}],
    Customer_demographics = [#{cd_demo_sk => 1, cd_marital_status => "M"}],
    Household_demographics = [#{hd_demo_sk => 1, hd_buy_potential => "5001-10000"}],
    Date_dim = [#{d_date_sk => 1, d_week_seq => 10, d_date => 1, d_year => 2000}, #{d_date_sk => 2, d_week_seq => 10, d_date => 1, d_year => 2000}, #{d_date_sk => 3, d_week_seq => 10, d_date => 7, d_year => 2000}],
    Result = [#{i_item_desc => mochi_get(item_desc, Key0), w_warehouse_name => mochi_get(warehouse, Key0), d_week_seq => mochi_get(week_seq, Key0), no_promo => (case [X || X <- Val0, (mochi_get(cs_promo_sk, X) == undefined)] of #{items := It} -> length(It); _ -> length([X || X <- Val0, (mochi_get(cs_promo_sk, X) == undefined)]) end), promo => (case [X || X <- Val0, (mochi_get(cs_promo_sk, X) /= undefined)] of #{items := It} -> length(It); _ -> length([X || X <- Val0, (mochi_get(cs_promo_sk, X) /= undefined)]) end), total_cnt => (case Val0 of #{items := It} -> length(It); _ -> length(Val0) end)} || {Key0, Val0} <- maps:to_list(lists:foldl(fun({Key0, Val0}, Acc0) -> L = maps:get(Key0, Acc0, []), maps:put(Key0, [Val0 | L], Acc0) end, #{}, [{#{item_desc => mochi_get(i_item_desc, I), warehouse => mochi_get(w_warehouse_name, W), week_seq => mochi_get(d_week_seq, D1)}, #{cs => Cs, inv => Inv, w => W, i => I, cd => Cd, hd => Hd, d1 => D1, d2 => D2, d3 => D3}} || Cs <- Catalog_sales, Inv <- Inventory, W <- Warehouse, I <- Item, Cd <- Customer_demographics, Hd <- Household_demographics, D1 <- Date_dim, D2 <- Date_dim, D3 <- Date_dim, (mochi_get(inv_item_sk, Inv) == mochi_get(cs_item_sk, Cs)), (mochi_get(w_warehouse_sk, W) == mochi_get(inv_warehouse_sk, Inv)), (mochi_get(i_item_sk, I) == mochi_get(cs_item_sk, Cs)), (mochi_get(cd_demo_sk, Cd) == mochi_get(cs_bill_cdemo_sk, Cs)), (mochi_get(hd_demo_sk, Hd) == mochi_get(cs_bill_hdemo_sk, Cs)), (mochi_get(d_date_sk, D1) == mochi_get(cs_sold_date_sk, Cs)), (mochi_get(d_date_sk, D2) == mochi_get(inv_date_sk, Inv)), (mochi_get(d_date_sk, D3) == mochi_get(cs_ship_date_sk, Cs)), ((((((mochi_get(d_week_seq, D1) == mochi_get(d_week_seq, D2)) andalso (mochi_get(inv_quantity_on_hand, Inv) < mochi_get(cs_quantity, Cs))) andalso (mochi_get(d_date, D3) > (mochi_get(d_date, D1) + 5))) andalso (mochi_get(hd_buy_potential, Hd) == "5001-10000")) andalso (mochi_get(d_year, D1) == 2000)) andalso (mochi_get(cd_marital_status, Cd) == "M"))]))],
    mochi_json(Result),
    (case (Result == [#{i_item_desc => "ItemA", w_warehouse_name => "Main", d_week_seq => 10, no_promo => 1, promo => 0, total_cnt => 1}]) of true -> ok; _ -> erlang:error(test_failed) end).

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
