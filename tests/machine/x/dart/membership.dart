bool _in(dynamic item, dynamic col) {
  if (col is Map) return col.containsKey(item);
  if (col is Iterable || col is String) return col.contains(item);
  return false;
}

var nums = [1, 2, 3];

void main() {
  print(_in(2, nums));
  print(_in(4, nums));
}
