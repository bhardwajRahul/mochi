// Generated by Mochi compiler v0.10.28 on 1970-01-01T00:00:00Z
// break_continue.mochi
import java.util.*;

public class BreakContinue {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9));
        for (Integer n : numbers) {
            if (Objects.equals(n % 2, 0)) {
                continue;
            }
            if (n > 7) {
                break;
            }
            System.out.println("odd number:" + " " + n);
        }
    }
}
