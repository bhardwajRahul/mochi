// Generated by Mochi compiler v0.10.28 on 2025-07-18T03:32:16Z
import 'dart:io';
import 'dart:convert';

var lineitem = [
  {
  'l_extendedprice': 1000,
  'l_discount': 0.06,
  'l_shipdate': '1994-02-15',
  'l_quantity': 10,
},
  {
  'l_extendedprice': 500,
  'l_discount': 0.07,
  'l_shipdate': '1994-03-10',
  'l_quantity': 23,
},
  {
  'l_extendedprice': 400,
  'l_discount': 0.04,
  'l_shipdate': '1994-04-10',
  'l_quantity': 15,
},
  {
  'l_extendedprice': 200,
  'l_discount': 0.06,
  'l_shipdate': '1995-01-01',
  'l_quantity': 5,
},
];

var result = (() {
  var _q0 = <dynamic>[];
  for (var l in lineitem) {
    if (!((l['l_shipdate'].toString().compareTo('1994-01-01'.toString()) >= 0) && (l['l_shipdate'].toString().compareTo('1995-01-01'.toString()) < 0) && ((l['l_discount'] as num) >= 0.05) && ((l['l_discount'] as num) <= 0.07) && ((l['l_quantity'] as num) < 24))) continue;
    _q0.add((l['l_extendedprice'] as num) * (l['l_discount'] as num));
  }
  return _sum(_q0);
})();

void main() {
  print(jsonEncode(result));
}

dynamic _min(dynamic v) {
    List<dynamic>? list;
    if (v is List) list = v;
    else if (v is Map && v['items'] is List) list = (v['items'] as List);
    else if (v is Map && v['Items'] is List) list = (v['Items'] as List);
    else { try { var it = (v as dynamic).items; if (it is List) list = it; } catch (_) {} }
    if (list == null || list.isEmpty) return 0;
    var m = list[0];
    for (var n in list) { if ((n as Comparable).compareTo(m) < 0) m = n; }
    return m;
}

num _sum(dynamic v) {
    Iterable<dynamic>? list;
    if (v is Iterable) list = v;
    else if (v is Map && v['items'] is Iterable) list = (v['items'] as Iterable);
    else if (v is Map && v['Items'] is Iterable) list = (v['Items'] as Iterable);
    else { try { var it = (v as dynamic).items; if (it is Iterable) list = it; } catch (_) {} }
    if (list == null) return 0;
    num s = 0;
    for (var n in list) s += (n as num);
    return s;
}
