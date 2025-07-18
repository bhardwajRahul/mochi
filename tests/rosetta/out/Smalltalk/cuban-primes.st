" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| modPow result b e isPrime p d s a x r passed commatize i pad out join res formatRow padded main cubans cube1 count cube100k j cube2 diff row slice k |
Object subclass: #BreakSignal instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' category: nil!.
Object subclass: #ContinueSignal instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' category: nil!.
modPow := [:base :exp :m | result := (1 % m).
b := (base % m).
e := exp.
[(e > 0)] whileTrue: [.
((((e % 2)) = 1)) ifTrue: [
result := (((result * b)) % m).
] .
b := (((b * b)) % m).
e := (e / 2) asInteger.
].
.
result. ].
isPrime := [:n | ((n < 2)) ifTrue: [
false.
] .
{2. 3. 5. 7. 11. 13. 17. 19. 23. 29} do: [:p |.
((((n % p)) = 0)) ifTrue: [
(n = p).
] .
].
.
d := (n - 1).
s := 0.
[(((d % 2)) = 0)] whileTrue: [.
d := (d / 2).
s := (s + 1).
].
.
[.
{2. 325. 9375. 28178. 450775. 9780504. 1795265022} do: [:a |.
[.
((((a % n)) = 0)) ifTrue: [
true.
] .
x := modPow value: a value: d value: n.
((((x = 1)) or: [((x = ((n - 1))))])) ifTrue: [
ContinueSignal signal.
] .
r := 1.
passed := false.
[.
[(r < s)] whileTrue: [.
x := (((x * x)) % n).
((x = ((n - 1)))) ifTrue: [
passed := true.
BreakSignal signal.
] .
r := (r + 1).
].
] on: BreakSignal do: [:ex | ].
(passed not) ifTrue: [
false.
] .
] on: ContinueSignal do: [:ex | ].
].
] on: BreakSignal do: [:ex | ].
true. ].
commatize := [:n | s := (n asString).
i := (((s size)) - 3).
[(i > 0)] whileTrue: [.
s := (((((s copyFrom: 0 to: i)) + ',')) + ((s copyFrom: i to: (s size)))).
i := (i - 3).
].
.
s. ].
pad := [:s :width | out := s.
[(((out size)) < width)] whileTrue: [.
out := ((' ') + out).
].
.
out. ].
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
formatRow := [:row | padded := {}.
i := 0.
[(i < ((row size)))] whileTrue: [.
padded := padded copyWith: pad value: row at: i value: 9.
i := (i + 1).
].
.
((('[' + (join value: padded value: ' '))) + ']'). ].
main := [ cubans := {}.
cube1 := 1.
count := 0.
cube100k := 0.
i := 1.
[.
[true] whileTrue: [.
j := (i + 1).
cube2 := (((j * j)) * j).
diff := (cube2 - cube1).
(isPrime value: diff) ifTrue: [
((count < 200)) ifTrue: [
cubans := cubans copyWith: commatize value: diff.
] .
count := (count + 1).
((count = 100000)) ifTrue: [
cube100k := diff.
BreakSignal signal.
] .
] .
cube1 := cube2.
i := (i + 1).
].
] on: BreakSignal do: [:ex | ].
Transcript show: 'The first 200 cuban primes are:-'; cr.
row := 0.
[(row < 20)] whileTrue: [.
slice := {}.
k := 0.
[(k < 10)] whileTrue: [.
slice := slice copyWith: cubans at: (((row * 10)) + k).
k := (k + 1).
].
.
Transcript show: (formatRow value: slice) printString; cr.
row := (row + 1).
].
.
Transcript show: ((('
The 100,000th cuban prime is ') + (commatize value: cube100k))) printString; cr. ].
main value.
