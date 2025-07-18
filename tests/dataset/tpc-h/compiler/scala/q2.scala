// Generated by Mochi compiler v0.10.28 on 2025-07-18T03:34:48Z
object q2 {
  case class EuropeSupplier(s: Supplier, n: Nation)
  case class Nation(n_nationkey: Int, n_regionkey: Int, n_name: String)
  case class Part(p_partkey: Int, p_type: String, p_size: Int, p_mfgr: String)
  case class Partsupp(ps_partkey: Int, ps_suppkey: Int, ps_supplycost: Double)
  case class Region(r_regionkey: Int, r_name: String)
  case class Supplier(s_suppkey: Int, s_name: String, s_address: String, s_nationkey: Int, s_phone: String, s_acctbal: Double, s_comment: String)
  case class TargetPartsupp(s_acctbal: Double, s_name: String, n_name: String, p_partkey: Int, p_mfgr: String, s_address: String, s_phone: String, s_comment: String, ps_supplycost: Double)

  def main(args: Array[String]): Unit = {
    val region = List(Region(r_regionkey = 1, r_name = "EUROPE"), Region(r_regionkey = 2, r_name = "ASIA"))
    val nation = List(Nation(n_nationkey = 10, n_regionkey = 1, n_name = "FRANCE"), Nation(n_nationkey = 20, n_regionkey = 2, n_name = "CHINA"))
    val supplier = List(Supplier(s_suppkey = 100, s_name = "BestSupplier", s_address = "123 Rue", s_nationkey = 10, s_phone = "123", s_acctbal = 1000, s_comment = "Fast and reliable"), Supplier(s_suppkey = 200, s_name = "AltSupplier", s_address = "456 Way", s_nationkey = 20, s_phone = "456", s_acctbal = 500, s_comment = "Slow"))
    val part = List(Part(p_partkey = 1000, p_type = "LARGE BRASS", p_size = 15, p_mfgr = "M1"), Part(p_partkey = 2000, p_type = "SMALL COPPER", p_size = 15, p_mfgr = "M2"))
    val partsupp = List(Partsupp(ps_partkey = 1000, ps_suppkey = 100, ps_supplycost = 10), Partsupp(ps_partkey = 1000, ps_suppkey = 200, ps_supplycost = 15))
    val europe_nations = for { r: Region <- region; n: Nation <- nation; if (n.n_regionkey).asInstanceOf[Int] == r.r_regionkey; if r.r_name == "EUROPE" } yield n
    val europe_suppliers = for { s: Supplier <- supplier; n: Nation <- europe_nations; if s.s_nationkey == (n.n_nationkey).asInstanceOf[Int] } yield EuropeSupplier(s = s, n = n)
    val target_parts = for { p: Part <- part; if p.p_size == 15 && p.p_type == "LARGE BRASS" } yield p
    val target_partsupp = for { ps: Partsupp <- partsupp; p: Part <- target_parts; if ps.ps_partkey == (p.p_partkey).asInstanceOf[Int]; s: EuropeSupplier <- europe_suppliers; if ps.ps_suppkey == (s.s.s_suppkey).asInstanceOf[Int] } yield TargetPartsupp(s_acctbal = s.s.s_acctbal, s_name = s.s.s_name, n_name = s.n.n_name, p_partkey = p.p_partkey, p_mfgr = p.p_mfgr, s_address = s.s.s_address, s_phone = s.s.s_phone, s_comment = s.s.s_comment, ps_supplycost = ps.ps_supplycost)
    val costs = for { x: TargetPartsupp <- target_partsupp } yield x.ps_supplycost
    val min_cost = costs.min
    val result = (for { x: TargetPartsupp <- target_partsupp; if x.ps_supplycost == min_cost } yield x).sortBy(x => -x.s_acctbal).map(x => x)
    println(scala.util.parsing.json.JSONArray(result.asInstanceOf[List[Any]]).toString())
    assert(result == List(TargetPartsupp(s_acctbal = 1000, s_name = "BestSupplier", n_name = "FRANCE", p_partkey = 1000, p_mfgr = "M1", s_address = "123 Rue", s_phone = "123", s_comment = "Fast and reliable", ps_supplycost = 10)))
  }
}
