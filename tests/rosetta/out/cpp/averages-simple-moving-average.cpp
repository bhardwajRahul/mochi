// Generated by Mochi compiler v0.10.26 on 2025-07-16T09:21:08Z
#include <iostream>
#include <string>
#include <vector>

int indexOf(std::string s, std::string ch) {
  auto i = 0;
  while ((i < s.size())) {
    if ((std::string(s).substr(i, ((i + 1)) - (i)) == ch)) {
      return i;
    }
    i = (i + 1);
  }
  return -1;
}

std::string fmt3(float x) {
  auto y = (std::stoi(((((x * 1000)) + 0.5))) / 1000);
  auto s = std::to_string(y);
  auto dot = indexOf(s, std::string("."));
  if ((dot == -1)) {
    s = (s + std::string(".000"));
  } else {
    auto decs = ((s.size() - dot) - 1);
    if ((decs > 3)) {
      s = std::string(s).substr(0, ((dot + 4)) - (0));
    } else {
      while ((decs < 3)) {
        s = (s + std::string("0"));
        decs = (decs + 1);
      }
    }
  }
  return s;
}

std::string pad(std::string s, int width) {
  auto out = s;
  while ((out.size() < width)) {
    out = (std::string(" ") + out);
  }
  return out;
}

auto smaSeries(auto xs, int period) {
  auto res = std::vector<int>{};
  auto sum = 0;
  auto i = 0;
  while ((i < xs.size())) {
    sum = (sum + xs[i]);
    if ((i >= period)) {
      sum = (sum - xs[(i - period)]);
    }
    auto denom = (i + 1);
    if ((denom > period)) {
      denom = period;
    }
    res.push_back((sum / (denom)));
    i = (i + 1);
  }
  return res;
}

auto main() {
  std::vector<int> xs = {1, 2, 3, 4, 5, 5, 4, 3, 2, 1};
  auto sma3 = smaSeries(xs, 3);
  auto sma5 = smaSeries(xs, 5);
  std::cout << std::string("x       sma3   sma5") << std::endl;
  auto i = 0;
  while ((i < xs.size())) {
    auto line =
        ((((pad(fmt3(xs[i]), 5) + std::string("  ")) + pad(fmt3(sma3[i]), 5)) +
          std::string("  ")) +
         pad(fmt3(sma5[i]), 5));
    std::cout << line << std::endl;
    i = (i + 1);
  }
}

int main() {
  main();
  return 0;
}
