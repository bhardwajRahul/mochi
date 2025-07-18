// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:18:04Z
fun String.starts_with(prefix: String): Boolean = this.startsWith(prefix)

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
// Code generated from q73.mochi

data class Customer(var c_customer_sk: Int, var c_last_name: String, var c_first_name: String, var c_salutation: String, var c_preferred_cust_flag: String)

data class Date_dim(var d_date_sk: Int, var d_dom: Int, var d_year: Int)

data class Household_demographic(var hd_demo_sk: Int, var hd_buy_potential: String, var hd_vehicle_count: Int, var hd_dep_count: Int)

data class Store(var s_store_sk: Int, var s_county: String)

data class Store_sale(var ss_ticket_number: Int, var ss_customer_sk: Int, var ss_sold_date_sk: Int, var ss_store_sk: Int, var ss_hdemo_sk: Int)

val store_sales = mutableListOf(Store_sale(ss_ticket_number = 1, ss_customer_sk = 1, ss_sold_date_sk = 1, ss_store_sk = 1, ss_hdemo_sk = 1))

val date_dim = mutableListOf(Date_dim(d_date_sk = 1, d_dom = 1, d_year = 1998))

val store = mutableListOf(Store(s_store_sk = 1, s_county = "A"))

val household_demographics = mutableListOf(Household_demographic(hd_demo_sk = 1, hd_buy_potential = "1001-5000", hd_vehicle_count = 2, hd_dep_count = 3))

val customer = mutableListOf(Customer(c_customer_sk = 1, c_last_name = "Smith", c_first_name = "Alice", c_salutation = "Ms.", c_preferred_cust_flag = "Y"))

val groups = run {
    val __groups = mutableMapOf<MutableMap<String, Any?>, Group<MutableMap<String, Any?>, MutableMap<String, Any?>>>()
    val __order = mutableListOf<MutableMap<String, Any?>>()
    for (ss in store_sales) {
        for (d in date_dim) {
            if (d.d_date_sk == ss.ss_sold_date_sk) {
                for (s in store) {
                    if (s.s_store_sk == ss.ss_store_sk) {
                        for (hd in household_demographics) {
                            if (hd.hd_demo_sk == ss.ss_hdemo_sk) {
                                if (toDouble((d.d_dom >= 1 && d.d_dom <= 2 && (hd.hd_buy_potential == "1001-5000" || hd.hd_buy_potential == "0-500") && hd.hd_vehicle_count > 0 && hd.hd_dep_count).toDouble() / (hd.hd_vehicle_count).toDouble()) > 1 && (d.d_year == 1998 || d.d_year == 1999 || d.d_year == 2000) && s.s_county == "A") {
                                    val __k = (mutableMapOf("ticket" to ss.ss_ticket_number, "cust" to ss.ss_customer_sk) as MutableMap<String, Any?>)
                                    var __g = __groups[__k]
                                    if (__g == null) {
                                        __g = Group(__k, mutableListOf<MutableMap<String, Any?>>())
                                        __groups[__k] = __g
                                        __order.add(__k)
                                    }
                                    __g.add(mutableMapOf("ss" to ss, "d" to d, "s" to s, "hd" to hd) as MutableMap<String, Any?>)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    val __res = mutableListOf<Any?>()
    for (k in __order) {
        val g = __groups[k]!!
        __res.add(mutableMapOf("key" to g.key, "cnt" to g.size))
    }
    __res
}

val result = run {
    val __res = mutableListOf<Any?>()
    for (g in groups) {
        for (c in customer) {
            if (c.c_customer_sk == ((g as MutableMap<String, Any?>)["key"] as MutableMap<*, *>)["cust"]) {
                if (toInt(toInt((g as MutableMap<String, Any?>)["cnt"]) >= 1 && (g as MutableMap<String, Any?>)["cnt"]) <= 5) {
                    __res.add(mutableMapOf("c_last_name" to c.c_last_name, "c_first_name" to c.c_first_name, "c_salutation" to c.c_salutation, "c_preferred_cust_flag" to c.c_preferred_cust_flag, "ss_ticket_number" to ((g as MutableMap<String, Any?>)["key"] as MutableMap<*, *>)["ticket"], "cnt" to (g as MutableMap<String, Any?>)["cnt"]))
                }
            }
        }
    }
    __res
}.sortedBy { mutableListOf(-(it as MutableMap<String, Any?>)["cnt"], it.c_last_name) as Comparable<Any> }

fun main() {
    json(result)
}
