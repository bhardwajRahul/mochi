// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:19:11Z
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
// Code generated from q92.mochi

data class WebSale(var ws_item_sk: Int, var ws_sold_date_sk: Int, var ws_ext_discount_amt: Double)

data class Date_dim(var d_date_sk: Int, var d_date: String)

data class Item(var i_item_sk: Int, var i_manufact_id: Int)

data class Web_sale(var ws_item_sk: Int, var ws_sold_date_sk: Int, var ws_ext_discount_amt: Double)

val web_sales = mutableListOf(Web_sale(ws_item_sk = 1, ws_sold_date_sk = 1, ws_ext_discount_amt = 1.0), Web_sale(ws_item_sk = 1, ws_sold_date_sk = 1, ws_ext_discount_amt = 1.0), Web_sale(ws_item_sk = 1, ws_sold_date_sk = 1, ws_ext_discount_amt = 2.0))

val item = mutableListOf(Item(i_item_sk = 1, i_manufact_id = 1))

val date_dim = mutableListOf(Date_dim(d_date_sk = 1, d_date = "2000-01-02"))

val sum_amt = sum(run {
    val __res = mutableListOf<Double>()
    for (ws in web_sales) {
        __res.add(ws.ws_ext_discount_amt)
    }
    __res
})

val avg_amt = run { val r = run {
    val __res = mutableListOf<Double>()
    for (ws in web_sales) {
        __res.add(ws.ws_ext_discount_amt)
    }
    __res
}.map{ toDouble(it) }.average(); if (r % 1.0 == 0.0) r.toInt() else r }

val result = if (toDouble(toDouble(sum_amt) > toDouble(avg_amt)) * toDouble(1.3)) sum_amt else 0.0

fun main() {
    json(result)
}
