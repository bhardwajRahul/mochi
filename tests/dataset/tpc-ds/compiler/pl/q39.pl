% Generated by Mochi compiler v0.10.26 on 2025-07-15T06:34:33Z
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

len_any(Value, Len) :-
    string(Value), !, string_length(Value, Len).
len_any(Value, Len) :-
    is_dict(Value), !, dict_pairs(Value, _, Pairs), length(Pairs, Len).
len_any(Value, Len) :- length(Value, Len).

set_item(Container, Key, Val, Out) :-
    is_dict(Container), !, (string(Key) -> atom_string(A, Key) ; A = Key), put_dict(A, Container, Val, Out).
set_item(List, Index, Val, Out) :-
    nth0(Index, List, _, Rest),
    nth0(Index, Out, Val, Rest).

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

math_pi(P) :- P is 3.141592653589793.
math_e(E) :- E is 2.718281828459045.
math_sqrt(X, R) :- R is sqrt(X).
math_pow(X, Y, R) :- R is X ** Y.
math_sin(X, R) :- R is sin(X).
math_log(X, R) :- R is log(X).

:- initialization(main, main).
main :-
    dict_create(_V0, map, [inv_item_sk-1, inv_warehouse_sk-1, inv_date_sk-1, inv_quantity_on_hand-10]),
    dict_create(_V1, map, [inv_item_sk-1, inv_warehouse_sk-1, inv_date_sk-2, inv_quantity_on_hand-10]),
    dict_create(_V2, map, [inv_item_sk-1, inv_warehouse_sk-1, inv_date_sk-3, inv_quantity_on_hand-250]),
    Inventory = [_V0, _V1, _V2],
    dict_create(_V3, map, [i_item_sk-1]),
    Item = [_V3],
    dict_create(_V4, map, [w_warehouse_sk-1, w_warehouse_name-"W1"]),
    Warehouse = [_V4],
    dict_create(_V5, map, [d_date_sk-1, d_year-2000, d_moy-1]),
    dict_create(_V6, map, [d_date_sk-2, d_year-2000, d_moy-2]),
    dict_create(_V7, map, [d_date_sk-3, d_year-2000, d_moy-3]),
    Date_dim = [_V5, _V6, _V7],
    findall(_V21, (member(Inv, Inventory), member(D, Date_dim), get_item(Inv, 'inv_date_sk', _V8), get_item(D, 'd_date_sk', _V9), (_V8 == _V9), member(I, Item), get_item(Inv, 'inv_item_sk', _V10), get_item(I, 'i_item_sk', _V11), (_V10 == _V11), member(W, Warehouse), get_item(Inv, 'inv_warehouse_sk', _V12), get_item(W, 'w_warehouse_sk', _V13), (_V12 == _V13), get_item(D, 'd_year', _V14), (_V14 == 2000), get_item(W, 'w_warehouse_sk', _V15), get_item(I, 'i_item_sk', _V16), get_item(D, 'd_moy', _V17), dict_create(_V18, map, [w-_V15, i-_V16, month-_V17]), _V19 = _V18, dict_create(_V20, map, ['Inv'-Inv, 'D'-D, 'I'-I, 'W'-W]), _V21 = _V19-_V20), _V22),
    group_pairs(_V22, [], _V23),
    findall(_V33, (member(G, _V23), get_item(G, 'key', _V24), get_item(_V24, 'w', _V25), get_item(G, 'key', _V26), get_item(_V26, 'i', _V27), findall(_V29, (member(X, G), true, get_item(X, 'inv_quantity_on_hand', _V28), _V29 = _V28), _V30), sum(_V30, _V31), dict_create(_V32, map, [w-_V25, i-_V27, qty-_V31]), _V33 = _V32), _V34),
    Monthly = _V34,
    dict_create(_V35, map, []),
    nb_setval(grouped, _V35),
    catch(
        (
            member(M, Monthly),
                catch(
                    (
                        get_item(M, 'w', _V36),
                        get_item(M, 'i', _V37),
                        dict_create(_V38, map, [w-_V36, i-_V37]),
                        term_string(_V38, _V39),
                        Key = _V39,
                        nb_getval(grouped, _V40),
                        contains(_V40, Key, _V41),
                        (_V41 \= nil ->
                            nb_getval(grouped, _V42),
                            get_item(_V42, Key, _V43),
                            G = _V43,
                            get_item(G, 'w', _V44),
                            get_item(G, 'i', _V45),
                            get_item(G, 'qtys', _V46),
                            get_item(M, 'qty', _V47),
                            append(_V46, [_V47], _V48),
                            dict_create(_V49, map, [w-_V44, i-_V45, qtys-_V48]),
                            set_item(grouped, Key, _V49, _V50),
                            nb_setval(grouped, _V50),
                            true
                        ;
                            get_item(M, 'w', _V51),
                            get_item(M, 'i', _V52),
                            get_item(M, 'qty', _V53),
                            dict_create(_V54, map, [w-_V51, i-_V52, qtys-[_V53]]),
                            set_item(grouped, Key, _V54, _V55),
                            nb_setval(grouped, _V55),
                            true
                        ),
                        true
                    ), continue, true),
                    fail
                ; true
            ), break, true),
            nb_setval(summary, []),
            catch(
                (
                    nb_getval(grouped, _V56),
                    dict_pairs(_V56, _, _V57),
                    findall(V, member(_-V, _V57), _V58),
                    member(G, _V58),
                        catch(
                            (
                                get_item(G, 'qtys', _V59),
                                avg(_V59, _V60),
                                Mean is _V60,
                                _V61 is 0,
                                nb_setval(sumsq, _V61),
                                catch(
                                    (
                                        get_item(G, 'qtys', _V62),
                                        member(Q, _V62),
                                            catch(
                                                (
                                                    nb_getval(sumsq, _V63),
                                                    _V64 is (_V63 + ((Q - Mean) * (Q - Mean))),
                                                    nb_setval(sumsq, _V64),
                                                    true
                                                ), continue, true),
                                                fail
                                            ; true
                                        ), break, true),
                                        nb_getval(sumsq, _V65),
                                        get_item(G, 'qtys', _V66),
                                        len_any(_V66, _V67),
                                        Variance is (_V65 / (_V67 - 1)),
                                        math_sqrt(Variance, _V68),
                                        Cov is (_V68 / Mean),
                                        ((Cov > 1.5) ->
                                            nb_getval(summary, _V69),
                                            get_item(G, 'w', _V70),
                                            get_item(G, 'i', _V71),
                                            dict_create(_V72, map, [w_warehouse_sk-_V70, i_item_sk-_V71, cov-Cov]),
                                            append(_V69, [_V72], _V73),
                                            nb_setval(summary, _V73),
                                            true
                                        ; true
                                        ),
                                        true
                                    ), continue, true),
                                    fail
                                ; true
                            ), break, true),
                            nb_getval(summary, _V74),
                            json_write_dict(current_output, _V74), nl,
                            true,
                            nb_getval(summary, _V75),
                            dict_create(_V76, map, [w_warehouse_sk-1, i_item_sk-1, cov-1.539600717839002]),
                            expect((_V75 == [_V76])),
                            true.
