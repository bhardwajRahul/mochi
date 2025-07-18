// Generated by Mochi compiler v0.10.27 on 2025-07-17T11:53:04Z
import 'dart:io';

var nums = [1, 2];

var letters = ['A', 'B'];

var bools = [true, false];

var combos = (() {
  var _q0 = <dynamic>[];
  for (var n in nums) {
    for (var l in letters) {
      for (var b in bools) {
        _q0.add({'n': n, 'l': l, 'b': b});
      }
    }
  }
  return _q0;
})();

void main() {
  print('--- Cross Join of three lists ---');
  for (var c in combos) {
    _print([c['n'], c['l'], c['b']]);
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
