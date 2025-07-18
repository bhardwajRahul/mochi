// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:33:58Z
var PI = 3.141592653589793;

double sinApprox(double x) {
  var term = x;
  var sum = x;
  var n = 1;
  while ((n as num) <= 10) {
    var denom = double.parse((((2 * (n as num)) as num) * (((2 * (n as num) as num) + 1) as num)));
    term = (((-(term as num) as num) * x as num) * x as num) / (denom as num);
    sum = (sum as num) + (term as num);
    n = (n as num) + 1;
  }
  return sum;
}

double cosApprox(double x) {
  var term = 1;
  var sum = 1;
  var n = 1;
  while ((n as num) <= 10) {
    var denom = double.parse(((((2 * (n as num) as num) - 1) as num) * ((2 * (n as num)) as num)));
    term = (((-(term as num) as num) * x as num) * x as num) / (denom as num);
    sum = (sum as num) + (term as num);
    n = (n as num) + 1;
  }
  return sum;
}

var degreesIncr = 0.1 * PI / 180;

var turns = 2;

var stop = 360 * turns * 10 * degreesIncr;

var width = 600;

var centre = width / 2;

var a = 1;

var b = 20;

num theta = 0;

num count = 0;

void main() {
  while (theta < stop) {
    var r = a + b * theta;
    var x = (r as num) * cosApprox(theta);
    var y = (r as num) * sinApprox(theta);
    if (count % 100 == 0) {
      print(centre + (x as num).toString() + ',' + centre - (y as num).toString());
    }
    theta = theta + degreesIncr;
    count = count + 1;
  }
}
