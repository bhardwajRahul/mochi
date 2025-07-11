| data sorted |
data := {Dictionary newFrom:{'a'->1. 'b'->2}. Dictionary newFrom:{'a'->1. 'b'->1}. Dictionary newFrom:{'a'->0. 'b'->5}}.
sorted := [ | tmp |
  tmp := OrderedCollection new.
  data do: [:x |
    tmp add: x.
  ].
  tmp := tmp asSortedCollection: [:a :b | Dictionary newFrom:{'a'->a at: 'a'. 'b'->a at: 'b'} < Dictionary newFrom:{'a'->b at: 'a'. 'b'->b at: 'b'}].
  tmp
] value.
Transcript show: (sorted) printString; cr.
