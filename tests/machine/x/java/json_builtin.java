// json_builtin.mochi
import java.util.*;

class AB {
    int a;
    int b;
    AB(int a, int b) {
        this.a = a;
        this.b = b;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AB other)) return false;
        return Objects.equals(this.a, other.a) && Objects.equals(this.b, other.b);
    }
    @Override public int hashCode() {
        return Objects.hash(a, b);
    }
    int size() { return 2; }
}
public class JsonBuiltin {
    static String toJson(Object o) {
        if (o instanceof Map<?,?> m) {
            StringJoiner j = new StringJoiner(",", "{", "}");
            for (Map.Entry<?,?> e : m.entrySet()) j.add("\"" + e.getKey() + "\":" + e.getValue());
            return j.toString();
        } else if (o instanceof Collection<?> c) {
            StringJoiner j = new StringJoiner(",", "[", "]");
            for (var x : c) j.add(toJson(x));
            return j.toString();
        } else if (o instanceof String s) {
            return "\"" + s + "\"";
        }
        return String.valueOf(o);
    }
    static void json(Object o) { System.out.println(toJson(o)); }
    public static void main(String[] args) {
    AB m = new AB(1, 2);
    json(m);
    }
}
