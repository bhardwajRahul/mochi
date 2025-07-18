// Generated by Mochi compiler v0.10.27 on 2025-07-17T11:53:04Z
import 'dart:io';

var customers = [
  {'id': 1, 'name': 'Alice'},
  {'id': 2, 'name': 'Bob'},
  {'id': 3, 'name': 'Charlie'},
];

var orders = [
  {'id': 100, 'customerId': 1, 'total': 250},
  {'id': 101, 'customerId': 2, 'total': 125},
  {'id': 102, 'customerId': 1, 'total': 300},
  {'id': 103, 'customerId': 4, 'total': 80},
];

var result = (() {
  var _q0 = <dynamic>[];
  for (var o in orders) {
    for (var c in customers) {
      if (!(o['customerId'] == c['id'])) continue;
      _q0.add({
  'orderId': o['id'],
  'customerName': c['name'],
  'total': o['total'],
});
    }
  }
  return _q0;
})();

void main() {
  print('--- Orders with customer info ---');
  for (var entry in result) {
    _print(['Order', entry['orderId'], 'by', entry['customerName'], '- \$', entry['total']]);
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
