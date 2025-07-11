fun sum(list: List<Any?>): Int {
    var s = 0
    for (n in list) s += toInt(n)
    return s
}

fun toInt(v: Any?): Int = when (v) {
    is Int -> v
    is Double -> v.toInt()
    is String -> v.toInt()
    is Boolean -> if (v) 1 else 0
    else -> 0
}

fun toDouble(v: Any?): Double = when (v) {
    is Double -> v
    is Int -> v.toDouble()
    is String -> v.toDouble()
    else -> 0.0
}

fun json(v: Any?) {
    println(toJson(v))
}

fun toJson(v: Any?): String = when (v) {
    null -> "null"
    is String -> "\"" + v.replace("\"", "\\\"") + "\""
    is Boolean, is Number -> v.toString()
    is Map<*, *> -> v.entries.joinToString(prefix = "{", postfix = "}") { toJson(it.key.toString()) + ":" + toJson(it.value) }
    is Iterable<*> -> v.joinToString(prefix = "[", postfix = "]") { toJson(it) }
    else -> toJson(v.toString())
}

class Group<K, T>(val key: K, val items: MutableList<T>) : MutableList<T> by items
// Code generated from tests/dataset/tpc-h/q1.mochi

data class Lineitem(var l_quantity: Int, var l_extendedprice: Double, var l_discount: Double, var l_tax: Double, var l_returnflag: String, var l_linestatus: String, var l_shipdate: String)

data class Result(var returnflag: Any?, var linestatus: Any?, var sum_qty: Int, var sum_base_price: Int, var sum_disc_price: Int, var sum_charge: Int, var avg_qty: Double, var avg_price: Double, var avg_disc: Double, var count_order: Int)

val lineitem = mutableListOf(Lineitem(l_quantity = 17, l_extendedprice = 1000.0, l_discount = 0.05, l_tax = 0.07, l_returnflag = "N", l_linestatus = "O", l_shipdate = "1998-08-01"), Lineitem(l_quantity = 36, l_extendedprice = 2000.0, l_discount = 0.1, l_tax = 0.05, l_returnflag = "N", l_linestatus = "O", l_shipdate = "1998-09-01"), Lineitem(l_quantity = 25, l_extendedprice = 1500.0, l_discount = 0.0, l_tax = 0.08, l_returnflag = "R", l_linestatus = "F", l_shipdate = "1998-09-03"))

val result = run {
    val __groups = mutableMapOf<Any?, Group<Any?, Lineitem>>()
    val __order = mutableListOf<Any?>()
    for (row in lineitem) {
        if (row.l_shipdate <= "1998-09-02") {
            val __k = mutableMapOf("returnflag" to row.l_returnflag, "linestatus" to row.l_linestatus)
            var __g = __groups[__k]
            if (__g == null) {
                __g = Group(__k, mutableListOf<Lineitem>())
                __groups[__k] = __g
                __order.add(__k)
            }
            __g.add(row)
        }
    }
    val __res = mutableListOf<Result>()
    for (k in __order) {
        val g = __groups[k]!!
        __res.add(Result(returnflag = g.key.returnflag, linestatus = g.key.linestatus, sum_qty = sum(run {
    val __res = mutableListOf<Int>()
    for (x in g) {
        __res.add(x.l_quantity)
    }
    __res
}), sum_base_price = sum(run {
    val __res = mutableListOf<Double>()
    for (x in g) {
        __res.add(x.l_extendedprice)
    }
    __res
}), sum_disc_price = sum(run {
    val __res = mutableListOf<Lineitem>()
    for (x in g) {
        __res.add(x.l_extendedprice * (1 - x.l_discount))
    }
    __res
}), sum_charge = sum(run {
    val __res = mutableListOf<Lineitem>()
    for (x in g) {
        __res.add(x.l_extendedprice * (1 - x.l_discount) * (1 + x.l_tax))
    }
    __res
}), avg_qty = run {
    val __res = mutableListOf<Int>()
    for (x in g) {
        __res.add(x.l_quantity)
    }
    __res
}.map{ toDouble(it) }.average(), avg_price = run {
    val __res = mutableListOf<Double>()
    for (x in g) {
        __res.add(x.l_extendedprice)
    }
    __res
}.map{ toDouble(it) }.average(), avg_disc = run {
    val __res = mutableListOf<Double>()
    for (x in g) {
        __res.add(x.l_discount)
    }
    __res
}.map{ toDouble(it) }.average(), count_order = g.size))
    }
    __res
}

fun main() {
    json(result)
    check(result == mutableListOf(mutableMapOf("returnflag" to "N", "linestatus" to "O", "sum_qty" to 53, "sum_base_price" to 3000, "sum_disc_price" to 950.0 + 1800.0, "sum_charge" to (950.0 * 1.07) + (1800.0 * 1.05), "avg_qty" to 26.5, "avg_price" to 1500, "avg_disc" to 0.07500000000000001, "count_order" to 2)))
}
