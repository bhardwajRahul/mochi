// Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
// arrays.mochi
import java.util.*;

public class Arrays {
    static List<Integer> s = ((List)a).subList(0, 4);
    static String listStr(List<Integer> xs) {
        String s = "[";
        int i = 0;
        while (i < xs.size()) {
            s = s + ((Number)String.valueOf(xs.get(i))).doubleValue();
            if (String.valueOf(i + 1).compareTo(String.valueOf(xs.size())) < 0) {
                s = s + " ";
            }
            i = (int)(i + 1);
        }
        s = s + "]";
        return s;
    }
    public static void main(String[] args) {
        List<Integer> a = new ArrayList<>(Arrays.asList(0, 0, 0, 0, 0));
        System.out.println("len(a) = " + String.valueOf(a.size()));
        System.out.println("a = " + listStr(a));
        a.set(0, 3);
        System.out.println("a = " + listStr(a));
        System.out.println("a[0] = " + ((Number)String.valueOf(a.get(0))).doubleValue());
        int cap_s = 5;
        System.out.println("s = " + listStr(s));
        System.out.println("len(s) = " + String.valueOf(s.size()) + "  cap(s) = " + String.valueOf(cap_s));
        s = ((List)a).subList(0, 5);
        System.out.println("s = " + listStr(s));
        a.set(0, 22);
        s.set(0, 22);
        System.out.println("a = " + listStr(a));
        System.out.println("s = " + listStr(s));
        s.add(4);
        s.add(5);
        s.add(6);
        cap_s = (int)(10);
        System.out.println("s = " + listStr(s));
        System.out.println("len(s) = " + String.valueOf(s.size()) + "  cap(s) = " + String.valueOf(cap_s));
        a.set(4, -1);
        System.out.println("a = " + listStr(a));
        System.out.println("s = " + listStr(s));
        s = Arrays.asList();
        for (int i = 0; i < 8; i++) {
            s.add(0);
        }
        cap_s = (int)(8);
        System.out.println("s = " + listStr(s));
        System.out.println("len(s) = " + String.valueOf(s.size()) + "  cap(s) = " + String.valueOf(cap_s));
    }
}
