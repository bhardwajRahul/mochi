// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fun <T> append(list: MutableList<T>, item: T): MutableList<T> {
    val res = list.toMutableList()
    res.add(item)
    return res
}
// Code generated from abelian-sandpile-model.mochi

val dim = 16

/**
 * Auto-generated from Mochi
 * @param d Int
 * @return MutableList<MutableList<Int>>
 */
fun newPile(d: Int): MutableList<MutableList<Int>> {
    var b: MutableList<MutableList<Int>> = mutableListOf<MutableList<Int>>()
    var y = 0
    while (y < d) {
        var row: MutableList<Int> = mutableListOf<Int>()
        var x = 0
        while (x < d) {
            row = append(row, 0)
            x = x + 1
        }
        b = append(b, row)
        y = y + 1
    }
    return b
}

/**
 * Auto-generated from Mochi
 * @param pile MutableList<MutableList<Int>>
 * @param x Int
 * @param y Int
 * @return MutableList<MutableList<Int>>
 */
fun handlePile(pile: MutableList<MutableList<Int>>, x: Int, y: Int): MutableList<MutableList<Int>> {
    if ((pile[y] as MutableList<Int>)[x] >= 4) {
        pile[y]!![x] = (pile[y] as MutableList<Int>)[x] - 4
        if (y > 0) {
            pile[y - 1]!![x] = (pile[y - 1] as MutableList<Int>)[x] + 1
            if ((pile[y - 1] as MutableList<Int>)[x] >= 4) {
                pile = handlePile(pile, x, y - 1)
            }
        }
        if (x > 0) {
            pile[y]!![x - 1] = (pile[y] as MutableList<Int>)[x - 1] + 1
            if ((pile[y] as MutableList<Int>)[x - 1] >= 4) {
                pile = handlePile(pile, x - 1, y)
            }
        }
        if (y < dim - 1) {
            pile[y + 1]!![x] = (pile[y + 1] as MutableList<Int>)[x] + 1
            if ((pile[y + 1] as MutableList<Int>)[x] >= 4) {
                pile = handlePile(pile, x, y + 1)
            }
        }
        if (x < dim - 1) {
            pile[y]!![x + 1] = (pile[y] as MutableList<Int>)[x + 1] + 1
            if ((pile[y] as MutableList<Int>)[x + 1] >= 4) {
                pile = handlePile(pile, x + 1, y)
            }
        }
        pile = handlePile(pile, x, y)
    }
    return pile
}

/**
 * Auto-generated from Mochi
 * @param pile MutableList<MutableList<Int>>
 * @param d Int
 */
fun drawPile(pile: MutableList<MutableList<Int>>, d: Int): Unit {
    val chars = mutableListOf(" ", "░", "▓", "█")
    var row = 0
    while (row < d) {
        var line = ""
        var col = 0
        while (col < d) {
            var v = (pile[row] as MutableList<Int>)[col]
            if (v > 3) {
                v = 3
            }
            line = line + chars[v]
            col = col + 1
        }
        println(line)
        row = row + 1
    }
}

/**
 * Auto-generated from Mochi
 */
fun main(): Unit {
    var pile = newPile(16)
    val hdim = 7
    pile[hdim]!![hdim] = 16
    pile = handlePile(pile, hdim, hdim)
    drawPile(pile, 16)
}

