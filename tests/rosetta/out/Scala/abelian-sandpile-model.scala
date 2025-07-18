// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
object abelian_sandpile_model {
  val dim = 16
  def newPile(d: Int): List[List[Int]] = {
    var b: List[List[Int]] = scala.collection.mutable.ArrayBuffer[List[Int]]()
    var y = 0
    while (y < d) {
      var row: List[Int] = scala.collection.mutable.ArrayBuffer[Int]()
      var x = 0
      while (x < d) {
        row = row :+ 0
        x += 1
      }
      b = b :+ row
      y += 1
    }
    return b
  }
  
  def handlePile(pile: List[List[Int]], x: Int, y: Int): List[List[Int]] = {
    if (((pile).apply(y)).apply(x) >= 4) {
      val _tmp0 = pile(y).updated(x, ((pile).apply(y)).apply(x) - 4)
      pile = pile.updated(y, _tmp0)
      if (y > 0) {
        val _tmp1 = pile(y - 1).updated(x, ((pile).apply(y - 1)).apply(x) + 1)
        pile = pile.updated(y - 1, _tmp1)
        if (((pile).apply(y - 1)).apply(x) >= 4) {
          pile = handlePile(pile, x, y - 1)
        }
      }
      if (x > 0) {
        val _tmp2 = pile(y).updated(x - 1, ((pile).apply(y)).apply(x - 1) + 1)
        pile = pile.updated(y, _tmp2)
        if (((pile).apply(y)).apply(x - 1) >= 4) {
          pile = handlePile(pile, x - 1, y)
        }
      }
      if (y < dim - 1) {
        val _tmp3 = pile(y + 1).updated(x, ((pile).apply(y + 1)).apply(x) + 1)
        pile = pile.updated(y + 1, _tmp3)
        if (((pile).apply(y + 1)).apply(x) >= 4) {
          pile = handlePile(pile, x, y + 1)
        }
      }
      if (x < dim - 1) {
        val _tmp4 = pile(y).updated(x + 1, ((pile).apply(y)).apply(x + 1) + 1)
        pile = pile.updated(y, _tmp4)
        if (((pile).apply(y)).apply(x + 1) >= 4) {
          pile = handlePile(pile, x + 1, y)
        }
      }
      pile = handlePile(pile, x, y)
    }
    return pile
  }
  
  def drawPile(pile: List[List[Int]], d: Int) = {
    val chars = List(" ", "░", "▓", "█")
    var row = 0
    while (row < d) {
      var line = ""
      var col = 0
      while (col < d) {
        var v = ((pile).apply(row)).apply(col)
        if (v > 3) {
          v = 3
        }
        line += (chars).apply(v)
        col += 1
      }
      println(line)
      row += 1
    }
  }
  
  def main() = {
    var pile = newPile(16)
    val hdim = 7
    val _tmp5 = pile(hdim).updated(hdim, 16)
    pile = pile.updated(hdim, _tmp5)
    pile = handlePile(pile, hdim, hdim)
    drawPile(pile, 16)
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
