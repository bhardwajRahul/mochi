// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fun toBool(v: Any?): Boolean = when (v) {
    is Boolean -> v
    is Int -> v != 0
    is Double -> v != 0.0
    is String -> v.isNotEmpty()
    null -> false
    else -> true
}
// Code generated from aks-test-for-primes.mochi

/**
 * Auto-generated from Mochi
 * @param p Int
 * @return String
 */
fun poly(p: Int): String {
    var s: String = ""
    var coef: Int = 1
    var i = p
    if (coef != 1) {
        s = s + coef.toString()
    }
    while (i > 0) {
        s = s + "x"
        if (i != 1) {
            s = s + "^" + i.toString()
        }
        coef = (((coef * i).toDouble() / ((p - i + 1)).toDouble())).toInt()
        var d = coef
        if ((p - (i - 1)) % 2 == 1) {
            d = -d
        }
        if (d < 0) {
            s = s + " - " + -d.toString()
        }
        else {
            s = s + " + " + d.toString()
        }
        i = i - 1
    }
    if (s == "") {
        s = "1"
    }
    return s
}

/**
 * Auto-generated from Mochi
 * @param n Int
 * @return Boolean
 */
fun aks(n: Int): Boolean {
    if (n < 2) {
        return false
    }
    var c: Int = n
    var i = 1
    while (i < n) {
        if (c % n != 0) {
            return false
        }
        c = (((c * (n - i)).toDouble() / ((i + 1)).toDouble())).toInt()
        i = i + 1
    }
    return true
}

/**
 * Auto-generated from Mochi
 */
fun main(): Unit {
    var p = 0
    while (p <= 7) {
        println(p.toString() + ":  " + poly(p))
        p = p + 1
    }
    var first = true
    p = 2
    var line: String = ""
    while (p < 50) {
        if (aks(p)) {
            if (toBool(first)) {
                line = line + p.toString()
                first = false
            }
            else {
                line = line + " " + p.toString()
            }
        }
        p = p + 1
    }
    println(line)
}

