% Generated by Mochi transpiler 2025-07-19 12:54:21 UTC
:- style_check(-singleton).
substring(S,I,J,R) :- Len is J - I, sub_string(S, I, Len, _, R).
:- initialization(main).

main :-
    write('hello'), nl.
