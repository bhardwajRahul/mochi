// group_by_join.mochi
import java.util.*;

class IdName {
    int id;
    String name;
    IdName(int id, String name) {
        this.id = id;
        this.name = name;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof IdName other)) return false;
        return Objects.equals(this.id, other.id) && Objects.equals(this.name, other.name);
    }
    @Override public int hashCode() {
        return Objects.hash(id, name);
    }
    int size() { return 2; }
}
class IdCustomerId {
    int id;
    int customerId;
    IdCustomerId(int id, int customerId) {
        this.id = id;
        this.customerId = customerId;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof IdCustomerId other)) return false;
        return Objects.equals(this.id, other.id) && Objects.equals(this.customerId, other.customerId);
    }
    @Override public int hashCode() {
        return Objects.hash(id, customerId);
    }
    int size() { return 2; }
}
class NameCount {
    Object name;
    int count;
    NameCount(Object name, int count) {
        this.name = name;
        this.count = count;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof NameCount other)) return false;
        return Objects.equals(this.name, other.name) && Objects.equals(this.count, other.count);
    }
    @Override public int hashCode() {
        return Objects.hash(name, count);
    }
    int size() { return 2; }
}
class OC {
    IdCustomerId o;
    IdName c;
    OC(IdCustomerId o, IdName c) {
        this.o = o;
        this.c = c;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OC other)) return false;
        return Objects.equals(this.o, other.o) && Objects.equals(this.c, other.c);
    }
    @Override public int hashCode() {
        return Objects.hash(o, c);
    }
    int size() { return 2; }
}
public class GroupByJoin {
    static class Group<K,V> implements Iterable<V> {
        K key;
        List<V> items;
        Group(K key, List<V> items) { this.key = key; this.items = items; }
        public Iterator<V> iterator() { return items.iterator(); }
        int size() { return items.size(); }
    }
    public static void main(String[] args) {
    List<IdName> customers = new ArrayList<>(Arrays.asList(new IdName(1, "Alice"), new IdName(2, "Bob")));
    List<IdCustomerId> orders = new ArrayList<>(Arrays.asList(new IdCustomerId(100, 1), new IdCustomerId(101, 1), new IdCustomerId(102, 2)));
    List<NameCount> stats = (new java.util.function.Supplier<List<NameCount>>(){public List<NameCount> get(){
    List<NameCount> res0 = new ArrayList<>();
    Map<String,List<OC>> groups1 = new LinkedHashMap<>();
    for (var o : orders) {
        for (var c : customers) {
            if (!(Objects.equals(o.customerId, c.id))) continue;
            OC row2 = new OC(o, c);
            String key3 = c.name;
            List<OC> bucket4 = groups1.get(key3);
            if (bucket4 == null) { bucket4 = new ArrayList<>(); groups1.put(key3, bucket4); }
            bucket4.add(row2);
        }
    }
    for (Map.Entry<String,List<OC>> __e : groups1.entrySet()) {
        String g_key = __e.getKey();
        Group<String,OC> g = new Group<>(g_key, __e.getValue());
        res0.add(new NameCount(g.key, g.size()));
    }
    return res0;
}}).get();
    System.out.println("--- Orders per customer ---");
    for (NameCount s : stats) {
        System.out.println(s.name + " " + "orders:" + " " + s.count);
    }
    }
}
