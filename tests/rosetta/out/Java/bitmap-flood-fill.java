// Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
// bitmap-flood-fill.mochi
import java.util.*;

public class BitmapFloodFill {
    static List<List<String>> grid = Arrays.asList(Arrays.asList(".", ".", ".", ".", "."), Arrays.asList(".", "#", "#", "#", "."), Arrays.asList(".", "#", ".", "#", "."), Arrays.asList(".", "#", "#", "#", "."), Arrays.asList(".", ".", ".", ".", "."));
    static void flood(int x, int y, String repl) {
        List<List<String>> target = ((List)grid.get(y)).get(x);
        if (Objects.equals(target, repl)) {
            return ;
        }
        Object ff = (px, py) -> {
            if (px < 0 || py < 0 || py >= grid.size() || px >= ((Number)grid.get(0).size()).doubleValue()) {
                return ;
            }
            if (!Objects.equals(((List)grid.get(py)).get(px), target)) {
                return ;
            }
            ((List)grid.get(py)).set(px, repl);
            ff(px - 1, py);
            ff(px + 1, py);
            ff(px, py - 1);
            ff(px, py + 1);
        };
        ff(x, y);
    }
    public static void main(String[] args) {
        flood(2, 2, "o");
        for (List<String> row : grid) {
            String line = "";
            for (String ch : row) {
                line = line + ch;
            }
            System.out.println(line);
        }
    }
}
