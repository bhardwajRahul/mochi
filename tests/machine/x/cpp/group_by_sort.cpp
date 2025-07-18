// Generated by Mochi compiler v0.10.28 on 2025-07-18T08:12:15Z
#include <algorithm>
#include <iostream>
#include <map>
#include <numeric>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

template <typename T> void __json(const T &);
inline void __json(int v) { std::cout << v; }
inline void __json(double v) { std::cout << v; }
inline void __json(bool v) { std::cout << (v ? "true" : "false"); }
inline void __json(const std::string &v) { std::cout << "\"" << v << "\""; }
inline void __json(const char *v) { std::cout << "\"" << v << "\""; }
template <typename T> void __json(const std::vector<T> &v) {
  std::cout << "[";
  bool first = true;
  for (const auto &x : v) {
    if (!first)
      std::cout << ", ";
    first = false;
    __json(x);
  }
  std::cout << "]";
}
template <typename K, typename V> void __json(const std::map<K, V> &m) {
  std::cout << "{";
  bool first = true;
  for (const auto &kv : m) {
    if (!first)
      std::cout << ",";
    first = false;
    __json(kv.first);
    std::cout << ":";
    __json(kv.second);
  }
  std::cout << "}";
}
template <typename K, typename V>
void __json(const std::unordered_map<K, V> &m) {
  std::cout << "{";
  bool first = true;
  for (const auto &kv : m) {
    if (!first)
      std::cout << ",";
    first = false;
    __json(kv.first);
    std::cout << ":";
    __json(kv.second);
  }
  std::cout << "}";
}

struct Item {
  std::string cat;
  int val;
};
struct __struct2 {
  decltype(std::declval<Item>().cat) key;
  std::vector<Item> items;
};
struct Grouped {
  decltype(std::declval<__struct2>().key) cat;
  double total;
};
inline void __json(const Grouped &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"cat\":";
  __json(v.cat);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"total\":";
  __json(v.total);
  std::cout << "}";
}
inline void __json(const Item &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"cat\":";
  __json(v.cat);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"val\":";
  __json(v.val);
  std::cout << "}";
}
int main() {
  std::vector<Item> items = {
      Item{std::string("a"), 3}, Item{std::string("a"), 1},
      Item{std::string("b"), 5}, Item{std::string("b"), 2}};
  std::vector<Grouped> grouped = ([&]() {
    std::vector<__struct2> __groups;
    for (auto i : items) {
      auto __key = i.cat;
      bool __found = false;
      for (auto &__g : __groups) {
        if (__g.key == __key) {
          __g.items.push_back(i);
          __found = true;
          break;
        }
      }
      if (!__found) {
        __groups.push_back(__struct2{__key, std::vector<Item>{i}});
      }
    }
    std::vector<std::pair<double, Grouped>> __items;
    for (auto &g : __groups) {
      __items.push_back({(-([&](auto v) {
                           return std::accumulate(v.begin(), v.end(), 0.0);
                         })(([&]() {
                           std::vector<int> __items;
                           for (auto x : g.items) {
                             __items.push_back(x.val);
                           }
                           return __items;
                         })())),
                         Grouped{g.key, ([&](auto v) {
                                   return std::accumulate(v.begin(), v.end(),
                                                          0.0);
                                 })(([&]() {
                                   std::vector<int> __items;
                                   for (auto x : g.items) {
                                     __items.push_back(x.val);
                                   }
                                   return __items;
                                 })())}});
    }
    std::sort(__items.begin(), __items.end(),
              [](auto &a, auto &b) { return a.first < b.first; });
    std::vector<Grouped> __res;
    for (auto &p : __items)
      __res.push_back(p.second);
    return __res;
  })();
  std::cout << "[";
  for (size_t i = 0; i < grouped.size(); ++i) {
    if (i)
      std::cout << ", ";
    __json(grouped[i]);
  }
  std::cout << "]" << std::endl;
  return 0;
}
