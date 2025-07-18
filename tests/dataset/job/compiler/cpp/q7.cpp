// Generated by Mochi compiler v0.10.25 on 2025-07-13T13:01:39Z
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
  decltype(std::string("Anna Mae")) name;
};
struct CastInfo {
  decltype(1) person_id;
  decltype(10) movie_id;
};
struct InfoType {
  decltype(1) id;
  decltype(std::string("mini biography")) info;
};
struct LinkType {
  decltype(1) id;
  decltype(std::string("features")) link;
};
struct MovieLink {
  decltype(10) linked_movie_id;
  decltype(1) link_type_id;
};
struct Name {
  decltype(1) id;
  decltype(std::string("Alan Brown")) name;
  decltype(std::string("B")) name_pcode_cf;
  decltype(std::string("m")) gender;
};
struct PersonInfo {
  decltype(1) person_id;
  decltype(1) info_type_id;
  decltype(std::string("Volker Boehm")) note;
};
struct Title {
  decltype(10) id;
  decltype(std::string("Feature Film")) title;
  decltype(1990) production_year;
};
struct Row {
  decltype(n.name) person_name;
  decltype(t.title) movie_title;
};
struct Result {
  decltype((*std::min_element(
      ([&]() {
        std::vector<decltype(std::declval<Row>().person_name)> __items;
        for (auto r : rows) {
          __items.push_back(r.person_name);
        }
        return __items;
      })()
          .begin(),
      ([&]() {
        std::vector<decltype(std::declval<Row>().person_name)> __items;
        for (auto r : rows) {
          __items.push_back(r.person_name);
        }
        return __items;
      })()
          .end()))) of_person;
  decltype((*std::min_element(
      ([&]() {
        std::vector<decltype(std::declval<Row>().movie_title)> __items;
        for (auto r : rows) {
          __items.push_back(r.movie_title);
        }
        return __items;
      })()
          .begin(),
      ([&]() {
        std::vector<decltype(std::declval<Row>().movie_title)> __items;
        for (auto r : rows) {
          __items.push_back(r.movie_title);
        }
        return __items;
      })()
          .end()))) biography_movie;
};
inline void __json(const InfoType &v) {
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
  std::cout << "\"info\":";
  __json(v.info);
  std::cout << "}";
}
inline void __json(const LinkType &v) {
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
  std::cout << "\"link\":";
  __json(v.link);
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
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"name_pcode_cf\":";
  __json(v.name_pcode_cf);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"gender\":";
  __json(v.gender);
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
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"production_year\":";
  __json(v.production_year);
  std::cout << "}";
}
inline void __json(const MovieLink &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"linked_movie_id\":";
  __json(v.linked_movie_id);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"link_type_id\":";
  __json(v.link_type_id);
  std::cout << "}";
}
inline void __json(const Result &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"of_person\":";
  __json(v.of_person);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"biography_movie\":";
  __json(v.biography_movie);
  std::cout << "}";
}
inline void __json(const PersonInfo &v) {
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
  std::cout << "\"info_type_id\":";
  __json(v.info_type_id);
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
inline void __json(const Row &v) {
  bool first = true;
  std::cout << "{";
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"person_name\":";
  __json(v.person_name);
  if (!first)
    std::cout << ",";
  first = false;
  std::cout << "\"movie_title\":";
  __json(v.movie_title);
  std::cout << "}";
}
int main() {
  std::vector<AkaName> aka_name = {AkaName{1, std::string("Anna Mae")},
                                   AkaName{2, std::string("Chris")}};
  std::vector<CastInfo> cast_info = {CastInfo{1, 10}, CastInfo{2, 20}};
  std::vector<InfoType> info_type = {InfoType{1, std::string("mini biography")},
                                     InfoType{2, std::string("trivia")}};
  std::vector<LinkType> link_type = {LinkType{1, std::string("features")},
                                     LinkType{2, std::string("references")}};
  std::vector<MovieLink> movie_link = {MovieLink{10, 1}, MovieLink{20, 2}};
  std::vector<Name> name = {
      Name{1, std::string("Alan Brown"), std::string("B"), std::string("m")},
      Name{2, std::string("Zoe"), std::string("Z"), std::string("f")}};
  std::vector<PersonInfo> person_info = {
      PersonInfo{1, 1, std::string("Volker Boehm")},
      PersonInfo{2, 1, std::string("Other")}};
  std::vector<Title> title = {Title{10, std::string("Feature Film"), 1990},
                              Title{20, std::string("Late Film"), 2000}};
  std::vector<Row> rows = ([&]() {
    std::vector<Row> __items;
    for (auto an : aka_name) {
      for (auto n : name) {
        if (!((n.id == an.person_id)))
          continue;
        for (auto pi : person_info) {
          if (!((pi.person_id == an.person_id)))
            continue;
          for (auto it : info_type) {
            if (!((it.id == pi.info_type_id)))
              continue;
            for (auto ci : cast_info) {
              if (!((ci.person_id == n.id)))
                continue;
              for (auto t : title) {
                if (!((t.id == ci.movie_id)))
                  continue;
                for (auto ml : movie_link) {
                  if (!((ml.linked_movie_id == t.id)))
                    continue;
                  for (auto lt : link_type) {
                    if (!((lt.id == ml.link_type_id)))
                      continue;
                    if (!(((((((((((((((an.name.find(std::string("a")) !=
                                        std::string::npos) &&
                                       (it.info ==
                                        std::string("mini biography"))) &&
                                      (lt.link == std::string("features"))) &&
                                     (n.name_pcode_cf >= std::string("A"))) &&
                                    (n.name_pcode_cf <= std::string("F"))) &&
                                   (((n.gender == std::string("m")) ||
                                     (((n.gender == std::string("f")) &&
                                       n.name.starts_with(
                                           std::string("B"))))))) &&
                                  (pi.note == std::string("Volker Boehm"))) &&
                                 (t.production_year >= 1980)) &&
                                (t.production_year <= 1995)) &&
                               (pi.person_id == an.person_id)) &&
                              (pi.person_id == ci.person_id)) &&
                             (an.person_id == ci.person_id)) &&
                            (ci.movie_id == ml.linked_movie_id)))))
                      continue;
                    __items.push_back(Row{n.name, t.title});
                  }
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
            std::vector<decltype(std::declval<Row>().person_name)> __items;
            for (auto r : rows) {
              __items.push_back(r.person_name);
            }
            return __items;
          })()
              .begin(),
          ([&]() {
            std::vector<decltype(std::declval<Row>().person_name)> __items;
            for (auto r : rows) {
              __items.push_back(r.person_name);
            }
            return __items;
          })()
              .end())),
      (*std::min_element(
          ([&]() {
            std::vector<decltype(std::declval<Row>().movie_title)> __items;
            for (auto r : rows) {
              __items.push_back(r.movie_title);
            }
            return __items;
          })()
              .begin(),
          ([&]() {
            std::vector<decltype(std::declval<Row>().movie_title)> __items;
            for (auto r : rows) {
              __items.push_back(r.movie_title);
            }
            return __items;
          })()
              .end()))}};
  (__json(result));
  // test Q7 finds movie features biography for person
  return 0;
}
