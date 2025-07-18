% Generated by Mochi compiler v0.10.26 on 2025-07-15T06:34:32Z
:- style_check(-singleton).
get_item(Container, Key, Val) :-
    is_dict(Container), !, (string(Key) -> atom_string(A, Key) ; A = Key), get_dict(A, Container, Val).
get_item(Container, Index, Val) :-
    string(Container), !, string_chars(Container, Chars), nth0(Index, Chars, Val).
get_item(List, Index, Val) :- nth0(Index, List, Val).

to_list(Str, L) :-
    string(Str), !,
    string_chars(Str, L).
to_list(L, L).

count(V, R) :-
    is_dict(V), !, get_dict('Items', V, Items), length(Items, R).
count(V, R) :-
    string(V), !, string_chars(V, C), length(C, R).
count(V, R) :-
    is_list(V), !, length(V, R).
count(_, _) :- throw(error('count expects list or group')).

avg(V, R) :-
    is_dict(V), !, get_dict('Items', V, Items), avg_list(Items, R).
avg(V, R) :-
    is_list(V), !, avg_list(V, R).
avg(_, _) :- throw(error('avg expects list or group')).
avg_list([], 0).
avg_list(L, R) :- sum_list(L, S), length(L, N), N > 0, R is S / N.

sum(V, R) :-
    is_dict(V), !, get_dict('Items', V, Items), sum_list(Items, R).
sum(V, R) :-
    is_list(V), !, sum_list(V, R).
sum(_, _) :- throw(error('sum expects list or group')).

group_insert(Key, Item, [], [_{key:Key, 'Items':[Item]}]).
group_insert(Key, Item, [G|Gs], [NG|Gs]) :- get_dict(key, G, Key), !, get_dict('Items', G, Items), append(Items, [Item], NItems), put_dict('Items', G, NItems, NG).
group_insert(Key, Item, [G|Gs], [G|Rs]) :- group_insert(Key, Item, Gs, Rs).
group_pairs([], Acc, Res) :- reverse(Acc, Res).
group_pairs([K-V|T], Acc, Res) :- group_insert(K, V, Acc, Acc1), group_pairs(T, Acc1, Res).
group_by(List, Fn, Groups) :- findall(K-V, (member(V, List), call(Fn, V, K)), Pairs), group_pairs(Pairs, [], Groups).

:- use_module(library(http/json)).
load_data(Path, Opts, Rows) :-
    (is_dict(Opts), get_dict(format, Opts, Fmt) -> true ; Fmt = 'json'),
    (Path == '' ; Path == '-' -> read_string(user_input, _, Text) ; read_file_to_string(Path, Text, [])),
    (Fmt == 'jsonl' ->
        split_string(Text, '\n', ' \t\r', Lines0),
        exclude(=(''), Lines0, Lines),
        findall(D, (member(L, Lines), open_string(L, S), json_read_dict(S, D), close(S)), Rows)
    ;
        open_string(Text, S), json_read_dict(S, Data), close(S),
        (is_list(Data) -> Rows = Data ; Rows = [Data])
    ).

expect(Cond) :- (Cond -> true ; throw(error('expect failed'))).

