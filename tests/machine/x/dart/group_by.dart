// Generated by Mochi compiler v0.10.27 on 2025-07-17T11:53:04Z
import 'dart:io';
import 'dart:convert';

var people = [
  {'name': 'Alice', 'age': 30, 'city': 'Paris'},
  {'name': 'Bob', 'age': 15, 'city': 'Hanoi'},
  {'name': 'Charlie', 'age': 65, 'city': 'Paris'},
  {'name': 'Diana', 'age': 45, 'city': 'Hanoi'},
  {'name': 'Eve', 'age': 70, 'city': 'Paris'},
  {'name': 'Frank', 'age': 22, 'city': 'Hanoi'},
];

var stats = (() {
  var _q0 = <dynamic>[];
  var _g1 = <String, List<dynamic>>{};
  for (var person in people) {
    var _k4 = person['city'];
    var _k4_s = jsonEncode(_k4);
    _g1.putIfAbsent(_k4_s, () => <dynamic>[]).add(person);
  }
  for (var entry in _g1.entries) {
    var g = entry.value;
    var _k4 = jsonDecode(entry.key);
    _q0.add({
  'city': _k4,
  'count': g.length,
  'avg_age': (() { var _t6 = (() {
  var _q5 = <dynamic>[];
  for (var p in g) {
    _q5.add(p['age']);
  }
  return _q5;
})(); return (_t6.isEmpty ? 0 : _t6.reduce((a, b) => a + b) / _t6.length); })(),
});
  }
  return _q0;
})();

void main() {
  print('--- People grouped by city ---');
  for (var s in stats) {
    _print([s['city'], ': count =', s['count'], ', avg_age =', s['avg_age']]);
  }
}

void _print(List<dynamic> args) {
    for (var i = 0; i < args.length; i++) {
        if (i > 0) stdout.write(' ');
        var v = args[i];
        if (v is List) {
            stdout.write(v.join(' '));
        } else if (v is double && v == v.roundToDouble()) {
            stdout.write(v.toInt());
        } else {
            stdout.write(v);
        }
    }
    stdout.writeln();
}
