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
    dict_create(_V0, map, [ss_item_sk-1, ss_sold_date_sk-1, ss_customer_sk-1, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V1, map, [ss_item_sk-1, ss_sold_date_sk-1, ss_customer_sk-1, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V2, map, [ss_item_sk-1, ss_sold_date_sk-1, ss_customer_sk-1, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V3, map, [ss_item_sk-1, ss_sold_date_sk-1, ss_customer_sk-1, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V4, map, [ss_item_sk-1, ss_sold_date_sk-1, ss_customer_sk-1, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V5, map, [ss_item_sk-2, ss_sold_date_sk-1, ss_customer_sk-2, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V6, map, [ss_item_sk-2, ss_sold_date_sk-1, ss_customer_sk-2, ss_quantity-1, ss_sales_price-10]),
    dict_create(_V7, map, [ss_item_sk-2, ss_sold_date_sk-1, ss_customer_sk-2, ss_quantity-1, ss_sales_price-10]),
    Store_sales = [_V0, _V1, _V2, _V3, _V4, _V5, _V6, _V7],
    dict_create(_V8, map, [d_date_sk-1, d_year-2000, d_moy-1]),
    Date_dim = [_V8],
    dict_create(_V9, map, [i_item_sk-1]),
    dict_create(_V10, map, [i_item_sk-2]),
    Item = [_V9, _V10],
    dict_create(_V11, map, [cs_sold_date_sk-1, cs_item_sk-1, cs_bill_customer_sk-1, cs_quantity-2, cs_list_price-10]),
    dict_create(_V12, map, [cs_sold_date_sk-1, cs_item_sk-2, cs_bill_customer_sk-2, cs_quantity-2, cs_list_price-10]),
    Catalog_sales = [_V11, _V12],
    dict_create(_V13, map, [ws_sold_date_sk-1, ws_item_sk-1, ws_bill_customer_sk-1, ws_quantity-3, ws_list_price-10]),
    dict_create(_V14, map, [ws_sold_date_sk-1, ws_item_sk-2, ws_bill_customer_sk-2, ws_quantity-1, ws_list_price-10]),
    Web_sales = [_V13, _V14],
    findall(_V25, (member(Ss, Store_sales), member(D, Date_dim), get_item(Ss, 'ss_sold_date_sk', _V15), get_item(D, 'd_date_sk', _V16), (_V15 == _V16), member(I, Item), get_item(Ss, 'ss_item_sk', _V17), get_item(I, 'i_item_sk', _V18), (_V17 == _V18), get_item(D, 'd_year', _V19), (_V19 == 2000), get_item(I, 'i_item_sk', _V20), get_item(D, 'd_date_sk', _V21), dict_create(_V22, map, [item_sk-_V20, date_sk-_V21]), _V23 = _V22, dict_create(_V24, map, ['Ss'-Ss, 'D'-D, 'I'-I]), _V25 = _V23-_V24), _V26),
    group_pairs(_V26, [], _V27),
    findall(_V30, (member(G, _V27), get_item(G, 'key', _V28), get_item(_V28, 'item_sk', _V29), _V30 = _V29), _V31),
    Frequent_ss_items = _V31,
    findall(_V35, (member(Ss, Store_sales), true, get_item(Ss, 'ss_customer_sk', _V32), _V33 = _V32, dict_create(_V34, map, ['Ss'-Ss]), _V35 = _V33-_V34), _V36),
    group_pairs(_V36, [], _V37),
    findall(_V45, (member(G, _V37), get_item(G, 'key', _V38), findall(_V41, (member(X, G), true, get_item(X, 'ss_quantity', _V39), get_item(X, 'ss_sales_price', _V40), _V41 = (_V39 * _V40)), _V42), sum(_V42, _V43), dict_create(_V44, map, [cust-_V38, sales-_V43]), _V45 = _V44), _V46),
    Customer_totals = _V46,
    findall(_V48, (member(C, Customer_totals), true, get_item(C, 'sales', _V47), _V48 = _V47), _V49),
    max_list(_V49, _V50),
    Max_sales is _V50,
    findall(_V53, (member(C, Customer_totals), get_item(C, 'sales', _V51), (_V51 > (0.95 * Max_sales)), get_item(C, 'cust', _V52), _V53 = _V52), _V54),
    Best_ss_customer = _V54,
    findall(_V65, (member(Cs, Catalog_sales), member(D, Date_dim), get_item(Cs, 'cs_sold_date_sk', _V55), get_item(D, 'd_date_sk', _V56), (_V55 == _V56), get_item(D, 'd_year', _V57), get_item(D, 'd_moy', _V58), get_item(Cs, 'cs_bill_customer_sk', _V59), get_item(Cs, 'cs_item_sk', _V60), contains(Best_ss_customer, _V59, _V61), contains(Frequent_ss_items, _V60, _V62), ((((_V57 == 2000), (_V58 == 1)), _V61), _V62), get_item(Cs, 'cs_quantity', _V63), get_item(Cs, 'cs_list_price', _V64), _V65 = (_V63 * _V64)), _V66),
    Catalog = _V66,
    findall(_V77, (member(Ws, Web_sales), member(D, Date_dim), get_item(Ws, 'ws_sold_date_sk', _V67), get_item(D, 'd_date_sk', _V68), (_V67 == _V68), get_item(D, 'd_year', _V69), get_item(D, 'd_moy', _V70), get_item(Ws, 'ws_bill_customer_sk', _V71), get_item(Ws, 'ws_item_sk', _V72), contains(Best_ss_customer, _V71, _V73), contains(Frequent_ss_items, _V72, _V74), ((((_V69 == 2000), (_V70 == 1)), _V73), _V74), get_item(Ws, 'ws_quantity', _V75), get_item(Ws, 'ws_list_price', _V76), _V77 = (_V75 * _V76)), _V78),
    Web = _V78,
    sum(Catalog, _V79),
    sum(Web, _V80),
    Result is (_V79 + _V80),
    json_write_dict(current_output, Result), nl,
    true,
    expect((Result == 50)),
    true.
