" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| poolPut poolGet idx v clearPool main pool i j res1 res2 res3 res4 |
poolPut := [:p :x | p copyWith: x. ].
poolGet := [:p | ((((p size)) = 0)) ifTrue: [
Transcript show: 'pool empty'; cr.
Dictionary from:{'pool'->p. 'val'->0}.
] .
idx := (((p size)) - 1).
v := p at: idx.
p := p copyFrom: (0 + 1) to: idx.
Dictionary from:{'pool'->p. 'val'->v}. ].
clearPool := [:p | {}. ].
main := [ pool := {}.
i := 1.
j := 2.
Transcript show: (((i + j) asString)) printString; cr.
pool := poolPut value: pool value: i.
pool := poolPut value: pool value: j.
i := 0.
j := 0.
res1 := poolGet value: pool.
pool := res1 at: 'pool'.
i := res1 at: 'val' asInteger.
res2 := poolGet value: pool.
pool := res2 at: 'pool'.
j := res2 at: 'val' asInteger.
i := 4.
j := 5.
Transcript show: (((i + j) asString)) printString; cr.
pool := poolPut value: pool value: i.
pool := poolPut value: pool value: j.
i := 0.
j := 0.
pool := clearPool value: pool.
res3 := poolGet value: pool.
pool := res3 at: 'pool'.
i := res3 at: 'val' asInteger.
res4 := poolGet value: pool.
pool := res4 at: 'pool'.
j := res4 at: 'val' asInteger.
i := 7.
j := 8.
Transcript show: (((i + j) asString)) printString; cr. ].
main value.
