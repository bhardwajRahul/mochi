var nums = [1, 2, 3];

var result = (() {
  var _q0 = <dynamic>[];
  for (var n in nums) {
    if (!(n > 1)) continue;
    _q0.add(n);
  }
  return _q0.reduce((a, b) => a + b);
})();

void main() {
  print(result);
}
