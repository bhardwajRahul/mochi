// Generated by Mochi compiler v0.10.26 on 2025-07-16T09:21:07Z
#include <iostream>
#include <string>

int pow_int(int base, int exp) {
  auto result = 1;
  auto b = base;
  auto e = exp;
  while ((e > 0)) {
    if (((e % 2) == 1)) {
      result = (result * b);
    }
    b = (b * b);
    e = std::stoi(((e / 2)));
  }
  return result;
}

bigint pow_big(bigint base, int exp) {
  bigint result = 1;
  bigint b = base;
  auto e = exp;
  while ((e > 0)) {
    if (((e % 2) == 1)) {
      result = (result * b);
    }
    b = (b * b);
    e = std::stoi(((e / 2)));
  }
  return result;
}

int main() {
  auto e1 = pow_int(3, 2);
  auto e2 = pow_int(4, e1);
  bigint base = 5;
  bigint x = pow_big(base, e2);
  auto s = std::to_string(x);
  {
    std::cout << std::string("5^(4^(3^2)) has");
    std::cout << ' ';
    std::cout << s.size();
    std::cout << ' ';
    std::cout << std::string("digits:");
    std::cout << ' ';
    std::cout << std::string(s).substr(0, (20) - (0));
    std::cout << ' ';
    std::cout << std::string("...");
    std::cout << ' ';
    std::cout << std::string(s).substr((s.size() - 20),
                                       (s.size()) - ((s.size() - 20)));
    std::cout << std::endl;
  }
  return 0;
}
