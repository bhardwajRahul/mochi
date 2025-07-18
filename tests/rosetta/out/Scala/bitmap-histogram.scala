object bitmap_histogram {
  def image(): List[List[Int]] = List(List(0, 0, 10000), List(65535, 65535, 65535), List(65535, 65535, 65535))
  
  def histogram(g: List[List[Int]], bins: Int): List[Int] = {
    if (bins <= 0) {
      bins = (g).apply(0).length
    }
    var h: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    var i = 0
    while (i < bins) {
      h = h :+ 0
      i += 1
    }
    var y = 0
    while (y < g.length) {
      var row = (g).apply(y)
      var x = 0
      while (x < row.length) {
        var p = (row).apply(x)
        var idx = ((p * (bins - 1)) / 65535).toInt
        h(idx) = (h).apply(idx) + 1
        x += 1
      }
      y += 1
    }
    return h
  }
  
  def medianThreshold(h: List[Int]): Int = {
    var lb = 0
    var ub = h.length - 1
    var lSum = 0
    var uSum = 0
    while (lb <= ub) {
      if (lSum + (h).apply(lb) < uSum + (h).apply(ub)) {
        lSum += (h).apply(lb)
        lb += 1
      } else {
        uSum += (h).apply(ub)
        ub -= 1
      }
    }
    return ((ub * 65535) / h.length).toInt
  }
  
  def threshold(g: List[List[Int]], t: Int): List[List[Int]] = {
    var out: List[List[Int]] = scala.collection.mutable.ArrayBuffer[Any]()
    var y = 0
    while (y < g.length) {
      var row = (g).apply(y)
      var newRow: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
      var x = 0
      while (x < row.length) {
        if ((row).apply(x) < t) {
          newRow = newRow :+ 0
        } else {
          newRow = newRow :+ 65535
        }
        x += 1
      }
      out = out :+ newRow
      y += 1
    }
    return out
  }
  
  def printImage(g: List[List[Int]]) = {
    var y = 0
    while (y < g.length) {
      var row = (g).apply(y)
      var line = ""
      var x = 0
      while (x < row.length) {
        if ((row).apply(x) == 0) {
          line += "0"
        } else {
          line += "1"
        }
        x += 1
      }
      println(line)
      y += 1
    }
  }
  
  def main() = {
    val img = image()
    val h = histogram(img, 0)
    println("Histogram: " + h.toString)
    val t = medianThreshold(h)
    println("Threshold: " + t.toString)
    val bw = threshold(img, t)
    printImage(bw)
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
