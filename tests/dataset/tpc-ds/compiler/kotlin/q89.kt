// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:19:01Z
fun sum(list: List<Any?>): Number {
    var s = 0.0
    var allInt = true
    for (n in list) {
        val d = toDouble(n)
        if (d % 1.0 != 0.0) allInt = false
        s += d
    }
    return if (allInt) s.toInt() else s
}

fun String.starts_with(prefix: String): Boolean = this.startsWith(prefix)

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
// Code generated from q89.mochi

data class Store_sale(var price: Double)

val store_sales = mutableListOf(Store_sale(price = 40.0), Store_sale(price = 30.0), Store_sale(price = 19.0))

val result = sum(run {
    val __res = mutableListOf<Double>()
    for (s in store_sales) {
        __res.add(s.price)
    }
    __res
})

fun main() {
    json(result)
}
