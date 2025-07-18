// Generated by Mochi compiler v0.10.26 on 2025-07-16T09:21:07Z
#include <iostream>

float abs(float x) {
  if ((x < 0)) {
    return (-x);
  }
  return x;
}

float sqrtApprox(float x) {
  auto guess = x;
  auto i = 0;
  while ((i < 20)) {
    guess = (((guess + (x / guess))) / 2);
    i = (i + 1);
  }
  return guess;
}

float agmPi() {
  auto a = 1;
  auto g = (1 / sqrtApprox(2));
  auto sum = 0;
  auto pow = 2;
  while ((abs((a - g)) > 1e-15)) {
    auto t = (((a + g)) / 2);
    auto u = sqrtApprox((a * g));
    a = t;
    g = u;
    pow = (pow * 2);
    auto diff = ((a * a) - (g * g));
    sum = (sum + (diff * pow));
  }
  auto pi = (((4 * a) * a) / ((1 - sum)));
  return pi;
}

auto main() { std::cout << std::to_string(agmPi()) << std::endl; }

int main() {
  main();
  return 0;
}
