// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fun <T> append(list: MutableList<T>, item: T): MutableList<T> {
    val res = list.toMutableList()
    res.add(item)
    return res
}
// Code generated from bitmap-histogram.mochi

/**
 * Auto-generated from Mochi
 * @return MutableList<MutableList<Int>>
 */
fun image(): MutableList<MutableList<Int>> {
    return mutableListOf(mutableListOf(0, 0, 10000), mutableListOf(65535, 65535, 65535), mutableListOf(65535, 65535, 65535))
}

/**
 * Auto-generated from Mochi
 * @param g MutableList<MutableList<Int>>
 * @param bins Int
 * @return MutableList<Int>
 */
fun histogram(g: MutableList<MutableList<Int>>, bins: Int): MutableList<Int> {
    if (bins <= 0) {
        bins = g[0].size
    }
    var h: MutableList<Int> = mutableListOf<Int>()
    var i = 0
    while (i < bins) {
        h = append(h, 0)
        i = i + 1
    }
    var y = 0
    while (y < g.size) {
        var row = g[y]
        var x = 0
        while (x < row.size) {
            var p = row[x]
            var idx = ((((p * (bins - 1))).toDouble() / (65535).toDouble())).toInt()
            h[idx] = h[idx] + 1
            x = x + 1
        }
        y = y + 1
    }
    return h
}

/**
 * Auto-generated from Mochi
 * @param h MutableList<Int>
 * @return Int
 */
fun medianThreshold(h: MutableList<Int>): Int {
    var lb = 0
    var ub = h.size - 1
    var lSum = 0
    var uSum = 0
    while (lb <= ub) {
        if (lSum + h[lb] < uSum + h[ub]) {
            lSum = lSum + h[lb]
            lb = lb + 1
        }
        else {
            uSum = uSum + h[ub]
            ub = ub - 1
        }
    }
    return ((((ub * 65535)).toDouble() / (h.size).toDouble())).toInt()
}

/**
 * Auto-generated from Mochi
 * @param g MutableList<MutableList<Int>>
 * @param t Int
 * @return MutableList<MutableList<Int>>
 */
fun threshold(g: MutableList<MutableList<Int>>, t: Int): MutableList<MutableList<Int>> {
    var out: MutableList<MutableList<Int>> = mutableListOf<MutableList<Int>>()
    var y = 0
    while (y < g.size) {
        var row = g[y]
        var newRow: MutableList<Int> = mutableListOf<Int>()
        var x = 0
        while (x < row.size) {
            if (row[x] < t) {
                newRow = append(newRow, 0)
            }
            else {
                newRow = append(newRow, 65535)
            }
            x = x + 1
        }
        out = append(out, newRow)
        y = y + 1
    }
    return out
}

/**
 * Auto-generated from Mochi
 * @param g MutableList<MutableList<Int>>
 */
fun printImage(g: MutableList<MutableList<Int>>): Unit {
    var y = 0
    while (y < g.size) {
        var row = g[y]
        var line = ""
        var x = 0
        while (x < row.size) {
            if (row[x] == 0) {
                line = line + "0"
            }
            else {
                line = line + "1"
            }
            x = x + 1
        }
        println(line)
        y = y + 1
    }
}

/**
 * Auto-generated from Mochi
 */
fun main(): Unit {
    val img = image()
    val h = histogram(img, 0)
    println("Histogram: " + h.toString())
    val t = medianThreshold(h)
    println("Threshold: " + t.toString())
    val bw = threshold(img, t)
    printImage(bw)
}

