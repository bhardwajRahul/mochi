// group_by_left_join.mochi
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
class CO {
    IdName c;
    IdCustomerId o;
    CO(IdName c, IdCustomerId o) {
        this.c = c;
        this.o = o;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CO other)) return false;
        return Objects.equals(this.c, other.c) && Objects.equals(this.o, other.o);
    }
    @Override public int hashCode() {
        return Objects.hash(c, o);
    }
    int size() { return 2; }
}
public class GroupByLeftJoin {
    static class Group<K,V> implements Iterable<V> {
        K key;
        List<V> items;
        Group(K key, List<V> items) { this.key = key; this.items = items; }
        public Iterator<V> iterator() { return items.iterator(); }
        int size() { return items.size(); }
    }
    public static void main(String[] args) {
    List<IdName> customers = new ArrayList<>(Arrays.asList(new IdName(1, "Alice"), new IdName(2, "Bob"), new IdName(3, "Charlie")));
    List<IdCustomerId> orders = new ArrayList<>(Arrays.asList(new IdCustomerId(100, 1), new IdCustomerId(101, 1), new IdCustomerId(102, 2)));
    List<NameCount> stats = (new java.util.function.Supplier<List<NameCount>>(){public List<NameCount> get(){
    List<NameCount> res0 = new ArrayList<>();
    Map<String,List<CO>> groups1 = new LinkedHashMap<>();
    for (var c : customers) {
        List<IdCustomerId> tmp2 = new ArrayList<>();
        for (var it3 : orders) {
            var o = it3;
            if (!(Objects.equals(o.customerId, c.id))) continue;
            tmp2.add(it3);
        }
        if (tmp2.isEmpty()) tmp2.add(null);
        for (var o : tmp2) {
            CO row4 = new CO(c, o);
            String key5 = c.name;
            List<CO> bucket6 = groups1.get(key5);
            if (bucket6 == null) { bucket6 = new ArrayList<>(); groups1.put(key5, bucket6); }
            bucket6.add(row4);
        }
    }
    for (Map.Entry<String,List<CO>> __e : groups1.entrySet()) {
        String g_key = __e.getKey();
        Group<String,CO> g = new Group<>(g_key, __e.getValue());
        res0.add(new NameCount(g.key, (new java.util.function.Supplier<List<CO>>(){public List<CO> get(){
    List<CO> res7 = new ArrayList<>();
    for (var r : g) {
        if (!(r.o != null)) continue;
        res7.add(r);
    }
    return res7;
}}).get().size()));
    }
    return res0;
}}).get();
    System.out.println("--- Group Left Join ---");
    for (NameCount s : stats) {
        System.out.println(s.name + " " + "orders:" + " " + s.count);
    }
    }
}
