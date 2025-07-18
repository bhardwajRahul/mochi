% Generated by Mochi compiler v0.10.26 on 2025-07-15T06:34:34Z
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

int(X, _Res) :-
    number_string(_V0, X),
    _Res is _V0.

:- initialization(main, main).
main :-
    dict_create(_V0, map, [customer-1, sold_date-2, price-60]),
    dict_create(_V1, map, [customer-2, sold_date-2, price-40]),
    Store_sales = [_V0, _V1],
    dict_create(_V2, map, [d_date_sk-2, d_month_seq-5]),
    Date_dim = [_V2],
    dict_create(_V3, map, [c_customer_sk-1, c_current_addr_sk-1]),
    dict_create(_V4, map, [c_customer_sk-2, c_current_addr_sk-1]),
    Customer = [_V3, _V4],
    dict_create(_V5, map, [ca_address_sk-1, ca_county-"X", ca_state-"Y"]),
    Customer_address = [_V5],
    dict_create(_V6, map, [s_store_sk-1, s_county-"X", s_state-"Y"]),
    Store = [_V6],
    findall(_V23, (member(Ss, Store_sales), member(D, Date_dim), get_item(Ss, 'sold_date', _V7), get_item(D, 'd_date_sk', _V8), (_V7 == _V8), member(C, Customer), get_item(Ss, 'customer', _V9), get_item(C, 'c_customer_sk', _V10), (_V9 == _V10), member(Ca, Customer_address), get_item(C, 'c_current_addr_sk', _V11), get_item(Ca, 'ca_address_sk', _V12), get_item(Ca, 'ca_county', _V13), get_item(Ca, 'ca_state', _V14), (((_V11 == _V12), (_V13 == "X")), (_V14 == "Y")), member(S, Store), get_item(S, 's_store_sk', _V15), get_item(Ca, 'ca_county', _V16), get_item(S, 's_county', _V17), get_item(Ca, 'ca_state', _V18), get_item(S, 's_state', _V19), (((1 == _V15), (_V16 == _V17)), (_V18 == _V19)), true, get_item(C, 'c_customer_sk', _V20), get_item(Ss, 'price', _V21), dict_create(_V22, map, [customer-_V20, amt-_V21]), _V23 = _V22), _V24),
    Revenue = _V24,
    findall(_V28, (member(R, Revenue), true, get_item(R, 'customer', _V25), _V26 = _V25, dict_create(_V27, map, ['R'-R]), _V28 = _V26-_V27), _V29),
    group_pairs(_V29, [], _V30),
    findall(_V37, (member(G, _V30), get_item(G, 'key', _V31), findall(_V33, (member(X, G), true, get_item(X, 'amt', _V32), _V33 = _V32), _V34), sum(_V34, _V35), dict_create(_V36, map, [customer-_V31, revenue-_V35]), _V37 = _V36), _V38),
    By_customer = _V38,
    findall(_V44, (member(R, By_customer), true, get_item(R, 'revenue', _V39), int((_V39 / 50), _V40), dict_create(_V41, map, [seg-_V40]), _V42 = _V41, dict_create(_V43, map, ['R'-R]), _V44 = _V42-_V43), _V45),
    group_pairs(_V45, [], _V46),
    findall(_V53, (member(G, _V46), get_item(G, 'key', _V47), get_item(_V47, 'seg', _V48), count(G, _V49), get_item(G, 'key', _V50), get_item(_V50, 'seg', _V51), dict_create(_V52, map, [segment-_V48, num_customers-_V49, segment_base-(_V51 * 50)]), _V53 = _V52), _V54),
    Segments = _V54,
    Result = Segments,
    json_write_dict(current_output, Result), nl,
    true,
    dict_create(_V55, map, [segment-1, num_customers-1, segment_base-50]),
    dict_create(_V56, map, [segment-0, num_customers-1, segment_base-0]),
    expect((Result == [_V55, _V56])),
    true.
