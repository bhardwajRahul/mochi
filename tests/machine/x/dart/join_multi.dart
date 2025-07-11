var customers = [
  {'id': 1, 'name': 'Alice'},
  {'id': 2, 'name': 'Bob'},
];

var orders = [
  {'id': 100, 'customerId': 1},
  {'id': 101, 'customerId': 2},
];

var items = [
  {'orderId': 100, 'sku': 'a'},
  {'orderId': 101, 'sku': 'b'},
];

var result = (() {
  var _q0 = <dynamic>[];
  for (var o in orders) {
    for (var c in customers) {
      if (!(o['customerId'] == c['id'])) continue;
      for (var i in items) {
        if (!(o['id'] == i['orderId'])) continue;
        _q0.add({'name': c['name'], 'sku': i['sku']});
      }
    }
  }
  return _q0;
})();

void main() {
  print('--- Multi Join ---');
  for (var r in result) {
    print([r['name'], 'bought item', r['sku']].join(' '));
  }
}
