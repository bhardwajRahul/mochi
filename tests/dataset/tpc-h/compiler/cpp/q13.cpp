// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
#include <algorithm>
#include <any>
#include <iostream>
#include <map>
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

inline bool __any_eq(const std::any &a, const std::any &b) {
  if (a.type() != b.type())
    return false;
  if (a.type() == typeid(int))
    return std::any_cast<int>(a) == std::any_cast<int>(b);
  if (a.type() == typeid(double))
    return std::any_cast<double>(a) == std::any_cast<double>(b);
  if (a.type() == typeid(bool))
    return std::any_cast<bool>(a) == std::any_cast<bool>(b);
  if (a.type() == typeid(std::string))
    return std::any_cast<std::string>(a) == std::any_cast<std::string>(b);
  return false;
}
inline void __print_any(const std::any &a) {
  if (a.type() == typeid(int))
    std::cout << std::any_cast<int>(a);
  else if (a.type() == typeid(double))
    std::cout << std::any_cast<double>(a);
  else if (a.type() == typeid(bool))
    std::cout << (std::any_cast<bool>(a) ? "true" : "false");
  else if (a.type() == typeid(std::string))
    std::cout << std::any_cast<std::string>(a);
}

struct Order {
  int o_orderkey;
  int o_custkey;
  std::string o_comment;
};
struct Grouped {
  std::any x;
};
struct __struct3 {
  std::any key;
  std::vector<Grouped> items;
};
struct __struct4 {
  std::any c_count;
  int custdist;
};
inline void __json(const __struct4 &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"c_count\":";
  __json(v.c_count);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"custdist\":";
  __json(v.custdist);
  std::cout << "}";
}
inline void __json(const Order &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"o_orderkey\":";
  __json(v.o_orderkey);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"o_custkey\":";
  __json(v.o_custkey);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"o_comment\":";
  __json(v.o_comment);
  std::cout << "}";
}
inline void __json(const Grouped &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"x\":";
  __json(v.x);
  std::cout << "}";
}
int main() {
  auto customer = std::vector<std::any>{
      std::unordered_map<std::string, int>{{std::string("c_custkey"), 1}},
      std::unordered_map<std::string, int>{{std::string("c_custkey"), 2}},
      std::unordered_map<std::string, int>{{std::string("c_custkey"), 3}}};
  std::vector<Order> orders = {
      Order{100, 1, std::string("fast delivery")},
      Order{101, 1, std::string("no comment")},
      Order{102, 2, std::string("special requests only")}};
  auto per_customer = ([&]() {
    std::vector<decltype(std::unordered_map<
                         std::string,
                         decltype((
                             (int)([&]() {
                               std::vector<Order> __items;
                               for (auto o : orders) {
                                 if (!(((((std::declval<Order>().o_custkey ==
                                           c.c_custkey) &&
                                          ((!((std::find(
                                                   std::declval<Order>()
                                                       .o_comment.begin(),
                                                   std::declval<Order>()
                                                       .o_comment.end(),
                                                   std::string("special")) !=
                                               std::declval<Order>()
                                                   .o_comment.end()))))) &&
                                         ((!((std::find(
                                                  std::declval<Order>()
                                                      .o_comment.begin(),
                                                  std::declval<Order>()
                                                      .o_comment.end(),
                                                  std::string("requests")) !=
                                              std::declval<Order>()
                                                  .o_comment.end()))))))))
                                   continue;
                                 __items.push_back(o);
                               }
                               return __items;
                             })()
                                 .size()))>{
        {std::string("c_count"),
         ((int)([&]() {
            std::vector<Order> __items;
            for (auto o : orders) {
              if (!(((((std::declval<Order>().o_custkey == c.c_custkey) &&
                       ((!((std::find(std::declval<Order>().o_comment.begin(),
                                      std::declval<Order>().o_comment.end(),
                                      std::string("special")) !=
                            std::declval<Order>().o_comment.end()))))) &&
                      ((!((std::find(std::declval<Order>().o_comment.begin(),
                                     std::declval<Order>().o_comment.end(),
                                     std::string("requests")) !=
                           std::declval<Order>().o_comment.end()))))))))
                continue;
              __items.push_back(o);
            }
            return __items;
          })()
              .size())}})>
        __items;
    for (auto c : customer) {
      __items.push_back(
          std::unordered_map<
              std::string,
              decltype(((int)([&]() {
                          std::vector<Order> __items;
                          for (auto o : orders) {
                            if (!(((((o.o_custkey == c.c_custkey) &&
                                     ((!((std::find(o.o_comment.begin(),
                                                    o.o_comment.end(),
                                                    std::string("special")) !=
                                          o.o_comment.end()))))) &&
                                    ((!((std::find(o.o_comment.begin(),
                                                   o.o_comment.end(),
                                                   std::string("requests")) !=
                                         o.o_comment.end()))))))))
                              continue;
                            __items.push_back(o);
                          }
                          return __items;
                        })()
                            .size()))>{
              {std::string("c_count"),
               ((int)([&]() {
                  std::vector<Order> __items;
                  for (auto o : orders) {
                    if (!(((((o.o_custkey == c.c_custkey) &&
                             ((!((std::find(o.o_comment.begin(),
                                            o.o_comment.end(),
                                            std::string("special")) !=
                                  o.o_comment.end()))))) &&
                            ((!((std::find(o.o_comment.begin(),
                                           o.o_comment.end(),
                                           std::string("requests")) !=
                                 o.o_comment.end()))))))))
                      continue;
                    __items.push_back(o);
                  }
                  return __items;
                })()
                    .size())}});
    }
    return __items;
  })();
  std::vector<__struct4> grouped = ([&]() {
    std::vector<__struct3> __groups;
    for (auto x : per_customer) {
      auto __key = x.c_count;
      bool __found = false;
      for (auto &__g : __groups) {
        if (__any_eq(__g.key, __key)) {
          __g.items.push_back(x);
          __found = true;
          break;
        }
      }
      if (!__found) {
        __groups.push_back(__struct3{__key, std::vector<Grouped>{x}});
      }
    }
    std::vector<
        std::pair<decltype((-std::declval<__struct3>().key)), __struct4>>
        __items;
    for (auto &g : __groups) {
      __items.push_back({(-g.key), __struct4{g.key, ((int)g.items.size())}});
    }
    std::sort(__items.begin(), __items.end(),
              [](auto &a, auto &b) { return a.first < b.first; });
    std::vector<__struct4> __res;
    for (auto &p : __items)
      __res.push_back(p.second);
    return __res;
  })();
  (__json(grouped));
  // test Q13 groups customers by non-special order count
  return 0;
}
