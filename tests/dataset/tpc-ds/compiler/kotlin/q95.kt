// Generated by Mochi compiler v0.10.26 on 2025-07-15T07:19:19Z
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
// Code generated from q95.mochi

data class WebSale(var ws_order_number: Int, var ws_warehouse_sk: Int, var ws_ship_date_sk: Int, var ws_ship_addr_sk: Int, var ws_web_site_sk: Int, var ws_ext_ship_cost: Double, var ws_net_profit: Double)

data class WebReturn(var wr_order_number: Int)

data class DateDim(var d_date_sk: Int, var d_date: String)

data class CustomerAddress(var ca_address_sk: Int, var ca_state: String)

data class WebSite(var web_site_sk: Int, var web_company_name: String)

data class Customer_addres(var ca_address_sk: Int, var ca_state: String)

data class Date_dim(var d_date_sk: Int, var d_date: String)

data class Web_return(var wr_order_number: Int)

data class Web_sale(var ws_order_number: Int, var ws_warehouse_sk: Int, var ws_ship_date_sk: Int, var ws_ship_addr_sk: Int, var ws_web_site_sk: Int, var ws_ext_ship_cost: Double, var ws_net_profit: Double)

data class Web_site(var web_site_sk: Int, var web_company_name: String)

val web_sales = mutableListOf(Web_sale(ws_order_number = 1, ws_warehouse_sk = 1, ws_ship_date_sk = 1, ws_ship_addr_sk = 1, ws_web_site_sk = 1, ws_ext_ship_cost = 2.0, ws_net_profit = 5.0), Web_sale(ws_order_number = 1, ws_warehouse_sk = 2, ws_ship_date_sk = 1, ws_ship_addr_sk = 1, ws_web_site_sk = 1, ws_ext_ship_cost = 0.0, ws_net_profit = 0.0))

val web_returns = mutableListOf(Web_return(wr_order_number = 1))

val date_dim = mutableListOf(Date_dim(d_date_sk = 1, d_date = "2001-02-01"))

val customer_address = mutableListOf(Customer_addres(ca_address_sk = 1, ca_state = "CA"))

val web_site = mutableListOf(Web_site(web_site_sk = 1, web_company_name = "pri"))

val ws_wh = run {
    val __res = mutableListOf<Any?>()
    for (ws1 in web_sales) {
        for (ws2 in web_sales) {
            if (ws1.ws_order_number == ws2.ws_order_number && ws1.ws_warehouse_sk != ws2.ws_warehouse_sk) {
                __res.add(mutableMapOf("ws_order_number" to ws1.ws_order_number))
            }
        }
    }
    __res
}

val filtered = run {
    val __res = mutableListOf<Web_sale>()
    for (ws in web_sales) {
        for (d in date_dim) {
            if (ws.ws_ship_date_sk == d.d_date_sk) {
                for (ca in customer_address) {
                    if (ws.ws_ship_addr_sk == ca.ca_address_sk) {
                        for (w in web_site) {
                            if (ws.ws_web_site_sk == w.web_site_sk) {
                                if (ca.ca_state == "CA" && w.web_company_name == "pri" && ws.ws_order_number in (run {
    val __res = mutableListOf<Any?>()
    for (x in ws_wh) {
        __res.add((x as MutableMap<String, Any?>)["ws_order_number"])
    }
    __res
}) && ws.ws_order_number in (run {
    val __res = mutableListOf<Int>()
    for (wr in web_returns) {
        __res.add(wr.wr_order_number)
    }
    __res
})) {
                                    __res.add(ws)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    __res
}

val result = mutableMapOf("order_count" to distinct(run {
    val __res = mutableListOf<Int>()
    for (x in filtered) {
        __res.add(x.ws_order_number)
    }
    __res
}).size, "total_shipping_cost" to sum(run {
    val __res = mutableListOf<Double>()
    for (x in filtered) {
        __res.add(x.ws_ext_ship_cost)
    }
    __res
}), "total_net_profit" to sum(run {
    val __res = mutableListOf<Double>()
    for (x in filtered) {
        __res.add(x.ws_net_profit)
    }
    __res
}))

/**
 * Auto-generated from Mochi
 * @param xs MutableList<Any>
 * @return MutableList<Any>
 */
fun distinct(xs: MutableList<Any>): MutableList<Any> {
    var out = mutableListOf()
    for (x in xs) {
        if (!contains(out, x)) {
            out = out + x
        }
    }
    return out
}

fun main() {
    json(result)
}
