// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
#include <algorithm>
#include <any>
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
  std::string o_orderpriority;
};
struct Lineitem {
  int l_orderkey;
  std::string l_shipmode;
  std::string l_commitdate;
  std::string l_receiptdate;
  std::string l_shipdate;
};
struct Result {
  Lineitem l;
  Order o;
};
struct __struct4 {
  std::any key;
  std::vector<Result> items;
};
struct __struct5 {
  std::any l_shipmode;
  double high_line_count;
  double low_line_count;
};
inline void __json(const Lineitem &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l_orderkey\":";
  __json(v.l_orderkey);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l_shipmode\":";
  __json(v.l_shipmode);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l_commitdate\":";
  __json(v.l_commitdate);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l_receiptdate\":";
  __json(v.l_receiptdate);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l_shipdate\":";
  __json(v.l_shipdate);
  std::cout << "}";
}
inline void __json(const __struct5 &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l_shipmode\":";
  __json(v.l_shipmode);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"high_line_count\":";
  __json(v.high_line_count);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"low_line_count\":";
  __json(v.low_line_count);
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
  std::cout << "\"o_orderpriority\":";
  __json(v.o_orderpriority);
  std::cout << "}";
}
inline void __json(const Result &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"l\":";
  __json(v.l);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"o\":";
  __json(v.o);
  std::cout << "}";
}
int main() {
  std::vector<Order> orders = {Order{1, std::string("1-URGENT")},
                               Order{2, std::string("3-MEDIUM")}};
  std::vector<Lineitem> lineitem = {
      Lineitem{1, std::string("MAIL"), std::string("1994-02-10"),
               std::string("1994-02-15"), std::string("1994-02-05")},
      Lineitem{2, std::string("SHIP"), std::string("1994-03-01"),
               std::string("1994-02-28"), std::string("1994-02-27")}};
  std::vector<Result> result = ([&]() {
    std::vector<__struct4> __groups;
    for (auto l : lineitem) {
      for (auto o : orders) {
        if (!((o.o_orderkey == l.l_orderkey)))
          continue;
        if (!(((((((std::find(std::vector<std::string>{std::string("MAIL"),
                                                       std::string("SHIP")}
                                  .begin(),
                              std::vector<std::string>{std::string("MAIL"),
                                                       std::string("SHIP")}
                                  .end(),
                              l.l_shipmode) !=
                    std::vector<std::string>{std::string("MAIL"),
                                             std::string("SHIP")}
                        .end())) &&
                  ((l.l_commitdate < l.l_receiptdate))) &&
                 ((l.l_shipdate < l.l_commitdate))) &&
                ((l.l_receiptdate >= std::string("1994-01-01")))) &&
               ((l.l_receiptdate < std::string("1995-01-01"))))))
          continue;
        auto __key = l.l_shipmode;
        bool __found = false;
        for (auto &__g : __groups) {
          if (__any_eq(__g.key, __key)) {
            __g.items.push_back(Result{l, o});
            __found = true;
            break;
          }
        }
        if (!__found) {
          __groups.push_back(
              __struct4{__key, std::vector<Result>{Result{l, o}}});
        }
      }
    }
    std::vector<std::pair<decltype(std::declval<__struct4>().key), __struct5>>
        __items;
    for (auto &g : __groups) {
      __items.push_back(
          {g.key,
           __struct5{
               g.key, ([&](auto v) {
                 return std::accumulate(v.begin(), v.end(), 0.0);
               })(([&]() {
                 std::vector<decltype((
                     (std::find(
                          std::vector<std::string>{std::string("1-URGENT"),
                                                   std::string("2-HIGH")}
                              .begin(),
                          std::vector<std::string>{std::string("1-URGENT"),
                                                   std::string("2-HIGH")}
                              .end(),
                          std::declval<Result>().o.o_orderpriority) !=
                      std::vector<std::string>{std::string("1-URGENT"),
                                               std::string("2-HIGH")}
                          .end())
                         ? 1
                         : 0))>
                     __items;
                 for (auto x : g.items) {
                   __items.push_back(
                       ((std::find(
                             std::vector<std::string>{std::string("1-URGENT"),
                                                      std::string("2-HIGH")}
                                 .begin(),
                             std::vector<std::string>{std::string("1-URGENT"),
                                                      std::string("2-HIGH")}
                                 .end(),
                             x.o.o_orderpriority) !=
                         std::vector<std::string>{std::string("1-URGENT"),
                                                  std::string("2-HIGH")}
                             .end())
                            ? 1
                            : 0));
                 }
                 return __items;
               })()),
               ([&](auto v) {
                 return std::accumulate(v.begin(), v.end(), 0.0);
               })(([&]() {
                 std::vector<decltype((
                     (!((std::find(
                             std::vector<std::string>{std::string("1-URGENT"),
                                                      std::string("2-HIGH")}
                                 .begin(),
                             std::vector<std::string>{std::string("1-URGENT"),
                                                      std::string("2-HIGH")}
                                 .end(),
                             std::declval<Result>().o.o_orderpriority) !=
                         std::vector<std::string>{std::string("1-URGENT"),
                                                  std::string("2-HIGH")}
                             .end())))
                         ? 1
                         : 0))>
                     __items;
                 for (auto x : g.items) {
                   __items.push_back((
                       (!((std::find(
                               std::vector<std::string>{std::string("1-URGENT"),
                                                        std::string("2-HIGH")}
                                   .begin(),
                               std::vector<std::string>{std::string("1-URGENT"),
                                                        std::string("2-HIGH")}
                                   .end(),
                               x.o.o_orderpriority) !=
                           std::vector<std::string>{std::string("1-URGENT"),
                                                    std::string("2-HIGH")}
                               .end())))
                           ? 1
                           : 0));
                 }
                 return __items;
               })())}});
    }
    std::sort(__items.begin(), __items.end(),
              [](auto &a, auto &b) { return a.first < b.first; });
    std::vector<__struct5> __res;
    for (auto &p : __items)
      __res.push_back(p.second);
    return __res;
  })();
  (__json(result));
  // test Q12 counts lineitems by ship mode and priority
  return 0;
}
