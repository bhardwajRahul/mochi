% Generated by Mochi compiler v0.10.26 on 2025-07-15T06:34:31Z
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
    dict_create(_V0, map, [ws_item_sk-1, ws_sold_date_sk-1, ws_ext_sales_price-100]),
    dict_create(_V1, map, [ws_item_sk-1, ws_sold_date_sk-2, ws_ext_sales_price-100]),
    dict_create(_V2, map, [ws_item_sk-2, ws_sold_date_sk-2, ws_ext_sales_price-200]),
    dict_create(_V3, map, [ws_item_sk-3, ws_sold_date_sk-3, ws_ext_sales_price-50]),
    Web_sales = [_V0, _V1, _V2, _V3],
    dict_create(_V4, map, [i_item_sk-1, i_item_id-"ITEM1", i_item_desc-"Item One", i_category-"A", i_class-"C1", i_current_price-10]),
    dict_create(_V5, map, [i_item_sk-2, i_item_id-"ITEM2", i_item_desc-"Item Two", i_category-"A", i_class-"C1", i_current_price-20]),
    dict_create(_V6, map, [i_item_sk-3, i_item_id-"ITEM3", i_item_desc-"Item Three", i_category-"B", i_class-"C2", i_current_price-30]),
    Item = [_V4, _V5, _V6],
    dict_create(_V7, map, [d_date_sk-1, d_date-"2001-01-20"]),
    dict_create(_V8, map, [d_date_sk-2, d_date-"2001-02-05"]),
    dict_create(_V9, map, [d_date_sk-3, d_date-"2001-03-05"]),
    Date_dim = [_V7, _V8, _V9],
    findall(_V26, (member(Ws, Web_sales), member(I, Item), get_item(Ws, 'ws_item_sk', _V10), get_item(I, 'i_item_sk', _V11), (_V10 == _V11), member(D, Date_dim), get_item(Ws, 'ws_sold_date_sk', _V12), get_item(D, 'd_date_sk', _V13), (_V12 == _V13), get_item(I, 'i_category', _V14), get_item(D, 'd_date', _V15), get_item(D, 'd_date', _V16), contains(["A", "B", "C"], _V14, _V17), ((_V17, (_V15 >= "2001-01-15")), (_V16 =< "2001-02-14")), get_item(I, 'i_item_id', _V18), get_item(I, 'i_item_desc', _V19), get_item(I, 'i_category', _V20), get_item(I, 'i_class', _V21), get_item(I, 'i_current_price', _V22), dict_create(_V23, map, [id-_V18, desc-_V19, cat-_V20, class-_V21, price-_V22]), _V24 = _V23, dict_create(_V25, map, ['Ws'-Ws, 'I'-I, 'D'-D]), _V26 = _V24-_V25), _V27),
    group_pairs(_V27, [], _V28),
    findall(_V44, (member(G, _V28), get_item(G, 'key', _V29), get_item(_V29, 'id', _V30), get_item(G, 'key', _V31), get_item(_V31, 'desc', _V32), get_item(G, 'key', _V33), get_item(_V33, 'cat', _V34), get_item(G, 'key', _V35), get_item(_V35, 'class', _V36), get_item(G, 'key', _V37), get_item(_V37, 'price', _V38), findall(_V40, (member(X, G), true, get_item(X, 'ws_ext_sales_price', _V39), _V40 = _V39), _V41), sum(_V41, _V42), dict_create(_V43, map, [i_item_id-_V30, i_item_desc-_V32, i_category-_V34, i_class-_V36, i_current_price-_V38, itemrevenue-_V42]), _V44 = _V43), _V45),
    Filtered = _V45,
    findall(_V49, (member(F, Filtered), true, get_item(F, 'i_class', _V46), _V47 = _V46, dict_create(_V48, map, ['F'-F]), _V49 = _V47-_V48), _V50),
    group_pairs(_V50, [], _V51),
    findall(_V58, (member(G, _V51), get_item(G, 'key', _V52), findall(_V54, (member(X, G), true, get_item(X, 'itemrevenue', _V53), _V54 = _V53), _V55), sum(_V55, _V56), dict_create(_V57, map, [class-_V52, total-_V56]), _V58 = _V57), _V59),
    Class_totals = _V59,
    findall(_V71, (member(F, Filtered), member(T, Class_totals), get_item(F, 'i_class', _V60), get_item(T, 'class', _V61), (_V60 == _V61), true, get_item(F, 'i_item_id', _V62), get_item(F, 'i_item_desc', _V63), get_item(F, 'i_category', _V64), get_item(F, 'i_class', _V65), get_item(F, 'i_current_price', _V66), get_item(F, 'itemrevenue', _V67), get_item(F, 'itemrevenue', _V68), get_item(T, 'total', _V69), dict_create(_V70, map, [i_item_id-_V62, i_item_desc-_V63, i_category-_V64, i_class-_V65, i_current_price-_V66, itemrevenue-_V67, revenueratio-((_V68 * 100) / _V69)]), _V71 = _V70), _V72),
    Result = _V72,
    json_write_dict(current_output, Result), nl,
    true,
    dict_create(_V73, map, [i_item_id-"ITEM1", i_item_desc-"Item One", i_category-"A", i_class-"C1", i_current_price-10, itemrevenue-200, revenueratio-50]),
    dict_create(_V74, map, [i_item_id-"ITEM2", i_item_desc-"Item Two", i_category-"A", i_class-"C1", i_current_price-20, itemrevenue-200, revenueratio-50]),
    expect((Result == [_V73, _V74])),
    true.
