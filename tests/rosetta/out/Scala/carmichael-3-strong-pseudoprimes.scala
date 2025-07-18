object carmichael_3_strong_pseudoprimes {
  def mod(n: Int, m: Int): Int = ((n % m) + m) % m
  
  def isPrime(n: Int): Boolean = {
    if (n < 2) {
      return false
    }
    if (n % 2 == 0) {
      return n == 2
    }
    if (n % 3 == 0) {
      return n == 3
    }
    var d = 5
    while (d * d <= n) {
      if (n % d == 0) {
        return false
      }
      d += 2
      if (n % d == 0) {
        return false
      }
      d += 4
    }
    return true
  }
  
  def pad(n: Int, width: Int): String = {
    var s = n.toString
    while (s.length < width) {
      s = " " + s
    }
    return s
  }
  
  def carmichael(p1: Int) = {
    for(h3 <- 2 until p1) {
      for(d <- 1 until (h3 + p1)) {
        if (((h3 + p1) * (p1 - 1)) % d == 0 && mod(-p1 * p1, h3) == d % h3) {
          val p2 = 1 + ((p1 - 1) * (h3 + p1) / d)
          if (!isPrime(p2)) {
            // continue
          }
          val p3 = 1 + (p1 * p2 / h3)
          if (!isPrime(p3)) {
            // continue
          }
          if ((p2 * p3) % (p1 - 1) != 1) {
            // continue
          }
          val c = p1 * p2 * p3
          println(pad(p1, 2) + "   " + pad(p2, 4) + "   " + pad(p3, 5) + "     " + c.toString)
        }
      }
    }
  }
  
  def main(args: Array[String]): Unit = {
    println("The following are Carmichael munbers for p1 <= 61:\n")
    println("p1     p2      p3     product")
    println("==     ==      ==     =======")
    for(p1 <- 2 until 62) {
      if (isPrime(p1)) {
        carmichael(p1)
      }
    }
  }
}
