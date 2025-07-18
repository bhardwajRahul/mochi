% Generated by Mochi compiler v0.10.26 on 2025-07-15T06:34:32Z
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
    dict_create(_V0, map, [ss_item_sk-1, ss_store_sk-1, ss_cdemo_sk-1, ss_sold_date_sk-1, ss_quantity-5, ss_list_price-100, ss_coupon_amt-10, ss_sales_price-90]),
    dict_create(_V1, map, [ss_item_sk-2, ss_store_sk-2, ss_cdemo_sk-2, ss_sold_date_sk-1, ss_quantity-2, ss_list_price-50, ss_coupon_amt-5, ss_sales_price-45]),
    Store_sales = [_V0, _V1],
    dict_create(_V2, map, [cd_demo_sk-1, cd_gender-"F", cd_marital_status-"M", cd_education_status-"College"]),
    dict_create(_V3, map, [cd_demo_sk-2, cd_gender-"M", cd_marital_status-"S", cd_education_status-"College"]),
    Customer_demographics = [_V2, _V3],
    dict_create(_V4, map, [d_date_sk-1, d_year-2000]),
    Date_dim = [_V4],
    dict_create(_V5, map, [s_store_sk-1, s_state-"CA"]),
    dict_create(_V6, map, [s_store_sk-2, s_state-"TX"]),
    Store = [_V5, _V6],
    dict_create(_V7, map, [i_item_sk-1, i_item_id-"ITEM1"]),
    dict_create(_V8, map, [i_item_sk-2, i_item_id-"ITEM2"]),
    Item = [_V7, _V8],
    findall(_V28, (member(Ss, Store_sales), member(Cd, Customer_demographics), get_item(Ss, 'ss_cdemo_sk', _V9), get_item(Cd, 'cd_demo_sk', _V10), (_V9 == _V10), member(D, Date_dim), get_item(Ss, 'ss_sold_date_sk', _V11), get_item(D, 'd_date_sk', _V12), (_V11 == _V12), member(S, Store), get_item(Ss, 'ss_store_sk', _V13), get_item(S, 's_store_sk', _V14), (_V13 == _V14), member(I, Item), get_item(Ss, 'ss_item_sk', _V15), get_item(I, 'i_item_sk', _V16), (_V15 == _V16), get_item(Cd, 'cd_gender', _V17), get_item(Cd, 'cd_marital_status', _V18), get_item(Cd, 'cd_education_status', _V19), get_item(D, 'd_year', _V20), get_item(S, 's_state', _V21), contains(["CA"], _V21, _V22), (((((_V17 == "F"), (_V18 == "M")), (_V19 == "College")), (_V20 == 2000)), _V22), get_item(I, 'i_item_id', _V23), get_item(S, 's_state', _V24), dict_create(_V25, map, [item_id-_V23, state-_V24]), _V26 = _V25, dict_create(_V27, map, ['Ss'-Ss, 'Cd'-Cd, 'D'-D, 'S'-S, 'I'-I]), _V28 = _V26-_V27), _V29),
    group_pairs(_V29, [], _V30),
    findall(_V52, (member(G, _V30), get_item(G, 'key', _V31), get_item(_V31, 'item_id', _V32), get_item(G, 'key', _V33), get_item(_V33, 'state', _V34), findall(_V36, (member(X, G), true, get_item(X, 'ss_quantity', _V35), _V36 = _V35), _V37), avg(_V37, _V38), findall(_V40, (member(X, G), true, get_item(X, 'ss_list_price', _V39), _V40 = _V39), _V41), avg(_V41, _V42), findall(_V44, (member(X, G), true, get_item(X, 'ss_coupon_amt', _V43), _V44 = _V43), _V45), avg(_V45, _V46), findall(_V48, (member(X, G), true, get_item(X, 'ss_sales_price', _V47), _V48 = _V47), _V49), avg(_V49, _V50), dict_create(_V51, map, [i_item_id-_V32, s_state-_V34, agg1-_V38, agg2-_V42, agg3-_V46, agg4-_V50]), _V52 = _V51), _V53),
    Result = _V53,
    json_write_dict(current_output, Result), nl,
    true,
    dict_create(_V54, map, [i_item_id-"ITEM1", s_state-"CA", agg1-5, agg2-100, agg3-10, agg4-90]),
    expect((Result == [_V54])),
    true.
