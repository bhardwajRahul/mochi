// Generated by Mochi C# compiler
using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Web;

public class Program {
    static long[] addTwoNumbers(long[] l1, long[] l2) {
        long i = 0L;
        long j = 0L;
        long carry = 0L;
        long[] result = new long[] { };
        while ((((i < l1.Length) || (j < l2.Length)) || (carry > 0L))) {
            long x = 0L;
            if ((i < l1.Length)) {
                x = _indexList(l1, i);
                i = (i + 1L);
            }
            long y = 0L;
            if ((j < l2.Length)) {
                y = _indexList(l2, j);
                j = (j + 1L);
            }
            var sum = ((x + y) + carry);
            var digit = (sum % 10L);
            carry = (sum / 10L);
            result = result.Concat(new dynamic[] { digit }).ToArray();
        }
        return result;
    }
    
    static void test_example_1() {
        expect(_equal(addTwoNumbers(new long[] { 2L, 4L, 3L }, new long[] { 5L, 6L, 4L }), new long[] { 7L, 0L, 8L }));
    }
    
    static void test_example_2() {
        expect(_equal(addTwoNumbers(new long[] { 0L }, new long[] { 0L }), new long[] { 0L }));
    }
    
    static void test_example_3() {
        expect(_equal(addTwoNumbers(new long[] { 9L, 9L, 9L, 9L, 9L, 9L, 9L }, new long[] { 9L, 9L, 9L, 9L }), new long[] { 8L, 9L, 9L, 9L, 0L, 0L, 0L, 1L }));
    }
    
    public static void Main() {
        test_example_1();
        test_example_2();
        test_example_3();
    }
    static dynamic _indexList(dynamic l, long i) {
        var list = l as System.Collections.IList;
        if (list == null) throw new Exception("index() expects list");
        if (i < 0) i += list.Count;
        if (i < 0 || i >= list.Count) throw new Exception("index out of range");
        return list[(int)i];
    }
    
    static bool _equal(dynamic a, dynamic b) {
        if (a is System.Collections.IEnumerable ae && b is System.Collections.IEnumerable be && a is not string && b is not string) {
            var ea = ae.GetEnumerator();
            var eb = be.GetEnumerator();
            while (true) {
                bool ha = ea.MoveNext();
                bool hb = eb.MoveNext();
                if (ha != hb) return false;
                if (!ha) break;
                if (!_equal(ea.Current, eb.Current)) return false;
            }
            return true;
        }
        return Equals(a, b);
    }
    
    static void expect(bool cond) {
        if (!cond) throw new Exception("expect failed");
    }
    
}
