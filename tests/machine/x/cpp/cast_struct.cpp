// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
#include <iostream>
#include <string>

struct Todo {
  std::string title;
};
int main() {
  auto todo = Todo{.title = std::string("hi")};
  std::cout << todo.title << std::endl;
  return 0;
}
