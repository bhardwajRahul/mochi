object arithmetic_derivative {
  def primeFactors(n: Int): List[Int] = {
    var factors: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    var x = n
    while (x % 2 == 0) {
      factors = factors :+ 2
      x = (x / 2).toInt
    }
    var p = 3
    while (p * p <= x) {
      while (x % p == 0) {
        factors = factors :+ p
        x = (x / p).toInt
      }
      p += 2
    }
    if (x > 1) {
      factors = factors :+ x
    }
    return factors
  }
  
  def repeat(ch: String, n: Int): String = {
    var s = ""
    var i = 0
    while (i < n) {
      s += ch
      i += 1
    }
    return s
  }
  
  def D(n: Double): Double = {
    if (n < 0) {
      return -D(-n)
    }
    if (n < 2) {
      return 0
    }
    var factors: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    if (n < 1e+19) {
      factors = primeFactors((n).toInt)
    } else {
      val g = (n / 100).toInt
      factors = primeFactors(g)
      factors = factors :+ 2
      factors = factors :+ 2
      factors = factors :+ 5
      factors = factors :+ 5
    }
    val c = factors.length
    if (c == 1) {
      return 1
    }
    if (c == 2) {
      return ((factors).apply(0) + (factors).apply(1)).toDouble
    }
    val d = n / ((factors).apply(0).toDouble)
    return D(d) * ((factors).apply(0).toDouble) + d
  }
  
  def pad(n: Int): String = {
    var s = n.toString
    while (s.length < 4) {
      s = " " + s
    }
    return s
  }
  
  def main() = {
    var vals: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    var n = -99
    while (n < 101) {
      vals = vals :+ (D(n.toDouble)).toInt
      n += 1
    }
    var i = 0
    while (i < vals.length) {
      var line = ""
      var j = 0
      while (j < 10) {
        line += pad((vals).apply(i + j))
        if (j < 9) {
          line += " "
        }
        j += 1
      }
      println(line)
      i += 10
    }
    var pow = 1
    var m = 1
    while (m < 21) {
      pow *= 10
      var exp = m.toString
      if (exp.length < 2) {
        exp += " "
      }
      var res = m.toString + repeat("0", m - 1)
      println("D(10^" + exp + ") / 7 = " + res)
      m += 1
    }
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
