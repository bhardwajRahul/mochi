object base64_decode_data {
  def indexOf(s: String, ch: String): Int = {
    var i = 0
    while (i < s.length) {
      if (s.charAt(i) == ch) {
        return i
      }
      i += 1
    }
    return -1
  }
  
  def parseIntStr(str: String): Int = {
    var i = 0
    var neg = false
    if (str.length > 0 && str.charAt(0) == "-") {
      neg = true
      i = 1
    }
    var n = 0
    val digits = Map("0" -> 0, "1" -> 1, "2" -> 2, "3" -> 3, "4" -> 4, "5" -> 5, "6" -> 6, "7" -> 7, "8" -> 8, "9" -> 9)
    while (i < str.length) {
      n = n * 10 + (digits).apply(str.charAt(i))
      i += 1
    }
    if (neg) {
      n = -n
    }
    return n
  }
  
  def ord(ch: String): Int = {
    val upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    val lower = "abcdefghijklmnopqrstuvwxyz"
    var idx = indexOf(upper, ch)
    if (idx >= 0) {
      return 65 + idx
    }
    idx = indexOf(lower, ch)
    if (idx >= 0) {
      return 97 + idx
    }
    if (ch >= "0" && ch <= "9") {
      return 48 + parseIntStr(ch)
    }
    if (ch == "+") {
      return 43
    }
    if (ch == "/") {
      return 47
    }
    if (ch == " ") {
      return 32
    }
    if (ch == "=") {
      return 61
    }
    return 0
  }
  
  def chr(n: Int): String = {
    val upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    val lower = "abcdefghijklmnopqrstuvwxyz"
    if (n >= 65 && n < 91) {
      return upper.substring(n - 65, n - 64)
    }
    if (n >= 97 && n < 123) {
      return lower.substring(n - 97, n - 96)
    }
    if (n >= 48 && n < 58) {
      val digits = "0123456789"
      return digits.substring(n - 48, n - 47)
    }
    if (n == 43) {
      return "+"
    }
    if (n == 47) {
      return "/"
    }
    if (n == 32) {
      return " "
    }
    if (n == 61) {
      return "="
    }
    return "?"
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
  
  def base64Encode(text: String): String = {
    val alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    var bin = ""
    for(ch <- text) {
      bin += toBinary(ord(ch), 8)
    }
    while (bin.length % 6 != 0) {
      bin += "0"
    }
    var out = ""
    var i = 0
    while (i < bin.length) {
      val chunk = bin.substring(i, i + 6)
      val val = binToInt(chunk)
      out += alphabet.substring(val, val + 1)
      i += 6
    }
    val pad = (3 - (text.length % 3)) % 3
    if (pad == 1) {
      out = out.substring(0, out.length - 1) + "="
    }
    if (pad == 2) {
      out = out.substring(0, out.length - 2) + "=="
    }
    return out
  }
  
  def base64Decode(enc: String): String = {
    val alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    var bin = ""
    var i = 0
    while (i < enc.length) {
      val ch = enc.charAt(i)
      if (ch == "=") {
        return
      }
      val idx = indexOf(alphabet, ch)
      bin += toBinary(idx, 6)
      i += 1
    }
    var out = ""
    i = 0
    while (i + 8 <= bin.length) {
      val chunk = bin.substring(i, i + 8)
      val val = binToInt(chunk)
      out += chr(val)
      i += 8
    }
    return out
  }
  
  def main(args: Array[String]): Unit = {
    val msg = "Rosetta Code Base64 decode data task"
    println("Original : " + msg)
    val enc = base64Encode(msg)
    println("\nEncoded  : " + enc)
    val dec = base64Decode(enc)
    println("\nDecoded  : " + dec)
  }
}
