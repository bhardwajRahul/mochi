// save_jsonl_stdout.mochi
import java.util.*;

class NameAge {
    String name;
    int age;
    NameAge(String name, int age) {
        this.name = name;
        this.age = age;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof NameAge other)) return false;
        return Objects.equals(this.name, other.name) && Objects.equals(this.age, other.age);
    }
    @Override public int hashCode() {
        return Objects.hash(name, age);
    }
    int size() { return 2; }
}
public class SaveJsonlStdout {
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
    public static void main(String[] args) {
    List<NameAge> people = new ArrayList<>(Arrays.asList(new NameAge("Alice", 30), new NameAge("Bob", 25)));
    saveJsonl((List<?>)people);
    }
}
