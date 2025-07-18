" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| gcd x y t parseRational intPart fracPart denom afterDot i ch d num g main inputs s r |
gcd := [:a :b | x := a.
((x < 0)) ifTrue: [
x := -x.
] .
y := b.
((y < 0)) ifTrue: [
y := -y.
] .
[(y ~= 0)] whileTrue: [.
t := (x % y).
x := y.
y := t.
].
.
x. ].
parseRational := [:s | intPart := 0.
fracPart := 0.
denom := 1.
afterDot := false.
i := 0.
[(i < ((s size)))] whileTrue: [.
ch := (s copyFrom: i to: (i + 1)).
((ch = '.')) ifTrue: [
afterDot := true.
] ifFalse: [
d := ((int value: ch) - (int value: '0')).
(afterDot not) ifTrue: [
intPart := (((intPart * 10)) + d).
] ifFalse: [
fracPart := (((fracPart * 10)) + d).
denom := (denom * 10).
].
].
i := (i + 1).
].
.
num := (((intPart * denom)) + fracPart).
g := gcd value: num value: denom.
Dictionary from:{'num'->((num / g) asInteger). 'den'->((denom / g) asInteger)}. ].
main := [ inputs := {'0.9054054'. '0.518518'. '0.75'}.
inputs do: [:s |.
r := parseRational value: s.
Transcript show: ((((((((s + (' = '))) + ((r at: 'num' asString)))) + '/')) + ((r at: 'den' asString)))) printString; cr.
].
. ].
main value.
