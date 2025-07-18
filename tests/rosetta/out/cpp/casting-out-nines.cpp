// Generated by Mochi compiler v0.10.26 on 2025-07-16T09:21:12Z
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

int parseIntBase(std::string s, int base) {
  auto digits = std::string("0123456789abcdefghijklmnopqrstuvwxyz");
  auto n = 0;
  auto i = 0;
  while ((i < s.size())) {
    auto j = 0;
    auto v = 0;
    while ((j < digits.size())) {
      if ((std::string(digits).substr(j, ((j + 1)) - (j)) ==
           std::string(s).substr(i, ((i + 1)) - (i)))) {
        v = j;
        break;
      }
      j = (j + 1);
    }
    n = ((n * base) + v);
    i = (i + 1);
  }
  return n;
}

std::string intToBase(int n, int base) {
  auto digits = std::string("0123456789abcdefghijklmnopqrstuvwxyz");
  if ((n == 0)) {
    return std::string("0");
  }
  auto out = std::string("");
  auto v = n;
  while ((v > 0)) {
    auto d = (v % base);
    out = (std::string(digits).substr(d, ((d + 1)) - (d)) + out);
    v = (v / base);
  }
  return out;
}

auto subset(int base, std::string begin, std::string end) {
  auto b = parseIntBase(begin, base);
  auto e = parseIntBase(end, base);
  auto out = std::vector<int>{};
  auto k = b;
  while ((k <= e)) {
    auto ks = intToBase(k, base);
    auto mod = (base - 1);
    auto r1 = (parseIntBase(ks, base) % mod);
    auto r2 = (((parseIntBase(ks, base) * parseIntBase(ks, base))) % mod);
    if ((r1 == r2)) {
      out.push_back(ks);
    }
    k = (k + 1);
  }
  return out;
}

int main() {
  std::vector<std::string> testCases =
      std::vector<decltype(std::unordered_map<std::string, decltype(10)>{
          {std::string("base"), 10},
          {std::string("begin"), std::string("1")},
          {std::string("end"), std::string("100")},
          {std::string("kaprekar"),
           std::vector<std::string>{std::string("1"), std::string("9"),
                                    std::string("45"), std::string("55"),
                                    std::string("99")}}})>{
          std::unordered_map<std::string, decltype(10)>{
              {std::string("base"), 10},
              {std::string("begin"), std::string("1")},
              {std::string("end"), std::string("100")},
              {std::string("kaprekar"),
               std::vector<std::string>{std::string("1"), std::string("9"),
                                        std::string("45"), std::string("55"),
                                        std::string("99")}}},
          std::unordered_map<std::string, decltype(17)>{
              {std::string("base"), 17},
              {std::string("begin"), std::string("10")},
              {std::string("end"), std::string("gg")},
              {std::string("kaprekar"),
               std::vector<std::string>{std::string("3d"), std::string("d4"),
                                        std::string("gg")}}}};
  auto idx = 0;
  while ((idx < testCases.size())) {
    auto tc = testCases[idx];
    std::cout << ((((((std::string("\nTest case base = ") +
                       std::to_string(tc[std::string("base")])) +
                      std::string(", begin = ")) +
                     tc[std::string("begin")]) +
                    std::string(", end = ")) +
                   tc[std::string("end")]) +
                  std::string(":"))
              << std::endl;
    auto s = subset(tc[std::string("base")], tc[std::string("begin")],
                    tc[std::string("end")]);
    std::cout << (std::string("Subset:  ") + std::to_string(s)) << std::endl;
    std::cout << (std::string("Kaprekar:") +
                  std::to_string(tc[std::string("kaprekar")]))
              << std::endl;
    auto sx = 0;
    auto valid = true;
    auto i = 0;
    while ((i < tc[std::string("kaprekar")].size())) {
      auto k = tc[std::string("kaprekar")][i];
      auto found = false;
      while ((sx < s.size())) {
        if ((s[sx] == k)) {
          found = true;
          sx = (sx + 1);
          break;
        }
        sx = (sx + 1);
      }
      if ((!found)) {
        std::cout << ((std::string("Fail:") + k) +
                      std::string(" not in subset"))
                  << std::endl;
        valid = false;
        break;
      }
      i = (i + 1);
    }
    if (valid) {
      std::cout << std::string("Valid subset.") << std::endl;
    }
    idx = (idx + 1);
  }
  return 0;
}
