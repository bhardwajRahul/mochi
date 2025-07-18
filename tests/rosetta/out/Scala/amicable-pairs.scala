// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
object amicable_pairs {
  def pfacSum(i: Int): Int = {
    var sum = 0
    var p = 1
    while (p <= i / 2) {
      if (i % p == 0) {
        sum += p
      }
      p += 1
    }
    return sum
  }
  
  def pad(n: Int, width: Int): String = {
    var s = n.toString
    while (s.length < width) {
      s = " " + s
    }
    return s
  }
  
  def main() = {
    var sums: List[Int] = scala.collection.mutable.ArrayBuffer[Int]()
    var i = 0
    while (i < 20000) {
      sums = sums :+ 0
      i += 1
    }
    i = 1
    while (i < 20000) {
      sums(i) = pfacSum(i)
      i += 1
    }
    println("The amicable pairs below 20,000 are:")
    var n = 2
    while (n < 19999) {
      val m = (sums).apply(n)
      if (m > n && m < 20000 && n == (sums).apply(m)) {
        println("  " + pad(n, 5) + " and " + pad(m, 5))
      }
      n += 1
    }
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