:- initialization(main, main).
main :-
    dict_create(_V0, map, [cs_quantity-1, cs_list_price-10, cs_coupon_amt-1, cs_sales_price-9, cs_net_profit-2, cs_bill_cdemo_sk-1, cs_bill_customer_sk-1, cs_sold_date_sk-1, cs_item_sk-1]),
    Catalog_sales = [_V0],
    dict_create(_V1, map, [cd_demo_sk-1, cd_gender-"M", cd_education_status-"College", cd_dep_count-2]),
    dict_create(_V2, map, [cd_demo_sk-2, cd_gender-"F", cd_education_status-"College", cd_dep_count-2]),
    Customer_demographics = [_V1, _V2],
    dict_create(_V3, map, [c_customer_sk-1, c_current_cdemo_sk-2, c_current_addr_sk-1, c_birth_year-1980, c_birth_month-1]),
    Customer = [_V3],
    dict_create(_V4, map, [ca_address_sk-1, ca_country-"US", ca_state-"CA", ca_county-"County1"]),
    Customer_address = [_V4],
    dict_create(_V5, map, [d_date_sk-1, d_year-1999]),
    Date_dim = [_V5],
    dict_create(_V6, map, [i_item_sk-1, i_item_id-"I1"]),
    Item = [_V6],
    findall(_V34, (member(Cs, Catalog_sales), member(Cd1, Customer_demographics), get_item(Cs, 'cs_bill_cdemo_sk', _V7), get_item(Cd1, 'cd_demo_sk', _V8), get_item(Cd1, 'cd_gender', _V9), get_item(Cd1, 'cd_education_status', _V10), (((_V7 == _V8), (_V9 == "M")), (_V10 == "College")), member(C, Customer), get_item(Cs, 'cs_bill_customer_sk', _V11), get_item(C, 'c_customer_sk', _V12), (_V11 == _V12), member(Cd2, Customer_demographics), get_item(C, 'c_current_cdemo_sk', _V13), get_item(Cd2, 'cd_demo_sk', _V14), (_V13 == _V14), member(Ca, Customer_address), get_item(C, 'c_current_addr_sk', _V15), get_item(Ca, 'ca_address_sk', _V16), (_V15 == _V16), member(D, Date_dim), get_item(Cs, 'cs_sold_date_sk', _V17), get_item(D, 'd_date_sk', _V18), get_item(D, 'd_year', _V19), ((_V17 == _V18), (_V19 == 1999)), member(I, Item), get_item(Cs, 'cs_item_sk', _V20), get_item(I, 'i_item_sk', _V21), (_V20 == _V21), true, get_item(I, 'i_item_id', _V22), get_item(Ca, 'ca_country', _V23), get_item(Ca, 'ca_state', _V24), get_item(Ca, 'ca_county', _V25), get_item(Cs, 'cs_quantity', _V26), get_item(Cs, 'cs_list_price', _V27), get_item(Cs, 'cs_coupon_amt', _V28), get_item(Cs, 'cs_sales_price', _V29), get_item(Cs, 'cs_net_profit', _V30), get_item(C, 'c_birth_year', _V31), get_item(Cd1, 'cd_dep_count', _V32), dict_create(_V33, map, [i_item_id-_V22, ca_country-_V23, ca_state-_V24, ca_county-_V25, q-_V26, lp-_V27, cp-_V28, sp-_V29, np-_V30, by-_V31, dep-_V32]), _V34 = _V33), _V35),
    Joined = _V35,
    findall(_V43, (member(J, Joined), true, get_item(J, 'i_item_id', _V36), get_item(J, 'ca_country', _V37), get_item(J, 'ca_state', _V38), get_item(J, 'ca_county', _V39), dict_create(_V40, map, [i_item_id-_V36, ca_country-_V37, ca_state-_V38, ca_county-_V39]), _V41 = _V40, dict_create(_V42, map, ['J'-J]), _V43 = _V41-_V42), _V44),
    group_pairs(_V44, [], _V45),
    findall(_V83, (member(G, _V45), get_item(G, 'key', _V46), get_item(_V46, 'i_item_id', _V47), get_item(G, 'key', _V48), get_item(_V48, 'ca_country', _V49), get_item(G, 'key', _V50), get_item(_V50, 'ca_state', _V51), get_item(G, 'key', _V52), get_item(_V52, 'ca_county', _V53), findall(_V55, (member(X, G), true, get_item(X, 'q', _V54), _V55 = _V54), _V56), avg(_V56, _V57), findall(_V59, (member(X, G), true, get_item(X, 'lp', _V58), _V59 = _V58), _V60), avg(_V60, _V61), findall(_V63, (member(X, G), true, get_item(X, 'cp', _V62), _V63 = _V62), _V64), avg(_V64, _V65), findall(_V67, (member(X, G), true, get_item(X, 'sp', _V66), _V67 = _V66), _V68), avg(_V68, _V69), findall(_V71, (member(X, G), true, get_item(X, 'np', _V70), _V71 = _V70), _V72), avg(_V72, _V73), findall(_V75, (member(X, G), true, get_item(X, 'by', _V74), _V75 = _V74), _V76), avg(_V76, _V77), findall(_V79, (member(X, G), true, get_item(X, 'dep', _V78), _V79 = _V78), _V80), avg(_V80, _V81), dict_create(_V82, map, [i_item_id-_V47, ca_country-_V49, ca_state-_V51, ca_county-_V53, agg1-_V57, agg2-_V61, agg3-_V65, agg4-_V69, agg5-_V73, agg6-_V77, agg7-_V81]), _V83 = _V82), _V84),
    Result = _V84,
    json_write_dict(current_output, Result), nl,
    true,
    dict_create(_V85, map, [i_item_id-"I1", ca_country-"US", ca_state-"CA", ca_county-"County1", agg1-1, agg2-10, agg3-1, agg4-9, agg5-2, agg6-1980, agg7-2]),
    expect((Result == [_V85])),
    true.
