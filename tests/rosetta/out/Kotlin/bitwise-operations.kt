// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
// Code generated from bitwise-operations.mochi

/**
 * Auto-generated from Mochi
 * @param n Int
 * @return Int
 */
fun toUnsigned16(n: Int): Int {
    var u = n
    if (u < 0) {
        u = u + 65536
    }
    return u % 65536
}

/**
 * Auto-generated from Mochi
 * @param n Int
 * @return String
 */
fun bin16(n: Int): String {
    var u = toUnsigned16(n)
    var bits = ""
    var mask = 32768
    for (i in 0 until 16) {
        if (u >= mask) {
            bits = bits + "1"
            u = u - mask
        }
        else {
            bits = bits + "0"
        }
        mask = (((mask).toDouble() / (2).toDouble())).toInt()
    }
    return bits
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun bit_and(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    var ub = toUnsigned16(b)
    var res = 0
    var bit = 1
    for (i in 0 until 16) {
        if (ua % 2 == 1 && ub % 2 == 1) {
            res = res + bit
        }
        ua = (((ua).toDouble() / (2).toDouble())).toInt()
        ub = (((ub).toDouble() / (2).toDouble())).toInt()
        bit = bit * 2
    }
    return res
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun bit_or(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    var ub = toUnsigned16(b)
    var res = 0
    var bit = 1
    for (i in 0 until 16) {
        if (ua % 2 == 1 || ub % 2 == 1) {
            res = res + bit
        }
        ua = (((ua).toDouble() / (2).toDouble())).toInt()
        ub = (((ub).toDouble() / (2).toDouble())).toInt()
        bit = bit * 2
    }
    return res
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun bit_xor(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    var ub = toUnsigned16(b)
    var res = 0
    var bit = 1
    for (i in 0 until 16) {
        val abit = ua % 2
        val bbit = ub % 2
        if ((abit == 1 && bbit == 0) || (abit == 0 && bbit == 1)) {
            res = res + bit
        }
        ua = (((ua).toDouble() / (2).toDouble())).toInt()
        ub = (((ub).toDouble() / (2).toDouble())).toInt()
        bit = bit * 2
    }
    return res
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @return Int
 */
fun bit_not(a: Int): Int {
    var ua = toUnsigned16(a)
    return 65535 - ua
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun shl(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    var i = 0
    while (i < b) {
        ua = (ua * 2) % 65536
        i = i + 1
    }
    return ua
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun shr(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    var i = 0
    while (i < b) {
        ua = (((ua).toDouble() / (2).toDouble())).toInt()
        i = i + 1
    }
    return ua
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun las(a: Int, b: Int): Int {
    return shl(a, b)
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun ras(a: Int, b: Int): Int {
    var `val` = a
    var i = 0
    while (i < b) {
        if (`val` >= 0) {
            `val` = (((`val`).toDouble() / (2).toDouble())).toInt()
        }
        else {
            `val` = ((((`val` - 1)).toDouble() / (2).toDouble())).toInt()
        }
        i = i + 1
    }
    return toUnsigned16(`val`)
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun rol(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    val left = shl(ua, b)
    val right = shr(ua, 16 - b)
    return toUnsigned16(left + right)
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 * @return Int
 */
fun ror(a: Int, b: Int): Int {
    var ua = toUnsigned16(a)
    val right = shr(ua, b)
    val left = shl(ua, 16 - b)
    return toUnsigned16(left + right)
}

/**
 * Auto-generated from Mochi
 * @param a Int
 * @param b Int
 */
fun bitwise(a: Int, b: Int): Unit {
    println("a:   " + bin16(a))
    println("b:   " + bin16(b))
    println("and: " + bin16(bit_and(a, b)))
    println("or:  " + bin16(bit_or(a, b)))
    println("xor: " + bin16(bit_xor(a, b)))
    println("not: " + bin16(bit_not(a)))
    if (b < 0) {
        println("Right operand is negative, but all shifts require an unsigned right operand (shift distance).")
        return null
    }
    println("shl: " + bin16(shl(a, b)))
    println("shr: " + bin16(shr(a, b)))
    println("las: " + bin16(las(a, b)))
    println("ras: " + bin16(ras(a, b)))
    println("rol: " + bin16(rol(a, b)))
    println("ror: " + bin16(ror(a, b)))
}

fun main() {
    bitwise(-460, 6)
}
