// Generated by Mochi compiler v0.10.27 on 2025-07-17T11:53:04Z
var x = 2;

var label = ((() {
  var _t = x;
  if (_t == 1) {
    return 'one';
  } else if (_t == 2) {
    return 'two';
  } else if (_t == 3) {
    return 'three';
  }  else {
    return 'unknown';
  }
})() as dynamic);

void main() {
  print(label);
}
