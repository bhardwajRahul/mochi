// group_by.mochi
import java.util.*;

class NameAgeCity {
    String name;
    int age;
    String city;
    NameAgeCity(String name, int age, String city) {
        this.name = name;
        this.age = age;
        this.city = city;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof NameAgeCity other)) return false;
        return Objects.equals(this.name, other.name) && Objects.equals(this.age, other.age) && Objects.equals(this.city, other.city);
    }
    @Override public int hashCode() {
        return Objects.hash(name, age, city);
    }
    int size() { return 3; }
}
class CityCountAvgAge {
    Object city;
    int count;
    double avg_age;
    CityCountAvgAge(Object city, int count, double avg_age) {
        this.city = city;
        this.count = count;
        this.avg_age = avg_age;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CityCountAvgAge other)) return false;
        return Objects.equals(this.city, other.city) && Objects.equals(this.count, other.count) && Objects.equals(this.avg_age, other.avg_age);
    }
    @Override public int hashCode() {
        return Objects.hash(city, count, avg_age);
    }
    int size() { return 3; }
}
public class GroupBy {
    static class Group<K,V> implements Iterable<V> {
        K key;
        List<V> items;
        Group(K key, List<V> items) { this.key = key; this.items = items; }
        public Iterator<V> iterator() { return items.iterator(); }
        int size() { return items.size(); }
    }
    public static void main(String[] args) {
    List<NameAgeCity> people = new ArrayList<>(Arrays.asList(new NameAgeCity("Alice", 30, "Paris"), new NameAgeCity("Bob", 15, "Hanoi"), new NameAgeCity("Charlie", 65, "Paris"), new NameAgeCity("Diana", 45, "Hanoi"), new NameAgeCity("Eve", 70, "Paris"), new NameAgeCity("Frank", 22, "Hanoi")));
    List<CityCountAvgAge> stats = (new java.util.function.Supplier<List<CityCountAvgAge>>(){public List<CityCountAvgAge> get(){
    List<CityCountAvgAge> res0 = new ArrayList<>();
    Map<String,List<NameAgeCity>> groups1 = new LinkedHashMap<>();
    for (var person : people) {
        var row2 = person;
        String key3 = person.city;
        List<NameAgeCity> bucket4 = groups1.get(key3);
        if (bucket4 == null) { bucket4 = new ArrayList<>(); groups1.put(key3, bucket4); }
        bucket4.add(row2);
    }
    for (Map.Entry<String,List<NameAgeCity>> __e : groups1.entrySet()) {
        String g_key = __e.getKey();
        Group<String,NameAgeCity> g = new Group<>(g_key, __e.getValue());
        res0.add(new CityCountAvgAge(g.key, g.size(), (new java.util.function.Supplier<List<Integer>>(){public List<Integer> get(){
    List<Integer> res5 = new ArrayList<>();
    for (var p : g) {
        res5.add(p.age);
    }
    return res5;
}}).get().stream().mapToDouble(n -> ((Number)n).doubleValue()).average().orElse(0)));
    }
    return res0;
}}).get();
    System.out.println("--- People grouped by city ---");
    for (CityCountAvgAge s : stats) {
        System.out.println(s.city + " " + ": count =" + " " + s.count + " " + ", avg_age =" + " " + s.avg_age);
    }
    }
}
