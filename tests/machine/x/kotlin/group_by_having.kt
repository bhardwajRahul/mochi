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
// Code generated from tests/vm/valid/group_by_having.mochi

data class People(var name: String, var city: String)

data class Big(var city: Any?, var num: Int)

val people = mutableListOf(People(name = "Alice", city = "Paris"), People(name = "Bob", city = "Hanoi"), People(name = "Charlie", city = "Paris"), People(name = "Diana", city = "Hanoi"), People(name = "Eve", city = "Paris"), People(name = "Frank", city = "Hanoi"), People(name = "George", city = "Paris"))

val big = run {
    val __groups = mutableMapOf<Any?, Group<Any?, People>>()
    val __order = mutableListOf<Any?>()
    for (p in people) {
        val __k = p.city
        var __g = __groups[__k]
        if (__g == null) {
            __g = Group(__k, mutableListOf<People>())
            __groups[__k] = __g
            __order.add(__k)
        }
        __g.add(p)
    }
    val __res = mutableListOf<Big>()
    for (k in __order) {
        val g = __groups[k]!!
        if (g.size >= 4) {
            __res.add(Big(city = g.key, num = g.size))
        }
    }
    __res
}

fun main() {
    json(big)
}
