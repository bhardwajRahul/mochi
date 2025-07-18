// Generated by Mochi compiler v0.10.26 on 2025-07-16T13:15:38Z
func ackermann(_ m: Int, _ n: Int) -> Int {
    if m == 0 {
        return n + 1
    }
    if n == 0 {
        return ackermann(m - 1, 1)
    }
    return ackermann(m - 1, ackermann(m, n - 1))
}
func main() {
    print("A(0, 0) = " + String(ackermann(0, 0)))
    print("A(1, 2) = " + String(ackermann(1, 2)))
    print("A(2, 4) = " + String(ackermann(2, 4)))
    print("A(3, 4) = " + String(ackermann(3, 4)))
}
main()
