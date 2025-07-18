// Generated by Mochi compiler v0.10.28 on 2025-07-18T06:59:50Z
// q9.mochi
import java.util.*;

class Nation {
    int n_nationkey;
    String n_name;
    Nation(int n_nationkey, String n_name) {
        this.n_nationkey = n_nationkey;
        this.n_name = n_name;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Nation other)) return false;
        return Objects.equals(this.n_nationkey, other.n_nationkey) && Objects.equals(this.n_name, other.n_name);
    }
    @Override public int hashCode() {
        return Objects.hash(n_nationkey, n_name);
    }
    int size() { return 2; }
}
class Supplier {
    int s_suppkey;
    int s_nationkey;
    Supplier(int s_suppkey, int s_nationkey) {
        this.s_suppkey = s_suppkey;
        this.s_nationkey = s_nationkey;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Supplier other)) return false;
        return Objects.equals(this.s_suppkey, other.s_suppkey) && Objects.equals(this.s_nationkey, other.s_nationkey);
    }
    @Override public int hashCode() {
        return Objects.hash(s_suppkey, s_nationkey);
    }
    int size() { return 2; }
}
class Part {
    int p_partkey;
    String p_name;
    Part(int p_partkey, String p_name) {
        this.p_partkey = p_partkey;
        this.p_name = p_name;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Part other)) return false;
        return Objects.equals(this.p_partkey, other.p_partkey) && Objects.equals(this.p_name, other.p_name);
    }
    @Override public int hashCode() {
        return Objects.hash(p_partkey, p_name);
    }
    int size() { return 2; }
}
class Partsupp {
    int ps_partkey;
    int ps_suppkey;
    double ps_supplycost;
    Partsupp(int ps_partkey, int ps_suppkey, double ps_supplycost) {
        this.ps_partkey = ps_partkey;
        this.ps_suppkey = ps_suppkey;
        this.ps_supplycost = ps_supplycost;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Partsupp other)) return false;
        return Objects.equals(this.ps_partkey, other.ps_partkey) && Objects.equals(this.ps_suppkey, other.ps_suppkey) && Objects.equals(this.ps_supplycost, other.ps_supplycost);
    }
    @Override public int hashCode() {
        return Objects.hash(ps_partkey, ps_suppkey, ps_supplycost);
    }
    int size() { return 3; }
}
class Order {
    int o_orderkey;
    String o_orderdate;
    Order(int o_orderkey, String o_orderdate) {
        this.o_orderkey = o_orderkey;
        this.o_orderdate = o_orderdate;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Order other)) return false;
        return Objects.equals(this.o_orderkey, other.o_orderkey) && Objects.equals(this.o_orderdate, other.o_orderdate);
    }
    @Override public int hashCode() {
        return Objects.hash(o_orderkey, o_orderdate);
    }
    int size() { return 2; }
}
class Lineitem {
    int l_orderkey;
    int l_partkey;
    int l_suppkey;
    int l_quantity;
    double l_extendedprice;
    double l_discount;
    Lineitem(int l_orderkey, int l_partkey, int l_suppkey, int l_quantity, double l_extendedprice, double l_discount) {
        this.l_orderkey = l_orderkey;
        this.l_partkey = l_partkey;
        this.l_suppkey = l_suppkey;
        this.l_quantity = l_quantity;
        this.l_extendedprice = l_extendedprice;
        this.l_discount = l_discount;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Lineitem other)) return false;
        return Objects.equals(this.l_orderkey, other.l_orderkey) && Objects.equals(this.l_partkey, other.l_partkey) && Objects.equals(this.l_suppkey, other.l_suppkey) && Objects.equals(this.l_quantity, other.l_quantity) && Objects.equals(this.l_extendedprice, other.l_extendedprice) && Objects.equals(this.l_discount, other.l_discount);
    }
    @Override public int hashCode() {
        return Objects.hash(l_orderkey, l_partkey, l_suppkey, l_quantity, l_extendedprice, l_discount);
    }
    int size() { return 6; }
}
class Result {
    Lineitem l;
    Part p;
    Supplier s;
    Partsupp ps;
    Order o;
    Nation n;
    Result(Lineitem l, Part p, Supplier s, Partsupp ps, Order o, Nation n) {
        this.l = l;
        this.p = p;
        this.s = s;
        this.ps = ps;
        this.o = o;
        this.n = n;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Result other)) return false;
        return Objects.equals(this.l, other.l) && Objects.equals(this.p, other.p) && Objects.equals(this.s, other.s) && Objects.equals(this.ps, other.ps) && Objects.equals(this.o, other.o) && Objects.equals(this.n, other.n);
    }
    @Override public int hashCode() {
        return Objects.hash(l, p, s, ps, o, n);
    }
    int size() { return 6; }
}
class NationOYear {
    String nation;
    int o_year;
    NationOYear(String nation, int o_year) {
        this.nation = nation;
        this.o_year = o_year;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof NationOYear other)) return false;
        return Objects.equals(this.nation, other.nation) && Objects.equals(this.o_year, other.o_year);
    }
    @Override public int hashCode() {
        return Objects.hash(nation, o_year);
    }
    int size() { return 2; }
}
class NationOYearProfit {
    String nation;
    String o_year;
    int profit;
    NationOYearProfit(String nation, String o_year, int profit) {
        this.nation = nation;
        this.o_year = o_year;
        this.profit = profit;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof NationOYearProfit other)) return false;
        return Objects.equals(this.nation, other.nation) && Objects.equals(this.o_year, other.o_year) && Objects.equals(this.profit, other.profit);
    }
    @Override public int hashCode() {
        return Objects.hash(nation, o_year, profit);
    }
    int size() { return 3; }
}
public class Q9 {
    static class Group<K,V> implements Iterable<V> {
        K key;
        List<V> items;
        Group(K key, List<V> items) { this.key = key; this.items = items; }
        public Iterator<V> iterator() { return items.iterator(); }
        int size() { return items.size(); }
    }
    static Map<String,Object> asMap(Object o) {
        if (o instanceof Map<?,?> mm) {
            LinkedHashMap<String,Object> m = new LinkedHashMap<>();
            for (Map.Entry<?,?> e : mm.entrySet()) m.put(String.valueOf(e.getKey()), e.getValue());
            return m;
        }
        LinkedHashMap<String,Object> m = new LinkedHashMap<>();
        for (var f : o.getClass().getDeclaredFields()) { try { f.setAccessible(true); m.put(f.getName(), f.get(o)); } catch (Exception e) { throw new RuntimeException(e); } }
        return m;
    }
    static void saveJsonl(List<?> list) {
        for (Object obj : list) {
            Map<String,Object> m = asMap(obj);
            List<String> parts = new ArrayList<>();
            for (Map.Entry<?,?> e : m.entrySet()) { parts.add("\"" + e.getKey() + "\":" + e.getValue()); }
            System.out.println("{" + String.join(",", parts) + "}");
        }
    }
    static String toJson(Object o) {
        if (o instanceof Map<?,?> m) {
            StringJoiner j = new StringJoiner(",", "{", "}");
            for (Map.Entry<?,?> e : m.entrySet()) j.add("\"" + e.getKey() + "\":" + toJson(e.getValue()));
            return j.toString();
        } else if (o instanceof Collection<?> c) {
            StringJoiner j = new StringJoiner(",", "[", "]");
            for (var x : c) j.add(toJson(x));
            return j.toString();
        } else if (o instanceof String s) {
            return "\"" + s + "\"";
        } else if (o instanceof Number || o instanceof Boolean || o instanceof Character) {
            return String.valueOf(o);
        } else {
            Map<String,Object> m = asMap(o);
            StringJoiner j = new StringJoiner(",", "{", "}");
            for (Map.Entry<String,Object> e : m.entrySet()) j.add("\"" + e.getKey() + "\":" + toJson(e.getValue()));
            return j.toString();
        }
    }
    static void json(Object o) { System.out.println(toJson(o)); }
    public static void main(String[] args) {
        List<Nation> nation = new ArrayList<>(Arrays.asList(new Nation(1, "BRAZIL"), new Nation(2, "CANADA")));
        List<Supplier> supplier = new ArrayList<>(Arrays.asList(new Supplier(100, 1), new Supplier(200, 2)));
        List<Part> part = new ArrayList<>(Arrays.asList(new Part(1000, "green metal box"), new Part(2000, "red plastic crate")));
        List<Partsupp> partsupp = new ArrayList<>(Arrays.asList(new Partsupp(1000, 100, 10.000000), new Partsupp(1000, 200, 8.000000)));
        List<Order> orders = new ArrayList<>(Arrays.asList(new Order(1, "1995-02-10"), new Order(2, "1997-01-01")));
        List<Lineitem> lineitem = new ArrayList<>(Arrays.asList(new Lineitem(1, 1000, 100, 5, 1000.000000, 0.100000), new Lineitem(2, 1000, 200, 10, 800.000000, 0.050000)));
        String prefix = "green";
        String start_date = "1995-01-01";
        String end_date = "1996-12-31";
        List<NationOYearProfit> result = (new java.util.function.Supplier<List<NationOYearProfit>>(){public List<NationOYearProfit> get(){
    List<NationOYearProfit> res0 = new ArrayList<>();
    Map<NationOYear,List<Result>> groups1 = new LinkedHashMap<>();
    for (var l : lineitem) {
        for (var p : part) {
            if (!(p.p_partkey == l.l_partkey)) continue;
            for (var s : supplier) {
                if (!(s.s_suppkey == l.l_suppkey)) continue;
                for (var ps : partsupp) {
                    if (!(ps.ps_partkey == l.l_partkey && ps.ps_suppkey == l.l_suppkey)) continue;
                    for (var o : orders) {
                        if (!(o.o_orderkey == l.l_orderkey)) continue;
                        for (var n : nation) {
                            if (!(n.n_nationkey == s.s_nationkey)) continue;
                            if (!(Objects.equals(p.p_name.substring(0, prefix.length()), prefix) && String.valueOf(o.o_orderdate).compareTo(String.valueOf(start_date)) >= 0 && String.valueOf(o.o_orderdate).compareTo(String.valueOf(end_date)) <= 0)) continue;
                            Result row2 = new Result(l, p, s, ps, o, n);
                            NationOYear key3 = new NationOYear(n.n_name, Integer.parseInt(o.o_orderdate.substring(0, 4)));
                            List<Result> bucket4 = groups1.get(key3);
                            if (bucket4 == null) { bucket4 = new ArrayList<>(); groups1.put(key3, bucket4); }
                            bucket4.add(row2);
                        }
                    }
                }
            }
        }
    }
    for (Map.Entry<NationOYear,List<Result>> __e : groups1.entrySet()) {
        NationOYear g_key = __e.getKey();
        Group<NationOYear,Result> g = new Group<>(g_key, __e.getValue());
        res0.add(new NationOYearProfit(g.key.nation, String.valueOf(g.key.o_year), (new java.util.function.Supplier<List<Integer>>(){public List<Integer> get(){
    List<Integer> res5 = new ArrayList<>();
    for (var x : g) {
        res5.add((x.l.l_extendedprice * (1 - x.l.l_discount)) - (x.ps.ps_supplycost * x.l.l_quantity));
    }
    return res5;
}}).get().stream().mapToInt(n -> ((Number)n).intValue()).sum()));
    }
    return res0;
}}).get();
        json(result);
        double revenue = 1000.000000 * 0.900000;
        double cost = 5 * 10.000000;
        if (!(Objects.equals(result, Arrays.asList(new NationOYearProfit("BRAZIL", "1995", revenue - cost))))) throw new AssertionError("expect failed");
    }
}
