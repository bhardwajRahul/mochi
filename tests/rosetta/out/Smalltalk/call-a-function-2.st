" Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
"
| f g h main res |
f := [ {0. 0}. ].
g := [:a :b | 0. ].
h := [:s :nums |  ].
main := [ f value.
g value: 1 value: 2.
res := f value.
g value: res at: 0 value: res at: 1.
g value: g value: 1 value: 2 value: 3. ].
main value.
