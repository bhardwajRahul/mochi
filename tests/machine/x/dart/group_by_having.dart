// Generated by Mochi compiler v0.10.27 on 2025-07-17T11:53:04Z
import 'dart:convert';

var people = [
  {'name': 'Alice', 'city': 'Paris'},
  {'name': 'Bob', 'city': 'Hanoi'},
  {'name': 'Charlie', 'city': 'Paris'},
  {'name': 'Diana', 'city': 'Hanoi'},
  {'name': 'Eve', 'city': 'Paris'},
  {'name': 'Frank', 'city': 'Hanoi'},
  {'name': 'George', 'city': 'Paris'},
];

var big = (() {
  var _q0 = <dynamic>[];
  var _g1 = <String, List<dynamic>>{};
  for (var p in people) {
    var _k2 = p['city'];
    var _k2_s = jsonEncode(_k2);
    _g1.putIfAbsent(_k2_s, () => <dynamic>[]).add(p);
  }
  for (var entry in _g1.entries) {
    var g = entry.value;
    var _k2 = jsonDecode(entry.key);
    if (!(g.length >= 4)) continue;
    _q0.add({'city': _k2, 'num': g.length});
  }
  return _q0;
})();

void main() {
  print(jsonEncode(big));
}
