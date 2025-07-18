// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
object almost_prime {
  def kPrime(n: Int, k: Int): Boolean = {
    var nf = 0
    var i = 2
    while (i <= n) {
      while (n % i == 0) {
        if (nf == k) {
          return false
        }
        nf += 1
        n /= i
      }
      i += 1
    }
    return nf == k
  }
  
  def gen(k: Int, count: Int): List[Int] = {
    var r: List[Int] = scala.collection.mutable.ArrayBuffer[Int]()
    var n = 2
    while (r.length < count) {
      if (kPrime(n, k)) {
        r = r :+ n
      }
      n += 1
    }
    return r
  }
  
  def main() = {
    var k = 1
    while (k <= 5) {
      println(k.toString + " " + gen(k, 10).toString)
      k += 1
    }
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
