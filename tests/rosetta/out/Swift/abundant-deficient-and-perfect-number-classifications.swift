// Generated by Mochi compiler v0.10.26 on 2025-07-16T13:15:34Z
func pfacSum(_ i: Int) -> Int {
    var sum = 0
    var p = 1
    while p <= i / 2 {
        if i % p == 0 {
            sum = sum + p
        }
        p = p + 1
    }
    return sum
}
func main() {
    var d = 0
    var a = 0
    var pnum = 0
    var i = 1
    while i <= 20000 {
        let j = pfacSum(i)
        if j < i {
            d = d + 1
        }
        if j == i {
            pnum = pnum + 1
        }
        if j > i {
            a = a + 1
        }
        i = i + 1
    }
    print("There are " + String(d) + " deficient numbers between 1 and 20000")
    print("There are " + String(a) + " abundant numbers  between 1 and 20000")
    print("There are " + String(pnum) + " perfect numbers between 1 and 20000")
}
main()
