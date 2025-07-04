// Generated by Mochi C# compiler
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Web;

public class Program {
    static long expand(string s, long left, long right) {
        var l = left;
        var r = right;
        long n = s.Length;
        while (((l >= 0L) && (r < n))) {
            if ((_indexString(s, l) != _indexString(s, r))) {
                break;
            }
            l = (l - 1L);
            r = (r + 1L);
        }
        return ((r - l) - 1L);
    }
    
    static string longestPalindrome(string s) {
        if ((s.Length <= 1L)) {
            return s;
        }
        long start = 0L;
        long end = 0L;
        long n = s.Length;
        for (var i = 0L; i < n; i++) {
            long len1 = expand(s, i, i);
            long len2 = expand(s, i, (i + 1L));
            var l = len1;
            if ((len2 > len1)) {
                l = len2;
            }
            if ((l > ((end - start)))) {
                start = (i - ((((l - 1L)) / 2L)));
                end = (i + ((l / 2L)));
            }
        }
        return _sliceString(s, start, (end + 1L));
    }
    
    static void test_example_1() {
        string ans = longestPalindrome("babad");
        expect(((ans == "bab") || (ans == "aba")));
    }
    
    static void test_example_2() {
        expect((longestPalindrome("cbbd") == "bb"));
    }
    
    static void test_single_char() {
        expect((longestPalindrome("a") == "a"));
    }
    
    static void test_two_chars() {
        string ans = longestPalindrome("ac");
        expect(((ans == "a") || (ans == "c")));
    }
    
    public static void Main() {
        test_example_1();
        test_example_2();
        test_single_char();
        test_two_chars();
    }
    static string _sliceString(string s, long i, long j) {
        var start = i;
        var end = j;
        var n = s.Length;
        if (start < 0) start += n;
        if (end < 0) end += n;
        if (start < 0) start = 0;
        if (end > n) end = n;
        if (end < start) end = start;
        return s.Substring((int)start, (int)(end - start));
    }
    
    static void expect(bool cond) {
        if (!cond) throw new Exception("expect failed");
    }
    
    static string _indexString(string s, long i) {
        if (i < 0) i += s.Length;
        if (i < 0 || i >= s.Length) throw new Exception("index out of range");
        return s[(int)i].ToString();
    }
    
}
