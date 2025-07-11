// map_int_key.mochi
import java.util.*;

public class MapIntKey {
    static <K,V> Map.Entry<K,V> entry(K k, V v) { return new AbstractMap.SimpleEntry<>(k, v); }
    static <K,V> LinkedHashMap<K,V> mapOfEntries(Map.Entry<? extends K,? extends V>... entries) {
        LinkedHashMap<K,V> m = new LinkedHashMap<>();
        for (var e : entries) m.put(e.getKey(), e.getValue());
        return m;
    }
    public static void main(String[] args) {
    Map<Integer,String> m = new HashMap<>(mapOfEntries(entry(1, "a"), entry(2, "b")));
    System.out.println(m.get(1));
    }
}
