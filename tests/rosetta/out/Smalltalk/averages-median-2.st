" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| sel i minIndex j tmp median arr half med |
sel := [:list :k | i := 0.
[(i <= k)] whileTrue: [.
minIndex := i.
j := (i + 1).
[(j < ((list size)))] whileTrue: [.
(((list at: j) < (list at: minIndex))) ifTrue: [
minIndex := j.
] .
j := (j + 1).
].
.
tmp := list at: i.
list at: i put: list at: minIndex.
list at: minIndex put: tmp.
i := (i + 1).
].
.
list at: k. ].
median := [:a | arr := a.
half := (((arr size)) / 2) asInteger.
med := sel value: arr value: half.
((((((arr size)) % 2)) = 0)) ifTrue: [
(((med + (arr at: (half - 1)))) / 2).
] .
med. ].
Transcript show: ((median value: {3. 1. 4. 1} asString)) printString; cr.
Transcript show: ((median value: {3. 1. 4. 1. 5} asString)) printString; cr.
