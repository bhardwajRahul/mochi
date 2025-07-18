object chaocipher {
  def indexOf(s: String, ch: String): Int = {
    var i = 0
    while (i < s.length) {
      if (s.substring(i, i + 1) == ch) {
        return i
      }
      i += 1
    }
    return -1
  }
  
  def rotate(s: String, n: Int): String = s.substring(n, s.length) + s.substring(0, n)
  
  def scrambleLeft(s: String): String = s.substring(0, 1) + s.substring(2, 14) + s.substring(1, 2) + s.substring(14, s.length)
  
  def scrambleRight(s: String): String = s.substring(1, 3) + s.substring(4, 15) + s.substring(3, 4) + s.substring(15, s.length) + s.substring(0, 1)
  
  def chao(text: String, encode: Boolean): String = {
    var left = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    var right = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
    var out = ""
    var i = 0
    while (i < text.length) {
      val ch = text.substring(i, i + 1)
      var idx = 0
      if (encode) {
        idx = indexOf(right, ch)
        out += left.substring(idx, idx + 1)
      } else {
        idx = indexOf(left, ch)
        out += right.substring(idx, idx + 1)
      }
      left = rotate(left, idx)
      right = rotate(right, idx)
      left = scrambleLeft(left)
      right = scrambleRight(right)
      i += 1
    }
    return out
  }
  
  def main() = {
    val plain = "WELLDONEISBETTERTHANWELLSAID"
    val cipher = chao(plain, true)
    println(plain)
    println(cipher)
    println(chao(cipher, false))
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
