// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:35:01Z
String listStr(List<int> xs) {
  var s = '[';
  num i = 0;
  while ((i as num) < xs.length) {
    s = s + xs[i].toString();
    if ((i as num) < xs.length - 1) {
      s = s + ' ';
    }
    i = (i as num) + 1;
  }
  s = s + ']';
  return s;
}

String llStr(List<List<int>> lst) {
  var s = '[';
  num i = 0;
  while ((i as num) < lst.length) {
    s = s + listStr(lst[i]);
    if ((i as num) < lst.length - 1) {
      s = s + ' ';
    }
    i = (i as num) + 1;
  }
  s = s + ']';
  return s;
}

List<int> concat(List<int> a, List<int> b) {
  List<int> out = [];
  for (var v in a) {
    out = List.from(out)..add(v);
  }
  for (var v in b) {
    out = List.from(out)..add(v);
  }
  return out;
}

List<List<int>> cartN(any lists) {
  if (lists == null) {
    return [];
  }
  var a = (lists as List<List<int>>);
  if (a.length == 0) {
    return [
      [],
    ];
  }
  List<List<int>> out = [];
  var rest = cartN(((a is String) ? a.substring(1, a.length) : (a as List).sublist(1, a.length)));
  var _iter0 = a[0];
  for (var x in (_iter0 is Map ? (_iter0 as Map).keys : _iter0) as Iterable) {
    var _iter1 = rest;
    for (var p in (_iter1 is Map ? (_iter1 as Map).keys : _iter1) as Iterable) {
      out = List.from(out)..add(concat([x], p));
    }
  }
  return out;
}

void _main() {
  print(llStr(cartN([
    [1, 2],
    [3, 4],
  ])));
  print(llStr(cartN([
    [3, 4],
    [1, 2],
  ])));
  print(llStr(cartN([
    [1, 2],
    [],
  ])));
  print(llStr(cartN([
    [],
    [1, 2],
  ])));
  print('');
  print('[');
  for (var p in cartN([
    [1776, 1789],
    [7, 12],
    [4, 14, 23],
    [0, 1],
  ])) {
    print(' ' + listStr(p));
  }
  print(']');
  print(llStr(cartN([
    [1, 2, 3],
    [30],
    [500, 100],
  ])));
  print(llStr(cartN([
    [1, 2, 3],
    [],
    [500, 100],
  ])));
  print('');
  print(llStr(cartN(null)));
  print(llStr(cartN([])));
}

void main() {
  _main();
}
