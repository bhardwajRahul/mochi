object balanced_ternary {
  def trimLeftZeros(s: String): String = {
    var i = 0
    while (i < s.length && s.substring(i, i + 1) == "0") {
      i += 1
    }
    return s.substring(i, s.length)
  }
  
  def btString(s: String): Map[String, any] = {
    s = trimLeftZeros(s)
    var b: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    var i = s.length - 1
    while (i >= 0) {
      val ch = s.substring(i, i + 1)
      if (ch == "+") {
        b = b :+ 1
      } else {
        if (ch == "0") {
          b = b :+ 0
        } else {
          if (ch == "-") {
            b = b :+ 0 - 1
          } else {
            return Map("bt" -> List(), "ok" -> false)
          }
        }
      }
      i -= 1
    }
    return Map("bt" -> b, "ok" -> true)
  }
  
  def btToString(b: List[Int]): String = {
    if (b.length == 0) {
      return "0"
    }
    var r = ""
    var i = b.length - 1
    while (i >= 0) {
      val d = (b).apply(i)
      if (d == 0 - 1) {
        r += "-"
      } else {
        if (d == 0) {
          r += "0"
        } else {
          r += "+"
        }
      }
      i -= 1
    }
    return r
  }
  
  def btInt(i: Int): List[Int] = {
    if (i == 0) {
      return List()
    }
    var n = i
    var b: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    while (n != 0) {
      var m = n % 3
      n = (n / 3).toInt
      if (m == 2) {
        m = 0 - 1
        n += 1
      } else {
        if (m == 0 - 2) {
          m = 1
          n -= 1
        }
      }
      b = b :+ m
    }
    return b
  }
  
  def btToInt(b: List[Int]): Int = {
    var r = 0
    var pt = 1
    var i = 0
    while (i < b.length) {
      r = r + (b).apply(i) * pt
      pt *= 3
      i += 1
    }
    return r
  }
  
  def btNeg(b: List[Int]): List[Int] = {
    var r: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    var i = 0
    while (i < b.length) {
      r = r :+ -(b).apply(i)
      i += 1
    }
    return r
  }
  
  def btAdd(a: List[Int], b: List[Int]): List[Int] = btInt(btToInt(a) + btToInt(b))
  
  def btMul(a: List[Int], b: List[Int]): List[Int] = btInt(btToInt(a) * btToInt(b))
  
  def padLeft(s: String, w: Int): String = {
    var r = s
    while (r.length < w) {
      r = " " + r
    }
    return r
  }
  
  def show(label: String, b: List[Int]) = {
    val l = padLeft(label, 7)
    val bs = padLeft(btToString(b), 12)
    val is = padLeft(btToInt(b).toString, 7)
    println(l + " " + bs + " " + is)
  }
  
  def main() = {
    val ares = btString("+-0++0+")
    val a = (ares).apply("bt")
    val b = btInt(-436)
    val cres = btString("+-++-")
    val c = (cres).apply("bt")
    show("a:", a)
    show("b:", b)
    show("c:", c)
    show("a(b-c):", btMul(a, btAdd(b, btNeg(c))))
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
