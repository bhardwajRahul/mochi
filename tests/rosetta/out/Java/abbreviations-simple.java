// Generated by Mochi compiler v0.10.30 on 2006-01-02T15:04:05Z
// abbreviations-simple.mochi
import java.util.*;

public class AbbreviationsSimple {
    static List<String> fields(String s) {
        List<String> words = new ArrayList<>(Arrays.asList());
        String cur = "";
        int i = 0;
        while (i < s.length()) {
            String ch = s.substring(i, i + 1);
            if (Objects.equals(ch, " ") || Objects.equals(ch, "\n") || Objects.equals(ch, "\t")) {
                if (cur.length() > 0) {
                    words.add(cur);
                    cur = "";
                }
            }
            else {
                cur = cur + ch;
            }
            i = (int)(i + 1);
        }
        if (cur.length() > 0) {
            words.add(cur);
        }
        return words;
    }
    static String padRight(String s, int width) {
        String out = s;
        int i = s.length();
        while (i < width) {
            out = out + " ";
            i = (int)(i + 1);
        }
        return out;
    }
    static String join(List<String> xs, String sep) {
        String res = "";
        int i = 0;
        while (i < xs.size()) {
            if (i > 0) {
                res = res + sep;
            }
            res = res + ((Number)xs.get(i)).doubleValue();
            i = (int)(i + 1);
        }
        return res;
    }
    static int parseIntStr(String str) {
        int i = 0;
        boolean neg = false;
        if (str.length() > 0 && Objects.equals(str.substring(0, 1), "-")) {
            neg = true;
            i = (int)(1);
        }
        int n = 0;
        Digit digits = new Digit(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
        while (i < str.length()) {
            n = (int)(n * 10 + ((Number)((Map<?,?>)digits).get(str.substring(i, i + 1))).doubleValue());
            i = (int)(i + 1);
        }
        if (neg) {
            n = (int)(-n);
        }
        return n;
    }
    static boolean isDigits(String s) {
        if (Objects.equals(s.length(), 0)) {
            return false;
        }
        int i = 0;
        while (i < s.length()) {
            String ch = s.substring(i, i + 1);
            if (String.valueOf(ch).compareTo(String.valueOf("0")) < 0 || String.valueOf(ch).compareTo(String.valueOf("9")) > 0) {
                return false;
            }
            i = (int)(i + 1);
        }
        return true;
    }
    static Map<String,Object> readTable(String table) {
        List<String> toks = fields(table);
        List<String> cmds = new ArrayList<>(Arrays.asList());
        List<Integer> mins = new ArrayList<>(Arrays.asList());
        int i = 0;
        while (i < toks.size()) {
            List<String> cmd = toks.get(i);
            int minlen = cmd.size();
            i = (int)(i + 1);
            if (i < toks.size() && Boolean.TRUE.equals(isDigits(toks.get(i)))) {
                int num = parseIntStr(toks.get(i));
                if (num >= 1 && num < cmd.size()) {
                    minlen = (int)(num);
                    i = (int)(i + 1);
                }
            }
            cmds.add(cmd);
            mins.add(minlen);
        }
        return new CommandsMins(cmds, mins);
    }
    static List<String> validate(List<String> commands, List<Integer> mins, List<String> words) {
        List<String> results = new ArrayList<>(Arrays.asList());
        int wi = 0;
        while (wi < words.size()) {
            List<String> w = words.get(wi);
            boolean found = false;
            int wlen = w.size();
            int ci = 0;
            while (ci < commands.size()) {
                List<String> cmd = commands.get(ci);
                if (!Objects.equals(mins.get(ci), 0) && wlen >= ((Number)mins.get(ci)).doubleValue() && wlen <= cmd.size()) {
                    String c = String.valueOf(cmd).toUpperCase();
                    String ww = String.valueOf(w).toUpperCase();
                    if (Objects.equals(c.substring(0, wlen), ww)) {
                        results.add(c);
                        found = true;
                        break;
                    }
                }
                ci = (int)(ci + 1);
            }
            if (!found) {
                results.add("*error*");
            }
            wi = (int)(wi + 1);
        }
        return results;
    }
    static void main() {
        String table = "" + "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 " + "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate " + "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 " + "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load " + "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 " + "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 " + "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left " + "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 ";
        String sentence = "riG   rePEAT copies  put mo   rest    types   fup.    6\npoweRin";
        Map<String,Object> tbl = readTable(table);
        List<String> commands = (List<String>)((Map)tbl.get("commands"));
        List<Integer> mins = (List<Integer>)((Map)tbl.get("mins"));
        List<String> words = fields(sentence);
        List<String> results = validate(commands, mins, words);
        String out1 = "user words:";
        int k = 0;
        while (k < words.size()) {
            out1 = out1 + " ";
            if (k < words.size() - 1) {
                out1 = out1 + ((Number)padRight(words.get(k), results.get(k).size())).doubleValue();
            }
            else {
                out1 = out1 + ((Number)words.get(k)).doubleValue();
            }
            k = (int)(k + 1);
        }
        System.out.println(out1);
        System.out.println("full words: " + join(results, " "));
    }
    public static void main(String[] args) {
        main();
    }
}
