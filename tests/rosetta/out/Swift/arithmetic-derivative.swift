// Generated by Mochi compiler v0.10.26 on 2025-07-16T13:16:25Z
func primeFactors(_ n: Int) -> [Int] {
    var factors: [Int] = []
    var x = n
    while x % 2 == 0 {
        factors = factors + [2]
        x = Int((x / 2))
    }
    var p = 3
    while p * p <= x {
        while x % p == 0 {
            factors = factors + [p]
            x = Int((x / p))
        }
        p = p + 2
    }
    if x > 1 {
        factors = factors + [x]
    }
    return factors
}
func repeat(_ ch: String, _ n: Int) -> String {
    var s = ""
    var i = 0
    while i < n {
        s = s + ch
        i = i + 1
    }
    return s
}
func D(_ n: Double) -> Double {
    if n < 0.0 {
        return -D(-n)
    }
    if n < 2.0 {
        return 0.0
    }
    var factors: [Int] = []
    if n < 10000000000000000000.0 {
        factors = primeFactors(Int((n)))
    }
    else {
        let g = Int((n / 100.0))
        factors = primeFactors(g)
        factors = factors + [2]
        factors = factors + [2]
        factors = factors + [5]
        factors = factors + [5]
    }
    let c = factors.count
    if c == 1 {
        return 1.0
    }
    if c == 2 {
        return Double((factors[0] + factors[1]))
    }
    let d = n / (Double(factors[0]))
    return D(d) * (Double(factors[0])) + d
}
func pad(_ n: Int) -> String {
    var s = String(n)
    while s.count < 4 {
        s = " " + s
    }
    return s
}
func main() {
    var vals: [Int] = []
    var n = -99
    while n < 101 {
        vals = vals + [Int((D(Double(n))))]
        n = n + 1
    }
    var i = 0
    while i < vals.count {
        var line = ""
        var j = 0
        while j < 10 {
            line = line + pad(vals[i + j])
            if j < 9 {
                line = line + " "
            }
            j = j + 1
        }
        print(line)
        i = i + 10
    }
    var pow = 1.0
    var m = 1
    while m < 21 {
        pow = pow * 10.0
        var exp = String(m)
        if exp.count < 2 {
            exp = exp + " "
        }
        var res = String(m) + repeat("0", m - 1)
        print("D(10^" + exp + ") / 7 = " + res)
        m = m + 1
    }
}
main()
