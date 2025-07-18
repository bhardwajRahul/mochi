" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| split parts cur i join res repeat out parseIntStr neg n digits toBinary b val binToInt padRight canonicalize dotted size binParts p binary canonParts tests t |
split := [:s :sep | parts := {}.
cur := ''.
i := 0.
[(i < ((s size)))] whileTrue: [.
((((((((sep size)) > 0)) and: [((((i + ((sep size)))) <= ((s size))))])) and: [((((s copyFrom: i to: (i + ((sep size))))) = sep))])) ifTrue: [
parts := parts copyWith: cur.
cur := ''.
i := (i + ((sep size))).
] ifFalse: [
cur := (cur + (s copyFrom: (i + 1) to: (i + 1))).
i := (i + 1).
].
].
.
parts := parts copyWith: cur.
parts. ].
join := [:xs :sep | res := ''.
i := 0.
[(i < ((xs size)))] whileTrue: [.
((i > 0)) ifTrue: [
res := (res + sep).
] .
res := (res + (xs at: i)).
i := (i + 1).
].
.
res. ].
repeat := [:ch :n | out := ''.
i := 0.
[(i < n)] whileTrue: [.
out := (out + ch).
i := (i + 1).
].
.
out. ].
parseIntStr := [:str | i := 0.
neg := false.
((((((str size)) > 0)) and: [(((str copyFrom: (0 + 1) to: 1) = '-'))])) ifTrue: [
neg := true.
i := 1.
] .
n := 0.
digits := Dictionary from:{'0'->0. '1'->1. '2'->2. '3'->3. '4'->4. '5'->5. '6'->6. '7'->7. '8'->8. '9'->9}.
[(i < ((str size)))] whileTrue: [.
n := (((n * 10)) + (digits at: str copyFrom: (i + 1) to: (i + 1))).
i := (i + 1).
].
.
(neg) ifTrue: [
n := -n.
] .
n. ].
toBinary := [:n :bits | b := ''.
val := n.
i := 0.
[(i < bits)] whileTrue: [.
b := ((((val % 2) asString)) + b).
val := (val / 2) asInteger.
i := (i + 1).
].
.
b. ].
binToInt := [:bits | n := 0.
i := 0.
[(i < ((bits size)))] whileTrue: [.
n := (((n * 2)) + (parseIntStr value: bits copyFrom: (i + 1) to: (i + 1))).
i := (i + 1).
].
.
n. ].
padRight := [:s :width | out := s.
[(((out size)) < width)] whileTrue: [.
out := (out + (' ')).
].
.
out. ].
canonicalize := [:cidr | parts := split value: cidr value: '/'.
dotted := parts at: 0.
size := parseIntStr value: parts at: 1.
binParts := {}.
split value: dotted value: '.' do: [:p |.
binParts := binParts copyWith: toBinary value: parseIntStr value: p value: 8.
].
.
binary := join value: binParts value: ''.
binary := ((binary copyFrom: (0 + 1) to: size) + (repeat value: '0' value: (32 - size))).
canonParts := {}.
i := 0.
[(i < ((binary size)))] whileTrue: [.
canonParts := canonParts copyWith: (binToInt value: binary copyFrom: (i + 1) to: (i + 8) asString).
i := (i + 8).
].
.
((((join value: canonParts value: '.') + '/')) + (parts at: 1)). ].
tests := {'87.70.141.1/22'. '36.18.154.103/12'. '62.62.197.11/29'. '67.137.119.181/4'. '161.214.74.21/24'. '184.232.176.184/18'}.
tests do: [:t |.
Transcript show: (((((padRight value: t value: 18) + (' -> '))) + (canonicalize value: t))) printString; cr.
].
.
