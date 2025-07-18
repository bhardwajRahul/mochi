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
    dict_create(_V0, map, [cs_sold_date_sk-1, cs_item_sk-1, cs_bill_cdemo_sk-1, cs_promo_sk-1, cs_quantity-10, cs_list_price-100, cs_coupon_amt-5, cs_sales_price-95]),
    dict_create(_V1, map, [cs_sold_date_sk-1, cs_item_sk-2, cs_bill_cdemo_sk-2, cs_promo_sk-2, cs_quantity-5, cs_list_price-50, cs_coupon_amt-2, cs_sales_price-48]),
    Catalog_sales = [_V0, _V1],
    dict_create(_V2, map, [cd_demo_sk-1, cd_gender-"M", cd_marital_status-"S", cd_education_status-"College"]),
    dict_create(_V3, map, [cd_demo_sk-2, cd_gender-"F", cd_marital_status-"M", cd_education_status-"High School"]),
    Customer_demographics = [_V2, _V3],
    dict_create(_V4, map, [d_date_sk-1, d_year-2000]),
    Date_dim = [_V4],
    dict_create(_V5, map, [i_item_sk-1, i_item_id-"ITEM1"]),
    dict_create(_V6, map, [i_item_sk-2, i_item_id-"ITEM2"]),
    Item = [_V5, _V6],
    dict_create(_V7, map, [p_promo_sk-1, p_channel_email-"N", p_channel_event-"Y"]),
    dict_create(_V8, map, [p_promo_sk-2, p_channel_email-"Y", p_channel_event-"N"]),
    Promotion = [_V7, _V8],
    findall(_V26, (member(Cs, Catalog_sales), member(Cd, Customer_demographics), get_item(Cs, 'cs_bill_cdemo_sk', _V9), get_item(Cd, 'cd_demo_sk', _V10), (_V9 == _V10), member(D, Date_dim), get_item(Cs, 'cs_sold_date_sk', _V11), get_item(D, 'd_date_sk', _V12), (_V11 == _V12), member(I, Item), get_item(Cs, 'cs_item_sk', _V13), get_item(I, 'i_item_sk', _V14), (_V13 == _V14), member(P, Promotion), get_item(Cs, 'cs_promo_sk', _V15), get_item(P, 'p_promo_sk', _V16), (_V15 == _V16), get_item(Cd, 'cd_gender', _V17), get_item(Cd, 'cd_marital_status', _V18), get_item(Cd, 'cd_education_status', _V19), get_item(P, 'p_channel_email', _V20), get_item(P, 'p_channel_event', _V21), get_item(D, 'd_year', _V22), (((((_V17 == "M"), (_V18 == "S")), (_V19 == "College")), ((_V20 == "N") ; (_V21 == "N"))), (_V22 == 2000)), get_item(I, 'i_item_id', _V23), _V24 = _V23, dict_create(_V25, map, ['Cs'-Cs, 'Cd'-Cd, 'D'-D, 'I'-I, 'P'-P]), _V26 = _V24-_V25), _V27),
    group_pairs(_V27, [], _V28),
    findall(_V47, (member(G, _V28), get_item(G, 'key', _V29), findall(_V31, (member(X, G), true, get_item(X, 'cs_quantity', _V30), _V31 = _V30), _V32), avg(_V32, _V33), findall(_V35, (member(X, G), true, get_item(X, 'cs_list_price', _V34), _V35 = _V34), _V36), avg(_V36, _V37), findall(_V39, (member(X, G), true, get_item(X, 'cs_coupon_amt', _V38), _V39 = _V38), _V40), avg(_V40, _V41), findall(_V43, (member(X, G), true, get_item(X, 'cs_sales_price', _V42), _V43 = _V42), _V44), avg(_V44, _V45), dict_create(_V46, map, [i_item_id-_V29, agg1-_V33, agg2-_V37, agg3-_V41, agg4-_V45]), _V47 = _V46), _V48),
    Result = _V48,
    json_write_dict(current_output, Result), nl,
    true,
    dict_create(_V49, map, [i_item_id-"ITEM1", agg1-10, agg2-100, agg3-5, agg4-95]),
    expect((Result == [_V49])),
    true.
