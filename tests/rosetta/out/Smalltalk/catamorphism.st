" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| add sub mul fold r i n |
add := [:a :b | (a + b). ].
sub := [:a :b | (a - b). ].
mul := [:a :b | (a * b). ].
fold := [:f :xs | r := xs at: 0.
i := 1.
[(i < ((xs size)))] whileTrue: [.
r := f value: r value: xs at: i.
i := (i + 1).
].
.
r. ].
n := {1. 2. 3. 4. 5}.
Transcript show: (fold value: [:a :b | add value: a value: b ] value: n) printString; cr.
Transcript show: (fold value: [:a :b | sub value: a value: b ] value: n) printString; cr.
Transcript show: (fold value: [:a :b | mul value: a value: b ] value: n) printString; cr.
