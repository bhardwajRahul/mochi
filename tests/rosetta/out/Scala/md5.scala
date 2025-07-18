object md5 {
  def main(args: Array[String]): Unit = {
    object testpkg {
      def Add(a: Int, b: Int): Int = a + b
      val Pi: Double = 3.14
      val Answer: Int = 42
    }
    
    for(pair <- List(List("d41d8cd98f00b204e9800998ecf8427e", ""), List("0cc175b9c0f1b6a831c399e269772661", "a"), List("900150983cd24fb0d6963f7d28e17f72", "abc"), List("f96b697d7cb7938d525a2f31aaf161d0", "message digest"), List("c3fcd3d76192e4007dfb496cca67e13b", "abcdefghijklmnopqrstuvwxyz"), List("d174ab98d277d9f5a5611c2c9f419d9f", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"), List("57edf4a22be3c955ac49da2e2107b67a", "12345678901234567890" + "123456789012345678901234567890123456789012345678901234567890"), List("e38ca1d920c4b8b8d3946b2c72f01680", "The quick brown fox jumped over the lazy dog's back"))) {
      val sum = testpkg.MD5Hex((pair).apply(1))
      if ((sum).asInstanceOf[Int] != (pair).apply(0)) {
        println("MD5 fail")
        println(s"  for string, ${(pair).apply(1)}")
        println(s"  expected:   ${(pair).apply(0)}")
        println(s"  got:        ${sum}")
      }
    }
  }
}
