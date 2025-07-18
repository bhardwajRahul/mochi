object array_concatenation {
  def concatInts(a: List[Int], b: List[Int]): List[Int] = {
    var out: List[Int] = scala.collection.mutable.ArrayBuffer[Any]()
    for(v <- a) {
      out = out :+ v
    }
    for(v <- b) {
      out = out :+ v
    }
    return out
  }
  
  def concatAny(a: List[any], b: List[any]): List[any] = {
    var out: List[any] = scala.collection.mutable.ArrayBuffer[Any]()
    for(v <- a) {
      out = out :+ v
    }
    for(v <- b) {
      out = out :+ v
    }
    return out
  }
  
  def main(args: Array[String]): Unit = {
    var a = scala.collection.mutable.ArrayBuffer(1, 2, 3)
    var b = scala.collection.mutable.ArrayBuffer(7, 12, 60)
    println(concatInts(a, b).toString)
    var i: List[any] = scala.collection.mutable.ArrayBuffer(1, 2, 3)
    var j: List[any] = scala.collection.mutable.ArrayBuffer("Crosby", "Stills", "Nash", "Young")
    println(concatAny(i, j).toString)
    var l = scala.collection.mutable.ArrayBuffer(1, 2, 3)
    var m = scala.collection.mutable.ArrayBuffer(7, 12, 60)
    println(concatInts(l, m).toString)
  }
}
