object bioinformatics_global_alignment {
  def padLeft(s: String, w: Int): String = {
    var res = ""
    var n = w - s.length
    while (n > 0) {
      res += " "
      n -= 1
    }
    return res + s
  }
  
  def indexOfFrom(s: String, ch: String, start: Int): Int = {
    var i = start
    while (i < s.length) {
      if (s.substring(i, i + 1) == ch) {
        return i
      }
      i += 1
    }
    return -1
  }
  
  def containsStr(s: String, sub: String): Boolean = {
    var i = 0
    val sl = s.length
    val subl = sub.length
    while (i <= sl - subl) {
      if (s.substring(i, i + subl) == sub) {
        return true
      }
      i += 1
    }
    return false
  }
  
  def distinct(slist: List[String]): List[String] = {
    var res: List[String] = scala.collection.mutable.ArrayBuffer[Any]()
    for(s <- slist) {
      var found = false
      for(r <- res) {
        if (r == s) {
          found = true
          return
        }
      }
      if (!found) {
        res = res :+ s
      }
    }
    return res
  }
  
  def permutations(xs: List[String]): List[List[String]] = {
    if (xs.length <= 1) {
      return List(xs)
    }
    var res: List[List[String]] = scala.collection.mutable.ArrayBuffer[Any]()
    var i = 0
    while (i < xs.length) {
      var rest: List[String] = scala.collection.mutable.ArrayBuffer[Any]()
      var j = 0
      while (j < xs.length) {
        if (j != i) {
          rest = rest :+ (xs).apply(j)
        }
        j += 1
      }
      val subs = permutations(rest)
      for(p <- subs) {
        var perm: List[String] = scala.collection.mutable.ArrayBuffer((xs).apply(i))
        var k = 0
        while (k < p.length) {
          perm = perm :+ (p).apply(k)
          k += 1
        }
        res = res :+ perm
      }
      i += 1
    }
    return res
  }
  
  def headTailOverlap(s1: String, s2: String): Int = {
    var start = 0
    while (true) {
      val ix = indexOfFrom(s1, s2.substring(0, 1), start)
      if (ix == 0 - 1) {
        return 0
      }
      start = ix
      if (s2.substring(0, s1.length - start) == s1.substring(start, s1.length)) {
        return s1.length - start
      }
      start += 1
    }
  }
  
  def deduplicate(slist: List[String]): List[String] = {
    val arr = distinct(slist)
    var filtered: List[String] = scala.collection.mutable.ArrayBuffer[Any]()
    var i = 0
    while (i < arr.length) {
      val s1 = (arr).apply(i)
      var within = false
      var j = 0
      while (j < arr.length) {
        if (j != i && containsStr((arr).apply(j), s1)) {
          within = true
          return
        }
        j += 1
      }
      if (!within) {
        filtered = filtered :+ s1
      }
      i += 1
    }
    return filtered
  }
  
  def joinAll(ss: List[String]): String = {
    var out = ""
    for(s <- ss) {
      out += s
    }
    return out
  }
  
  def shortestCommonSuperstring(slist: List[String]): String = {
    val ss = deduplicate(slist)
    var shortest = joinAll(ss)
    val perms = permutations(ss)
    var idx = 0
    while (idx < perms.length) {
      val perm = (perms).apply(idx)
      var sup = (perm).apply(0)
      var i = 0
      while (i < ss.length - 1) {
        val ov = headTailOverlap((perm).apply(i), (perm).apply(i + 1))
        sup += (perm).apply(i + 1).substring(ov, (perm).apply(i + 1).length)
        i += 1
      }
      if (sup.length < shortest.length) {
        shortest = sup
      }
      idx += 1
    }
    return shortest
  }
  
  def printCounts(seq: String) = {
    var a = 0
    var c = 0
    var g = 0
    var t = 0
    var i = 0
    while (i < seq.length) {
      val ch = seq.substring(i, i + 1)
      if (ch == "A") {
        a += 1
      } else {
        if (ch == "C") {
          c += 1
        } else {
          if (ch == "G") {
            g += 1
          } else {
            if (ch == "T") {
              t += 1
            }
          }
        }
      }
      i += 1
    }
    val total = seq.length
    println("\nNucleotide counts for " + seq + ":\n")
    println(padLeft("A", 10) + padLeft(a.toString, 12))
    println(padLeft("C", 10) + padLeft(c.toString, 12))
    println(padLeft("G", 10) + padLeft(g.toString, 12))
    println(padLeft("T", 10) + padLeft(t.toString, 12))
    println(padLeft("Other", 10) + padLeft(total - (a + c + g + t).toString, 12))
    println("  ____________________")
    println(padLeft("Total length", 14) + padLeft(total.toString, 8))
  }
  
  def main() = {
    val tests: List[List[String]] = List(List("TA", "AAG", "TA", "GAA", "TA"), List("CATTAGGG", "ATTAG", "GGG", "TA"), List("AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"), List("ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT", "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT", "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA", "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC", "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT", "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC", "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT", "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC", "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC", "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT", "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC", "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA", "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA"))
    for(seqs <- tests) {
      val scs = shortestCommonSuperstring(seqs)
      printCounts(scs)
    }
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
