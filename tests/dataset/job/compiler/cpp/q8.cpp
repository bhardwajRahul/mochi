// Generated by Mochi compiler v0.10.25 on 2025-07-13T13:01:41Z
#include <algorithm>
#include <iostream>
#include <map>
#include <string>
#include <unordered_map>
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
      std::cout << ",";
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

struct AkaName {
  decltype(1) person_id;
  decltype(std::string("Y. S.")) name;
};
struct CastInfo {
  decltype(1) person_id;
  decltype(10) movie_id;
  decltype(std::string("(voice: English version)")) note;
  decltype(1000) role_id;
};
struct CompanyName {
  decltype(50) id;
  decltype(std::string("[jp]")) country_code;
};
struct MovieCompany {
  decltype(10) movie_id;
  decltype(50) company_id;
  decltype(std::string("Studio (Japan)")) note;
};
struct Name {
  decltype(1) id;
  decltype(std::string("Yoko Ono")) name;
};
struct RoleType {
  decltype(1000) id;
  decltype(std::string("actress")) role;
};
struct Title {
  decltype(10) id;
  decltype(std::string("Dubbed Film")) title;
};
struct Eligible {
  decltype(an1.name) pseudonym;
  decltype(t.title) movie_title;
};
struct Result {
  decltype((*std::min_element(
      ([&]() {
        std::vector<decltype(std::declval<Eligible>().pseudonym)> __items;
        for (auto x : eligible) {
          __items.push_back(x.pseudonym);
        }
        return __items;
      })()
          .begin(),
      ([&]() {
        std::vector<decltype(std::declval<Eligible>().pseudonym)> __items;
        for (auto x : eligible) {
          __items.push_back(x.pseudonym);
        }
        return __items;
      })()
          .end()))) actress_pseudonym;
  decltype((*std::min_element(
      ([&]() {
        std::vector<decltype(std::declval<Eligible>().movie_title)> __items;
        for (auto x : eligible) {
          __items.push_back(x.movie_title);
        }
        return __items;
      })()
          .begin(),
      ([&]() {
        std::vector<decltype(std::declval<Eligible>().movie_title)> __items;
        for (auto x : eligible) {
          __items.push_back(x.movie_title);
        }
        return __items;
      })()
          .end()))) japanese_movie_dubbed;
};
inline void __json(const Result &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"actress_pseudonym\":";
  __json(v.actress_pseudonym);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"japanese_movie_dubbed\":";
  __json(v.japanese_movie_dubbed);
  std::cout << "}";
}
inline void __json(const CompanyName &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"id\":";
  __json(v.id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"country_code\":";
  __json(v.country_code);
  std::cout << "}";
}
inline void __json(const Name &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"id\":";
  __json(v.id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"name\":";
  __json(v.name);
  std::cout << "}";
}
inline void __json(const RoleType &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"id\":";
  __json(v.id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"role\":";
  __json(v.role);
  std::cout << "}";
}
inline void __json(const Title &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"id\":";
  __json(v.id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"title\":";
  __json(v.title);
  std::cout << "}";
}
inline void __json(const MovieCompany &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"movie_id\":";
  __json(v.movie_id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"company_id\":";
  __json(v.company_id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"note\":";
  __json(v.note);
  std::cout << "}";
}
inline void __json(const CastInfo &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"person_id\":";
  __json(v.person_id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"movie_id\":";
  __json(v.movie_id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"note\":";
  __json(v.note);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"role_id\":";
  __json(v.role_id);
  std::cout << "}";
}
inline void __json(const AkaName &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"person_id\":";
  __json(v.person_id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"name\":";
  __json(v.name);
  std::cout << "}";
}
inline void __json(const Eligible &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"pseudonym\":";
  __json(v.pseudonym);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"movie_title\":";
  __json(v.movie_title);
  std::cout << "}";
}
int main() {
  std::vector<AkaName> aka_name = {AkaName{1, std::string("Y. S.")}};
  std::vector<CastInfo> cast_info = {
      CastInfo{1, 10, std::string("(voice: English version)"), 1000}};
  std::vector<CompanyName> company_name = {
      CompanyName{50, std::string("[jp]")}};
  std::vector<MovieCompany> movie_companies = {
      MovieCompany{10, 50, std::string("Studio (Japan)")}};
  std::vector<Name> name = {Name{1, std::string("Yoko Ono")},
                            Name{2, std::string("Yuichi")}};
  std::vector<RoleType> role_type = {RoleType{1000, std::string("actress")}};
  std::vector<Title> title = {Title{10, std::string("Dubbed Film")}};
  std::vector<Eligible> eligible = ([&]() {
    std::vector<Eligible> __items;
    for (auto an1 : aka_name) {
      for (auto n1 : name) {
        if (!((n1.id == an1.person_id)))
          continue;
        for (auto ci : cast_info) {
          if (!((ci.person_id == an1.person_id)))
            continue;
          for (auto t : title) {
            if (!((t.id == ci.movie_id)))
              continue;
            for (auto mc : movie_companies) {
              if (!((mc.movie_id == ci.movie_id)))
                continue;
              for (auto cn : company_name) {
                if (!((cn.id == mc.company_id)))
                  continue;
                for (auto rt : role_type) {
                  if (!((rt.id == ci.role_id)))
                    continue;
                  if (!((((((((ci.note ==
                               std::string("(voice: English version)")) &&
                              (cn.country_code == std::string("[jp]"))) &&
                             (mc.note.find(std::string("(Japan)")) !=
                              std::string::npos)) &&
                            ((!(mc.note.find(std::string("(USA)")) !=
                                std::string::npos)))) &&
                           (n1.name.find(std::string("Yo")) !=
                            std::string::npos)) &&
                          ((!(n1.name.find(std::string("Yu")) !=
                              std::string::npos)))) &&
                         (rt.role == std::string("actress")))))
                    continue;
                  __items.push_back(Eligible{an1.name, t.title});
                }
              }
            }
          }
        }
      }
    }
    return __items;
  })();
  std::vector<Result> result = {Result{
      (*std::min_element(
          ([&]() {
            std::vector<decltype(std::declval<Eligible>().pseudonym)> __items;
            for (auto x : eligible) {
              __items.push_back(x.pseudonym);
            }
            return __items;
          })()
              .begin(),
          ([&]() {
            std::vector<decltype(std::declval<Eligible>().pseudonym)> __items;
            for (auto x : eligible) {
              __items.push_back(x.pseudonym);
            }
            return __items;
          })()
              .end())),
      (*std::min_element(
          ([&]() {
            std::vector<decltype(std::declval<Eligible>().movie_title)> __items;
            for (auto x : eligible) {
              __items.push_back(x.movie_title);
            }
            return __items;
          })()
              .begin(),
          ([&]() {
            std::vector<decltype(std::declval<Eligible>().movie_title)> __items;
            for (auto x : eligible) {
              __items.push_back(x.movie_title);
            }
            return __items;
          })()
              .end()))}};
  (__json(result));
  // test Q8 returns the pseudonym and movie title for Japanese dubbing
  return 0;
}
