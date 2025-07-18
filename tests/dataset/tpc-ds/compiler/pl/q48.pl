% Generated by Mochi compiler v0.10.26 on 2025-07-15T06:39:03Z
:- style_check(-singleton).
get_item(Container, Key, Val) :-
    is_dict(Container), !, (string(Key) -> atom_string(A, Key) ; A = Key), get_dict(A, Container, Val).
get_item(Container, Index, Val) :-
    string(Container), !, string_chars(Container, Chars), nth0(Index, Chars, Val).
get_item(List, Index, Val) :- nth0(Index, List, Val).

contains(Container, Item, Res) :-
    is_dict(Container), !, (string(Item) -> atom_string(A, Item) ; A = Item), (get_dict(A, Container, _) -> Res = true ; Res = false).
contains(List, Item, Res) :-
    string(List), !, (sub_string(List, _, _, _, Item) -> Res = true ; Res = false).
contains(List, Item, Res) :- (member(Item, List) -> Res = true ; Res = false).

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
    dict_create(_V0, map, [cdemo_sk-1, addr_sk-1, sold_date_sk-1, sales_price-120, net_profit-1000, quantity-5]),
    dict_create(_V1, map, [cdemo_sk-2, addr_sk-2, sold_date_sk-1, sales_price-60, net_profit-2000, quantity-10]),
    dict_create(_V2, map, [cdemo_sk-3, addr_sk-3, sold_date_sk-1, sales_price-170, net_profit-10000, quantity-20]),
    Store_sales = [_V0, _V1, _V2],
    dict_create(_V3, map, [s_store_sk-1]),
    Store = [_V3],
    dict_create(_V4, map, [cd_demo_sk-1, cd_marital_status-"S", cd_education_status-"E1"]),
    dict_create(_V5, map, [cd_demo_sk-2, cd_marital_status-"M", cd_education_status-"E2"]),
    dict_create(_V6, map, [cd_demo_sk-3, cd_marital_status-"W", cd_education_status-"E3"]),
    Customer_demographics = [_V4, _V5, _V6],
    dict_create(_V7, map, [ca_address_sk-1, ca_country-"United States", ca_state-"TX"]),
    dict_create(_V8, map, [ca_address_sk-2, ca_country-"United States", ca_state-"CA"]),
    dict_create(_V9, map, [ca_address_sk-3, ca_country-"United States", ca_state-"NY"]),
    Customer_address = [_V7, _V8, _V9],
    dict_create(_V10, map, [d_date_sk-1, d_year-2000]),
    Date_dim = [_V10],
    Year is 2000,
    States1 = ["TX"],
    States2 = ["CA"],
    States3 = ["NY"],
    findall(_V43, (member(Ss, Store_sales), member(Cd, Customer_demographics), get_item(Ss, 'cdemo_sk', _V11), get_item(Cd, 'cd_demo_sk', _V12), (_V11 == _V12), member(Ca, Customer_address), get_item(Ss, 'addr_sk', _V13), get_item(Ca, 'ca_address_sk', _V14), (_V13 == _V14), member(D, Date_dim), get_item(Ss, 'sold_date_sk', _V15), get_item(D, 'd_date_sk', _V16), (_V15 == _V16), get_item(D, 'd_year', _V17), get_item(Cd, 'cd_marital_status', _V18), get_item(Cd, 'cd_education_status', _V19), get_item(Ss, 'sales_price', _V20), get_item(Ss, 'sales_price', _V21), get_item(Cd, 'cd_marital_status', _V22), get_item(Cd, 'cd_education_status', _V23), get_item(Ss, 'sales_price', _V24), get_item(Ss, 'sales_price', _V25), get_item(Cd, 'cd_marital_status', _V26), get_item(Cd, 'cd_education_status', _V27), get_item(Ss, 'sales_price', _V28), get_item(Ss, 'sales_price', _V29), get_item(Ca, 'ca_state', _V30), get_item(Ss, 'net_profit', _V31), get_item(Ss, 'net_profit', _V32), contains(States1, _V30, _V33), get_item(Ca, 'ca_state', _V34), get_item(Ss, 'net_profit', _V35), get_item(Ss, 'net_profit', _V36), contains(States2, _V34, _V37), get_item(Ca, 'ca_state', _V38), get_item(Ss, 'net_profit', _V39), get_item(Ss, 'net_profit', _V40), contains(States3, _V38, _V41), (((_V17 == Year), ((((((_V18 == "S"), (_V19 == "E1")), (_V20 >= 100)), (_V21 =< 150)) ; ((((_V22 == "M"), (_V23 == "E2")), (_V24 >= 50)), (_V25 =< 100))) ; ((((_V26 == "W"), (_V27 == "E3")), (_V28 >= 150)), (_V29 =< 200)))), ((((_V33, (_V31 >= 0)), (_V32 =< 2000)) ; ((_V37, (_V35 >= 150)), (_V36 =< 3000))) ; ((_V41, (_V39 >= 50)), (_V40 =< 25000)))), get_item(Ss, 'quantity', _V42), _V43 = _V42), _V44),
    Qty_base = _V44,
    Qty = Qty_base,
    sum(Qty, _V45),
    Result is _V45,
    json_write_dict(current_output, Result), nl,
    true,
    expect((Result == 35)),
    true.
