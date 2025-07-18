// Generated by Mochi compiler v0.10.26 on 2025-07-16T09:55:09Z
func absf(_ x: Double) -> Double {
    if x < 0.0 {
        return -x
    }
    return x
}
func floorf(_ x: Double) -> Double {
    return Double((Int(x)))
}
func indexOf(_ s: String, _ ch: String) -> Int {
    var i = 0
    while i < s.count {
        if String(s[s.index(s.startIndex, offsetBy: i)..<s.index(s.startIndex, offsetBy: i + 1)]) == ch {
            return i
        }
        i = i + 1
    }
    return -1
}
func fmtF(_ x: Double) -> String {
    var y = floorf(x * 10000.0 + 0.5) / 10000.0
    var s = String(y)
    var dot = indexOf(s, ".")
    if dot == 0 - 1 {
        s = s + ".0000"
    }
    else {
        var decs = s.count - dot - 1
        if decs > 4 {
            s = String(s[s.index(s.startIndex, offsetBy: 0)..<s.index(s.startIndex, offsetBy: dot + 5)])
        }
        else {
            while decs < 4 {
                s = s + "0"
                decs = decs + 1
            }
        }
    }
    return s
}
func padInt(_ n: Int, _ width: Int) -> String {
    var s = String(n)
    while s.count < width {
        s = " " + s
    }
    return s
}
func padFloat(_ x: Double, _ width: Int) -> String {
    var s = fmtF(x)
    while s.count < width {
        s = " " + s
    }
    return s
}
func avgLen(_ n: Int) -> Double {
    let tests = 10000
    var sum = 0
    var seed = 1
    var t = 0
    while t < tests {
        var visited: [Bool] = [Any]()
        var i = 0
        while i < n {
            visited = visited + [false]
            i = i + 1
        }
        var x = 0
        while !visited[x] {
            visited[x] = true
            sum = sum + 1
            seed = (seed * 1664525 + 1013904223) % 2147483647
            x = seed % n
        }
        t = t + 1
    }
    return (Double(sum)) / tests
}
func ana(_ n: Int) -> Double {
    var nn = Double(n)
    var term = 1.0
    var sum = 1.0
    var i = nn - 1.0
    while i >= 1.0 {
        term = term * (i / nn)
        sum = sum + term
        i = i - 1.0
    }
    return sum
}
func main() {
    let nmax = 20
    print(" N    average    analytical    (error)")
    print("===  =========  ============  =========")
    var n = 1
    while n <= nmax {
        let a = avgLen(n)
        let b = ana(n)
        let err = absf(a - b) / b * 100.0
        var line = padInt(n, 3) + "  " + padFloat(a, 9) + "  " + padFloat(b, 12) + "  (" + padFloat(err, 6) + "%)"
        print(line)
        n = n + 1
    }
}
main()
