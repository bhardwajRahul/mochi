// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:21:49Z
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
// Code generated from q11.mochi

data class Customer(var c_customer_sk: Int, var c_customer_id: String, var c_first_name: String, var c_last_name: String)

data class StoreSale(var ss_customer_sk: Int, var ss_sold_date_sk: Int, var ss_ext_list_price: Double)

data class WebSale(var ws_bill_customer_sk: Int, var ws_sold_date_sk: Int, var ws_ext_list_price: Double)

data class Customer(var c_customer_sk: Int, var c_customer_id: String, var c_first_name: String, var c_last_name: String)

data class Store_sale(var ss_customer_sk: Int, var ss_sold_date_sk: Int, var ss_ext_list_price: Double)

data class Web_sale(var ws_bill_customer_sk: Int, var ws_sold_date_sk: Int, var ws_ext_list_price: Double)

val customer = mutableListOf(Customer(c_customer_sk = 1, c_customer_id = "C1", c_first_name = "John", c_last_name = "Doe"))

val store_sales = mutableListOf(Store_sale(ss_customer_sk = 1, ss_sold_date_sk = 1998, ss_ext_list_price = 60.0), Store_sale(ss_customer_sk = 1, ss_sold_date_sk = 1999, ss_ext_list_price = 90.0))

val web_sales = mutableListOf(Web_sale(ws_bill_customer_sk = 1, ws_sold_date_sk = 1998, ws_ext_list_price = 50.0), Web_sale(ws_bill_customer_sk = 1, ws_sold_date_sk = 1999, ws_ext_list_price = 150.0))

val ss98 = sum(run {
    val __res = mutableListOf<Double>()
    for (ss in store_sales) {
        if (ss.ss_sold_date_sk == 1998) {
            __res.add(ss.ss_ext_list_price)
        }
    }
    __res
})

val ss99 = sum(run {
    val __res = mutableListOf<Double>()
    for (ss in store_sales) {
        if (ss.ss_sold_date_sk == 1999) {
            __res.add(ss.ss_ext_list_price)
        }
    }
    __res
})

val ws98 = sum(run {
    val __res = mutableListOf<Double>()
    for (ws in web_sales) {
        if (ws.ws_sold_date_sk == 1998) {
            __res.add(ws.ws_ext_list_price)
        }
    }
    __res
})

val ws99 = sum(run {
    val __res = mutableListOf<Double>()
    for (ws in web_sales) {
        if (ws.ws_sold_date_sk == 1999) {
            __res.add(ws.ws_ext_list_price)
        }
    }
    __res
})

val growth_ok = toDouble(toDouble(toDouble(ws98) > 0 && ss98) > 0 && (toDouble(ws99) / toDouble(ws98))) > toDouble((toDouble(ss99) / toDouble(ss98)))

val result = if (growth_ok) mutableListOf(mutableMapOf("customer_id" to "C1", "customer_first_name" to "John", "customer_last_name" to "Doe")) else mutableListOf()

fun main() {
    json(result)
}
