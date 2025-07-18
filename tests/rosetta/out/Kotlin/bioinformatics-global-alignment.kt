// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fun <T> append(list: MutableList<T>, item: T): MutableList<T> {
    val res = list.toMutableList()
    res.add(item)
    return res
}
// Code generated from bioinformatics-global-alignment.mochi

/**
 * Auto-generated from Mochi
 * @param s String
 * @param w Int
 * @return String
 */
fun padLeft(s: String, w: Int): String {
    var res = ""
    var n = w - s.length
    while (n > 0) {
        res = res + " "
        n = n - 1
    }
    return res + s
}

/**
 * Auto-generated from Mochi
 * @param s String
 * @param ch String
 * @param start Int
 * @return Int
 */
fun indexOfFrom(s: String, ch: String, start: Int): Int {
    var i = start
    while (i < s.length) {
        if (s.substring(i, i + 1) == ch) {
            return i
        }
        i = i + 1
    }
    return -1
}

/**
 * Auto-generated from Mochi
 * @param s String
 * @param sub String
 * @return Boolean
 */
fun containsStr(s: String, sub: String): Boolean {
    var i = 0
    val sl = s.length
    val subl = sub.length
    while (i <= sl - subl) {
        if (s.substring(i, i + subl) == sub) {
            return true
        }
        i = i + 1
    }
    return false
}

/**
 * Auto-generated from Mochi
 * @param slist MutableList<String>
 * @return MutableList<String>
 */
fun distinct(slist: MutableList<String>): MutableList<String> {
    var res: MutableList<String> = mutableListOf<String>()
    for (s in slist) {
        var found = false
        for (r in res) {
            if (r == s) {
                found = true
                break
            }
        }
        if (!found) {
            res = append(res, s)
        }
    }
    return res
}

/**
 * Auto-generated from Mochi
 * @param xs MutableList<String>
 * @return MutableList<MutableList<String>>
 */
fun permutations(xs: MutableList<String>): MutableList<MutableList<String>> {
    if (xs.size <= 1) {
        return mutableListOf(xs)
    }
    var res: MutableList<MutableList<String>> = mutableListOf<MutableList<String>>()
    var i = 0
    while (i < xs.size) {
        var rest: MutableList<String> = mutableListOf<String>()
        var j = 0
        while (j < xs.size) {
            if (j != i) {
                rest = append(rest, xs[j])
            }
            j = j + 1
        }
        val subs = permutations(rest)
        for (p in subs) {
            var perm: MutableList<String> = mutableListOf(xs[i])
            var k = 0
            while (k < p.size) {
                perm = append(perm, p[k])
                k = k + 1
            }
            res = append(res, perm)
        }
        i = i + 1
    }
    return res
}

/**
 * Auto-generated from Mochi
 * @param s1 String
 * @param s2 String
 * @return Int
 */
fun headTailOverlap(s1: String, s2: String): Int {
    var start = 0
    while (true) {
        val ix = indexOfFrom(s1, s2.substring(0, 1), start)
        if (ix == 0 - 1) {
            return 0
        }
        start = ix
        if (s2.substring(0, s1.length - start) == s1.substring(start, s1.length)) {
            return s1.length - start
        }
        start = start + 1
    }
}

/**
 * Auto-generated from Mochi
 * @param slist MutableList<String>
 * @return MutableList<String>
 */
fun deduplicate(slist: MutableList<String>): MutableList<String> {
    val arr = distinct(slist)
    var filtered: MutableList<String> = mutableListOf<String>()
    var i = 0
    while (i < arr.size) {
        val s1 = arr[i]
        var within = false
        var j = 0
        while (j < arr.size) {
            if (j != i && containsStr(arr[j], s1)) {
                within = true
                break
            }
            j = j + 1
        }
        if (!within) {
            filtered = append(filtered, s1)
        }
        i = i + 1
    }
    return filtered
}

/**
 * Auto-generated from Mochi
 * @param ss MutableList<String>
 * @return String
 */
fun joinAll(ss: MutableList<String>): String {
    var out = ""
    for (s in ss) {
        out = out + s
    }
    return out
}

/**
 * Auto-generated from Mochi
 * @param slist MutableList<String>
 * @return String
 */
fun shortestCommonSuperstring(slist: MutableList<String>): String {
    val ss = deduplicate(slist)
    var shortest = joinAll(ss)
    val perms = permutations(ss)
    var idx = 0
    while (idx < perms.size) {
        val perm = perms[idx]
        var sup = perm[0]
        var i = 0
        while (i < ss.size - 1) {
            val ov = headTailOverlap(perm[i], perm[i + 1])
            sup = sup + perm[i + 1].substring(ov, perm[i + 1].size)
            i = i + 1
        }
        if (sup.length < shortest.length) {
            shortest = sup
        }
        idx = idx + 1
    }
    return shortest
}

/**
 * Auto-generated from Mochi
 * @param seq String
 */
fun printCounts(seq: String): Unit {
    var a = 0
    var c = 0
    var g = 0
    var t = 0
    var i = 0
    while (i < seq.length) {
        val ch = seq.substring(i, i + 1)
        if (ch == "A") {
            a = a + 1
        }
        else {
            if (ch == "C") {
                c = c + 1
            }
            else {
                if (ch == "G") {
                    g = g + 1
                }
                else {
                    if (ch == "T") {
                        t = t + 1
                    }
                }
            }
        }
        i = i + 1
    }
    val total = seq.length
    println("\nNucleotide counts for " + seq + ":\n")
    println(padLeft("A", 10) + padLeft(a.toString(), 12))
    println(padLeft("C", 10) + padLeft(c.toString(), 12))
    println(padLeft("G", 10) + padLeft(g.toString(), 12))
    println(padLeft("T", 10) + padLeft(t.toString(), 12))
    println(padLeft("Other", 10) + padLeft(total - (a + c + g + t).toString(), 12))
    println("  ____________________")
    println(padLeft("Total length", 14) + padLeft(total.toString(), 8))
}

/**
 * Auto-generated from Mochi
 */
fun main(): Unit {
    val tests: MutableList<MutableList<String>> = mutableListOf(mutableListOf("TA", "AAG", "TA", "GAA", "TA"), mutableListOf("CATTAGGG", "ATTAG", "GGG", "TA"), mutableListOf("AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"), mutableListOf("ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT", "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT", "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA", "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC", "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT", "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC", "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT", "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC", "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC", "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT", "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC", "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA", "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA"))
    for (seqs in tests) {
        val scs = shortestCommonSuperstring(seqs)
        printCounts(scs)
    }
}

