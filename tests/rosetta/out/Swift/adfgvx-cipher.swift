// Generated by Mochi compiler v0.10.26 on 2025-07-16T13:15:40Z
var adfgvx = "ADFGVX"
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
func shuffleStr(_ s: String) -> String {
    var arr: [String] = []
    var i = 0
    while i < s.count {
        arr = arr + [s[i]]
        i = i + 1
    }
    var j = arr.count - 1
    while j > 0 {
        let k = now() % (j + 1)
        let tmp = arr[j]
        arr[j] = arr[k]
        arr[k] = tmp
        j = j - 1
    }
    var out = ""
    i = 0
    while i < arr.count {
        out = out + arr[i]
        i = i + 1
    }
    return out
}
func createPolybius() -> [String] {
    let shuffled = shuffleStr(alphabet)
    print("6 x 6 Polybius square:\n")
    print("  | A D F G V X")
    print("---------------")
    var p: [String] = []
    var i = 0
    while i < 6 {
        var row = Array(shuffled[i * 6..<(i + 1) * 6])
        p = p + [row]
        var line = adfgvx[adfgvx.index(adfgvx.startIndex, offsetBy: i)] + " | "
        var j = 0
        while j < 6 {
            line = line + row[j] + " "
            j = j + 1
        }
        print(line)
        i = i + 1
    }
    return p
}
func createKey(_ n: Int) -> String {
    if n < 7 || n > 12 {
        print("Key should be within 7 and 12 letters long.")
    }
    var pool = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var key = ""
    var i = 0
    while i < n {
        let idx = now() % pool.count
        key = key + pool[pool.index(pool.startIndex, offsetBy: idx)]
        pool = String(pool[pool.index(pool.startIndex, offsetBy: 0)..<pool.index(pool.startIndex, offsetBy: idx)]) + String(pool[pool.index(pool.startIndex, offsetBy: idx + 1)..<pool.index(pool.startIndex, offsetBy: pool.count)])
        i = i + 1
    }
    print("\nThe key is " + key)
    return key
}
func orderKey(_ key: String) -> [Int] {
    var pairs: [Any] = []
    var i = 0
    while i < key.count {
        pairs = pairs + [[key[i], i]]
        i = i + 1
    }
    var n = pairs.count
    var m = 0
    while m < n {
        var j = 0
        while j < n - 1 {
            if pairs[j][0] > pairs[j + 1][0] {
                let tmp = pairs[j]
                pairs[j] = pairs[j + 1]
                pairs[j + 1] = tmp
            }
            j = j + 1
        }
        m = m + 1
    }
    var res: [Any] = []
    i = 0
    while i < n {
        res = res + [Int(pairs[i][1])]
        i = i + 1
    }
    return res
}
func encrypt(_ polybius: [String], _ key: String, _ plainText: String) -> String {
    var temp = ""
    var i = 0
    while i < plainText.count {
        var r = 0
        while r < 6 {
            var c = 0
            while c < 6 {
                if polybius[r][c] == plainText[plainText.index(plainText.startIndex, offsetBy: i)] {
                    temp = temp + adfgvx[adfgvx.index(adfgvx.startIndex, offsetBy: r)] + adfgvx[adfgvx.index(adfgvx.startIndex, offsetBy: c)]
                }
                c = c + 1
            }
            r = r + 1
        }
        i = i + 1
    }
    var colLen = temp.count / key.count
    if temp.count % key.count > 0 {
        colLen = colLen + 1
    }
    var table: [[String]] = []
    var rIdx = 0
    while rIdx < colLen {
        var row: [String] = []
        var j = 0
        while j < key.count {
            row = row + [""]
            j = j + 1
        }
        table = table + [row]
        rIdx = rIdx + 1
    }
    var idx = 0
    while idx < temp.count {
        let row = idx / key.count
        let col = idx % key.count
        table[row][col] = Array(temp[idx..<idx + 1])
        idx = idx + 1
    }
    let order = orderKey(key)
    var cols: [String] = []
    var ci = 0
    while ci < key.count {
        var colStr = ""
        var ri = 0
        while ri < colLen {
            colStr = colStr + table[ri][order[ci]]
            ri = ri + 1
        }
        cols = cols + [colStr]
        ci = ci + 1
    }
    var result = ""
    ci = 0
    while ci < cols.count {
        result = result + cols[ci]
        if ci < cols.count - 1 {
            result = result + " "
        }
        ci = ci + 1
    }
    return result
}
func indexOf(_ s: String, _ ch: String) -> Int {
    var i = 0
    while i < s.count {
        if s[i] == ch {
            return i
        }
        i = i + 1
    }
    return -1
}
func decrypt(_ polybius: [String], _ key: String, _ cipherText: String) -> String {
    var colStrs: [String] = []
    var start = 0
    var i = 0
    while i <= cipherText.count {
        if i == cipherText.count || cipherText[i] == " " {
            colStrs = colStrs + [Array(cipherText[start..<i])]
            start = i + 1
        }
        i = i + 1
    }
    var maxColLen = 0
    i = 0
    while i < colStrs.count {
        if colStrs[i].count > maxColLen {
            maxColLen = colStrs[i].count
        }
        i = i + 1
    }
    var cols: [[String]] = []
    i = 0
    while i < colStrs.count {
        var s = colStrs[i]
        var ls: [String] = []
        var j = 0
        while j < s.count {
            ls = ls + [s[j]]
            j = j + 1
        }
        if s.count < maxColLen {
            var pad: [String] = []
            var k = 0
            while k < maxColLen {
                if k < ls.count {
                    pad = pad + [ls[k]]
                }
                else {
                    pad = pad + [""]
                }
                k = k + 1
            }
            cols = cols + [pad]
        }
        else {
            cols = cols + [ls]
        }
        i = i + 1
    }
    var table: [[String]] = []
    var r = 0
    while r < maxColLen {
        var row: [String] = []
        var c = 0
        while c < key.count {
            row = row + [""]
            c = c + 1
        }
        table = table + [row]
        r = r + 1
    }
    let order = orderKey(key)
    r = 0
    while r < maxColLen {
        var c = 0
        while c < key.count {
            table[r][order[c]] = cols[c][r]
            c = c + 1
        }
        r = r + 1
    }
    var temp = ""
    r = 0
    while r < table.count {
        var j = 0
        while j < table[r].count {
            temp = temp + table[r][j]
            j = j + 1
        }
        r = r + 1
    }
    var plainText = ""
    var idx = 0
    while idx < temp.count {
        let rIdx = indexOf(adfgvx, Array(temp[idx..<idx + 1]))
        let cIdx = indexOf(adfgvx, Array(temp[idx + 1..<idx + 2]))
        plainText = plainText + polybius[rIdx][cIdx]
        idx = idx + 2
    }
    return plainText
}
func main() {
    let plainText = "ATTACKAT1200AM"
    let polybius = createPolybius()
    let key = createKey(9)
    print("\nPlaintext : " + plainText)
    let cipherText = encrypt(polybius, key, plainText)
    print("\nEncrypted : " + cipherText)
    let plainText2 = decrypt(polybius, key, cipherText)
    print("\nDecrypted : " + plainText2)
}
main()
