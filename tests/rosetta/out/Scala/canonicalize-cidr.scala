object canonicalize_cidr {
  def split(s: String, sep: String): List[String] = {
    var parts: List[String] = scala.collection.mutable.ArrayBuffer[Any]()
    var cur = ""
    var i = 0
    while (i < s.length) {
      if ((sep.length > 0 && i + sep.length).asInstanceOf[Int] <= s.length && s.substring(i, i + sep.length) == sep) {
        parts = parts :+ cur
        cur = ""
        i += sep.length
      } else {
        cur += s.substring(i, i + 1)
        i += 1
      }
    }
    parts = parts :+ cur
    return parts
  }
  
  def join(xs: List[String], sep: String): String = {
    var res = ""
    var i = 0
    while (i < xs.length) {
      if (i > 0) {
        res += sep
      }
      res += (xs).apply(i)
      i += 1
    }
    return res
  }
  
  def repeat(ch: String, n: Int): String = {
    var out = ""
    var i = 0
    while (i < n) {
      out += ch
      i += 1
    }
    return out
  }
  
  def parseIntStr(str: String): Int = {
    var i = 0
    var neg = false
    if (str.length > 0 && str.substring(0, 1) == "-") {
      neg = true
      i = 1
    }
    var n = 0
    val digits = Map("0" -> 0, "1" -> 1, "2" -> 2, "3" -> 3, "4" -> 4, "5" -> 5, "6" -> 6, "7" -> 7, "8" -> 8, "9" -> 9)
    while (i < str.length) {
      n = n * 10 + (digits).apply(str.substring(i, i + 1))
      i += 1
    }
    if (neg) {
      n = -n
    }
    return n
  }
  
  def toBinary(n: Int, bits: Int): String = {
    var b = ""
    var val = n
    var i = 0
    while (i < bits) {
      b = val % 2.toString + b
      val = (val / 2).toInt
      i += 1
    }
    return b
  }
  
  def binToInt(bits: String): Int = {
    var n = 0
    var i = 0
    while (i < bits.length) {
      n = n * 2 + parseIntStr(bits.substring(i, i + 1))
      i += 1
    }
    return n
  }
  
  def padRight(s: String, width: Int): String = {
    var out = s
    while (out.length < width) {
      out += " "
    }
    return out
  }
  
  def canonicalize(cidr: String): String = {
    val parts = split(cidr, "/")
    val dotted = (parts).apply(0)
    val size = parseIntStr((parts).apply(1))
    var binParts: List[String] = scala.collection.mutable.ArrayBuffer[Any]()
    for(p <- split(dotted, ".")) {
      binParts = binParts :+ toBinary(parseIntStr(p), 8)
    }
    var binary = join(binParts, "")
    binary = binary.substring(0, size) + repeat("0", 32 - size)
    var canonParts: List[String] = scala.collection.mutable.ArrayBuffer[Any]()
    var i = 0
    while (i < binary.length) {
      canonParts = canonParts :+ binToInt(binary.substring(i, i + 8)).toString
      i += 8
    }
    return join(canonParts, ".") + "/" + (parts).apply(1)
  }
  
  def main(args: Array[String]): Unit = {
    val tests = List("87.70.141.1/22", "36.18.154.103/12", "62.62.197.11/29", "67.137.119.181/4", "161.214.74.21/24", "184.232.176.184/18")
    for(t <- tests) {
      println(padRight(t, 18) + " -> " + canonicalize(t))
    }
  }
}
