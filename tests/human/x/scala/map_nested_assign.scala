object map_nested_assign {
  def main(args: Array[String]): Unit = {
    val data = scala.collection.mutable.Map("outer" -> scala.collection.mutable.Map("inner" -> 1))
    data("outer")("inner") = 2
    println(data("outer")("inner"))
  }
}
