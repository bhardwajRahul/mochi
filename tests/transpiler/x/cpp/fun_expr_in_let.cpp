// Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:14:21 GMT+7
#include <iostream>
#include <string>

int main() {
    auto square = [&](int x) { return (x * x); };
    std::cout << square(6) << std::endl;
    return 0;
}
