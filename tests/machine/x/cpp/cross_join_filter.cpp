// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
#include <iostream>
#include <string>
#include <vector>

struct Pair {
  int n;
  std::string l;
};
int main() {
  std::vector<int> nums = {1, 2, 3};
  std::vector<std::string> letters = {std::string("A"), std::string("B")};
  std::vector<Pair> pairs = ([&]() {
    std::vector<Pair> __items;
    for (auto n : nums) {
      for (auto l : letters) {
        if (!(((n % 2) == 0)))
          continue;
        __items.push_back(Pair{n, l});
      }
    }
    return __items;
  })();
  std::cout << std::string("--- Even pairs ---") << std::endl;
  for (auto p : pairs) {
    {
      std::cout << p.n;
      std::cout << ' ';
      std::cout << p.l;
      std::cout << std::endl;
    }
  }
  return 0;
}
