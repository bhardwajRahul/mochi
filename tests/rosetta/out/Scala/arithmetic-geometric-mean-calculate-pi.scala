object arithmetic_geometric_mean_calculate_pi {
  def abs(x: Double): Double = {
    if (x < 0) {
      return -x
    }
    return x
  }
  
  def sqrtApprox(x: Double): Double = {
    var guess = x
    var i = 0
    while (i < 20) {
      guess = (guess + x / guess) / 2
      i += 1
    }
    return guess
  }
  
  def agmPi(): Double = {
    var a = 1
    var g = 1 / sqrtApprox(2)
    var sum = 0
    var pow = 2
    while (abs(a - g) > 1e-15) {
      var t = (a + g) / 2
      var u = sqrtApprox(a * g)
      a = t
      g = u
      pow *= 2
      var diff = a * a - g * g
      sum = sum + diff * pow
    }
    var pi = 4 * a * a / (1 - sum)
    return pi
  }
  
  def main() = {
    println(agmPi().toString)
  }
  
  def main(args: Array[String]): Unit = {
    main()
  }
}
