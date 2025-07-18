case class Colour(var R: Int, var G: Int, var B: Int)

case class Bitmap(var width: Int, var height: Int, var pixels: List[List[Colour]])

object bitmap_write_a_ppm_file {
  def newBitmap(w: Int, h: Int, c: Colour): Bitmap = {
    var rows: List[List[Colour]] = scala.collection.mutable.ArrayBuffer[Any]()
    var y = 0
    while (y < h) {
      var row: List[Colour] = scala.collection.mutable.ArrayBuffer[Any]()
      var x = 0
      while (x < w) {
        row = row :+ c
        x += 1
      }
      rows = rows :+ row
      y += 1
    }
    return Bitmap(width = w, height = h, pixels = rows)
  }
  
  def setPixel(b: Bitmap, x: Int, y: Int, c: Colour) = {
    var rows = b.pixels
    var row = (rows).apply(y)
    row(x) = c
    rows(y) = row
    b.pixels = rows
  }
  
  def fillRect(b: Bitmap, x: Int, y: Int, w: Int, h: Int, c: Colour) = {
    var yy = y
    while (yy < y + h) {
      var xx = x
      while (xx < x + w) {
        setPixel(b, xx, yy, c)
        xx += 1
      }
      yy += 1
    }
  }
  
  def pad(n: Int, width: Int): String = {
    var s = n.toString
    while (s.length < width) {
      s = " " + s
    }
    return s
  }
  
  def writePPMP3(b: Bitmap): String = {
    var maxv = 0
    var y = 0
    while (y < b.height) {
      var x = 0
      while (x < b.width) {
        val p = ((b.pixels).apply(y)).apply(x)
        if (p.R > maxv) {
          maxv = p.R
        }
        if (p.G > maxv) {
          maxv = p.G
        }
        if (p.B > maxv) {
          maxv = p.B
        }
        x += 1
      }
      y += 1
    }
    var out = "P3\n# generated from Bitmap.writeppmp3\n" + b.width.toString + " " + b.height.toString + "\n" + maxv.toString + "\n"
    var numsize = maxv.toString.length
    y = b.height - 1
    while (y >= 0) {
      var line = ""
      var x = 0
      while (x < b.width) {
        val p = ((b.pixels).apply(y)).apply(x)
        line = line + "   " + pad(p.R, numsize) + " " + pad(p.G, numsize) + " " + pad(p.B, numsize)
        x += 1
      }
      out += line
      if (y > 0) {
        out += "\n"
      } else {
        out += "\n"
      }
      y -= 1
    }
    return out
  }
  
  def main() = {
    val black = Colour(R = 0, G = 0, B = 0)
    val white = Colour(R = 255, G = 255, B = 255)
    var bm = newBitmap(4, 4, black)
    fillRect(bm, 1, 0, 1, 2, white)
    setPixel(bm, 3, 3, Colour(R = 127, G = 0, B = 63))
    val ppm = writePPMP3(bm)
    println(ppm)
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
