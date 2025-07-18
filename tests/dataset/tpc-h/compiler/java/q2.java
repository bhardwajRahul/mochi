// Generated by Mochi compiler v0.10.28 on 2025-07-18T06:59:43Z
// q2.mochi
import java.util.*;

class Region {
    int r_regionkey;
    String r_name;
    Region(int r_regionkey, String r_name) {
        this.r_regionkey = r_regionkey;
        this.r_name = r_name;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Region other)) return false;
        return Objects.equals(this.r_regionkey, other.r_regionkey) && Objects.equals(this.r_name, other.r_name);
    }
    @Override public int hashCode() {
        return Objects.hash(r_regionkey, r_name);
    }
    int size() { return 2; }
}
class Nation {
    int n_nationkey;
    int n_regionkey;
    String n_name;
    Nation(int n_nationkey, int n_regionkey, String n_name) {
        this.n_nationkey = n_nationkey;
        this.n_regionkey = n_regionkey;
        this.n_name = n_name;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Nation other)) return false;
        return Objects.equals(this.n_nationkey, other.n_nationkey) && Objects.equals(this.n_regionkey, other.n_regionkey) && Objects.equals(this.n_name, other.n_name);
    }
    @Override public int hashCode() {
        return Objects.hash(n_nationkey, n_regionkey, n_name);
    }
    int size() { return 3; }
}
class Supplier {
    int s_suppkey;
    String s_name;
    String s_address;
    int s_nationkey;
    String s_phone;
    double s_acctbal;
    String s_comment;
    Supplier(int s_suppkey, String s_name, String s_address, int s_nationkey, String s_phone, double s_acctbal, String s_comment) {
        this.s_suppkey = s_suppkey;
        this.s_name = s_name;
        this.s_address = s_address;
        this.s_nationkey = s_nationkey;
        this.s_phone = s_phone;
        this.s_acctbal = s_acctbal;
        this.s_comment = s_comment;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Supplier other)) return false;
        return Objects.equals(this.s_suppkey, other.s_suppkey) && Objects.equals(this.s_name, other.s_name) && Objects.equals(this.s_address, other.s_address) && Objects.equals(this.s_nationkey, other.s_nationkey) && Objects.equals(this.s_phone, other.s_phone) && Objects.equals(this.s_acctbal, other.s_acctbal) && Objects.equals(this.s_comment, other.s_comment);
    }
    @Override public int hashCode() {
        return Objects.hash(s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment);
    }
    int size() { return 7; }
}
class Part {
    int p_partkey;
    String p_type;
    int p_size;
    String p_mfgr;
    Part(int p_partkey, String p_type, int p_size, String p_mfgr) {
        this.p_partkey = p_partkey;
        this.p_type = p_type;
        this.p_size = p_size;
        this.p_mfgr = p_mfgr;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Part other)) return false;
        return Objects.equals(this.p_partkey, other.p_partkey) && Objects.equals(this.p_type, other.p_type) && Objects.equals(this.p_size, other.p_size) && Objects.equals(this.p_mfgr, other.p_mfgr);
    }
    @Override public int hashCode() {
        return Objects.hash(p_partkey, p_type, p_size, p_mfgr);
    }
    int size() { return 4; }
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
class EuropeSupplier {
    Supplier s;
    Nation n;
    EuropeSupplier(Supplier s, Nation n) {
        this.s = s;
        this.n = n;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof EuropeSupplier other)) return false;
        return Objects.equals(this.s, other.s) && Objects.equals(this.n, other.n);
    }
    @Override public int hashCode() {
        return Objects.hash(s, n);
    }
    int size() { return 2; }
}
class TargetPartsupp {
    double s_acctbal;
    String s_name;
    String n_name;
    int p_partkey;
    String p_mfgr;
    String s_address;
    String s_phone;
    String s_comment;
    double ps_supplycost;
    TargetPartsupp(double s_acctbal, String s_name, String n_name, int p_partkey, String p_mfgr, String s_address, String s_phone, String s_comment, double ps_supplycost) {
        this.s_acctbal = s_acctbal;
        this.s_name = s_name;
        this.n_name = n_name;
        this.p_partkey = p_partkey;
        this.p_mfgr = p_mfgr;
        this.s_address = s_address;
        this.s_phone = s_phone;
        this.s_comment = s_comment;
        this.ps_supplycost = ps_supplycost;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof TargetPartsupp other)) return false;
        return Objects.equals(this.s_acctbal, other.s_acctbal) && Objects.equals(this.s_name, other.s_name) && Objects.equals(this.n_name, other.n_name) && Objects.equals(this.p_partkey, other.p_partkey) && Objects.equals(this.p_mfgr, other.p_mfgr) && Objects.equals(this.s_address, other.s_address) && Objects.equals(this.s_phone, other.s_phone) && Objects.equals(this.s_comment, other.s_comment) && Objects.equals(this.ps_supplycost, other.ps_supplycost);
    }
    @Override public int hashCode() {
        return Objects.hash(s_acctbal, s_name, n_name, p_partkey, p_mfgr, s_address, s_phone, s_comment, ps_supplycost);
    }
    int size() { return 9; }
}
public class Q2 {
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
        List<Region> region = new ArrayList<>(Arrays.asList(new Region(1, "EUROPE"), new Region(2, "ASIA")));
        List<Nation> nation = new ArrayList<>(Arrays.asList(new Nation(10, 1, "FRANCE"), new Nation(20, 2, "CHINA")));
        List<Supplier> supplier = new ArrayList<>(Arrays.asList(new Supplier(100, "BestSupplier", "123 Rue", 10, "123", 1000.000000, "Fast and reliable"), new Supplier(200, "AltSupplier", "456 Way", 20, "456", 500.000000, "Slow")));
        List<Part> part = new ArrayList<>(Arrays.asList(new Part(1000, "LARGE BRASS", 15, "M1"), new Part(2000, "SMALL COPPER", 15, "M2")));
        List<Partsupp> partsupp = new ArrayList<>(Arrays.asList(new Partsupp(1000, 100, 10.000000), new Partsupp(1000, 200, 15.000000)));
        List<Nation> europe_nations = (new java.util.function.Supplier<List<Nation>>(){public List<Nation> get(){
    List<Nation> res0 = new ArrayList<>();
    for (var r : region) {
        for (var n : nation) {
            if (!(n.n_regionkey == r.r_regionkey)) continue;
            if (!(Objects.equals(r.r_name, "EUROPE"))) continue;
            res0.add(n);
        }
    }
    return res0;
}}).get();
        List<EuropeSupplier> europe_suppliers = (new java.util.function.Supplier<List<EuropeSupplier>>(){public List<EuropeSupplier> get(){
    List<EuropeSupplier> res1 = new ArrayList<>();
    for (var s : supplier) {
        for (var n : europe_nations) {
            if (!(s.s_nationkey == n.n_nationkey)) continue;
            res1.add(new EuropeSupplier(s, n));
        }
    }
    return res1;
}}).get();
        List<Part> target_parts = (new java.util.function.Supplier<List<Part>>(){public List<Part> get(){
    List<Part> res2 = new ArrayList<>();
    for (var p : part) {
        if (!(p.p_size == 15 && Objects.equals(p.p_type, "LARGE BRASS"))) continue;
        res2.add(p);
    }
    return res2;
}}).get();
        List<TargetPartsupp> target_partsupp = (new java.util.function.Supplier<List<TargetPartsupp>>(){public List<TargetPartsupp> get(){
    List<TargetPartsupp> res3 = new ArrayList<>();
    for (var ps : partsupp) {
        for (var p : target_parts) {
            if (!(ps.ps_partkey == p.p_partkey)) continue;
            for (var s : europe_suppliers) {
                if (!(ps.ps_suppkey == s.s.s_suppkey)) continue;
                res3.add(new TargetPartsupp(s.s.s_acctbal, s.s.s_name, s.n.n_name, p.p_partkey, p.p_mfgr, s.s.s_address, s.s.s_phone, s.s.s_comment, ps.ps_supplycost));
            }
        }
    }
    return res3;
}}).get();
        List<Double> costs = (new java.util.function.Supplier<List<Double>>(){public List<Double> get(){
    List<Double> res4 = new ArrayList<>();
    for (var x : target_partsupp) {
        res4.add(x.ps_supplycost);
    }
    return res4;
}}).get();
        double min_cost = costs.stream().mapToDouble(n -> ((Number)n).doubleValue()).min().orElse(Double.MAX_VALUE);
        List<TargetPartsupp> result = (new java.util.function.Supplier<List<TargetPartsupp>>(){public List<TargetPartsupp> get(){
    List<TargetPartsupp> res5 = new ArrayList<>();
    for (var x : target_partsupp) {
        if (!(x.ps_supplycost == min_cost)) continue;
        res5.add(x);
    }
    return res5;
}}).get();
        json(result);
        if (!(Objects.equals(result, Arrays.asList(new TargetPartsupp(1000.000000, "BestSupplier", "FRANCE", 1000, "M1", "123 Rue", "123", "Fast and reliable", 10.000000))))) throw new AssertionError("expect failed");
    }
}
