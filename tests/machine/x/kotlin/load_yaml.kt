// Generated by Mochi compiler v0.10.28 on 2025-07-18T07:47:43Z
data class Row0(var name: String, var email: String)

fun _load(path: String?, opts: Map<String, Any?>?): MutableList<MutableMap<String, Any?>> {
    val fmt = opts?.get("format") as? String ?: "csv"
    val lines = if (path == null || path == "-") {
        listOf<String>()
    } else {
        var f = java.io.File(path)
        if (!f.isAbsolute) {
            if (!f.exists()) {
                System.getenv("MOCHI_ROOT")?.let { root ->
                    var clean = path!!
                    while (clean.startsWith("../")) clean = clean.substring(3)
                    var cand = java.io.File(root + "/tests/" + clean)
                    if (!cand.exists()) cand = java.io.File(root + "/" + clean)
                    f = cand
                }
            }
        }
        if (f.exists()) f.readLines() else listOf<String>()
    }
    return when (fmt) {
        "yaml" -> loadYamlSimple(lines)
        else -> mutableListOf()
    }
}

fun loadYamlSimple(lines: List<String>): MutableList<MutableMap<String, Any?>> {
    val res = mutableListOf<MutableMap<String, Any?>>()
    var cur: MutableMap<String, Any?>? = null
    for (ln in lines) {
        val t = ln.trim()
        if (t.startsWith("- ")) {
            cur?.let { res.add(it) }
            cur = mutableMapOf()
            val idx = t.indexOf(':', 2)
            if (idx >= 0) {
                val k = t.substring(2, idx).trim()
                val v = parseSimpleValue(t.substring(idx + 1))
                cur!![k] = v
            }
        } else if (t.contains(':')) {
            val idx = t.indexOf(':')
            val k = t.substring(0, idx).trim()
            val v = parseSimpleValue(t.substring(idx + 1))
            cur?.set(k, v)
        }
    }
    cur?.let { res.add(it) }
    return res
}

fun parseSimpleValue(s: String): Any? {
    val t = s.trim()
    return when {
        t.matches(Regex("^-?\\d+$")) -> t.toInt()
        t.matches(Regex("^-?\\d+\\.\\d+$")) -> t.toDouble()
        t.equals("true", true) -> true
        t.equals("false", true) -> false
        t.startsWith("\"") && t.endsWith("\"") -> t.substring(1, t.length - 1)
        else -> t
    }
}
// Code generated from load_yaml.mochi

data class Person(var name: String, var age: Int, var email: String)

val people = _load("../interpreter/valid/people.yaml", mutableMapOf("format" to "yaml")).map { Person(name = it["name"] as String, age = it["age"] as Int, email = it["email"] as String) }.toMutableList()

val adults = run {
    val __res = mutableListOf<Row0>()
    for (p in people) {
        if (p.age >= 18) {
            __res.add(Row0(name = p.name, email = p.email))
        }
    }
    __res
}

fun main() {
    for (a in adults) {
        println(listOf(a.name, a.email).joinToString(" "))
    }
}

