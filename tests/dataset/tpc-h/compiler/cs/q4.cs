// Generated by Mochi compiler v0.10.27 on 2025-07-17T18:30:40Z
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;

class Program
{
    static void test_Q4_returns_count_of_orders_with_late_lineitems_in_range(dynamic result)
    {
        expect(_equal(result, new List<dynamic> { new Dictionary<string, dynamic> { { "o_orderpriority", "1-URGENT" }, { "order_count", 1 } }, new Dictionary<string, dynamic> { { "o_orderpriority", "2-HIGH" }, { "order_count", 1 } } }));
    }

    static void Main()
    {
        var orders = new List<dynamic> { new Dictionary<string, dynamic> { { "o_orderkey", 1 }, { "o_orderdate", "1993-07-01" }, { "o_orderpriority", "1-URGENT" } }, new Dictionary<string, dynamic> { { "o_orderkey", 2 }, { "o_orderdate", "1993-07-15" }, { "o_orderpriority", "2-HIGH" } }, new Dictionary<string, dynamic> { { "o_orderkey", 3 }, { "o_orderdate", "1993-08-01" }, { "o_orderpriority", "3-NORMAL" } } };
        var lineitem = new List<dynamic> { new Dictionary<string, dynamic> { { "l_orderkey", 1 }, { "l_commitdate", "1993-07-10" }, { "l_receiptdate", "1993-07-12" } }, new Dictionary<string, dynamic> { { "l_orderkey", 1 }, { "l_commitdate", "1993-07-12" }, { "l_receiptdate", "1993-07-10" } }, new Dictionary<string, dynamic> { { "l_orderkey", 2 }, { "l_commitdate", "1993-07-20" }, { "l_receiptdate", "1993-07-25" } }, new Dictionary<string, dynamic> { { "l_orderkey", 3 }, { "l_commitdate", "1993-08-02" }, { "l_receiptdate", "1993-08-01" } }, new Dictionary<string, dynamic> { { "l_orderkey", 3 }, { "l_commitdate", "1993-08-05" }, { "l_receiptdate", "1993-08-10" } } };
        var start_date = "1993-07-01";
        var end_date = "1993-08-01";
        var date_filtered_orders = orders.Where(o => string.Compare(Convert.ToString(o["o_orderdate"]), Convert.ToString(start_date)) >= 0 && string.Compare(Convert.ToString(o["o_orderdate"]), Convert.ToString(end_date)) < 0).Select(o => o).ToList();
        var late_orders = date_filtered_orders.Where(o => Enumerable.Any(lineitem.Where(l => (l["l_orderkey"] == o["o_orderkey"])).Select(l => l).ToList())).Select(o => o).ToList();
        var result = _group_by<dynamic, dynamic>(late_orders, o => o["o_orderpriority"]).OrderBy(g => g.key).Select(g => new Dictionary<string, dynamic> { { "o_orderpriority", g.key }, { "order_count", Enumerable.Count(g) } }).ToList();
        Console.WriteLine(JsonSerializer.Serialize(result));
        test_Q4_returns_count_of_orders_with_late_lineitems_in_range(result);
    }
    static List<_Group<TKey, TItem>> _group_by<TItem, TKey>(IEnumerable<TItem> src, Func<TItem, TKey> keyfn)
    {
        var groups = new Dictionary<string, _Group<TKey, TItem>>();
        var order = new List<string>();
        foreach (var it in src)
        {
            var key = keyfn(it);
            var ks = Convert.ToString(key);
            if (!groups.TryGetValue(ks, out var g))
            {
                g = new _Group<TKey, TItem>(key);
                groups[ks] = g;
                order.Add(ks);
            }
            g.Items.Add(it);
        }
        var res = new List<_Group<TKey, TItem>>();
        foreach (var k in order) res.Add(groups[k]);
        return res;
    }

    static void expect(bool cond)
    {
        if (!cond) throw new Exception("expect failed");
    }

    static bool _equal(dynamic a, dynamic b)
    {
        if (a is System.Collections.IEnumerable ae && b is System.Collections.IEnumerable be && a is not string && b is not string)
        {
            var ea = ae.GetEnumerator();
            var eb = be.GetEnumerator();
            while (true)
            {
                bool ha = ea.MoveNext();
                bool hb = eb.MoveNext();
                if (ha != hb) return false;
                if (!ha) break;
                if (!_equal(ea.Current, eb.Current)) return false;
            }
            return true;
        }
        if ((a is int || a is long || a is float || a is double) && (b is int || b is long || b is float || b is double))
        {
            return Convert.ToDouble(a) == Convert.ToDouble(b);
        }
        if (a != null && b != null && a.GetType() != b.GetType())
        {
            return JsonSerializer.Serialize(a) == JsonSerializer.Serialize(b);
        }
        if (a != null && b != null && !a.GetType().IsPrimitive && !b.GetType().IsPrimitive && a is not string && b is not string)
        {
            return JsonSerializer.Serialize(a) == JsonSerializer.Serialize(b);
        }
        return Equals(a, b);
    }

    public interface _IGroup { System.Collections.IEnumerable Items { get; } }
    public class _Group<TKey, TItem> : _IGroup, IEnumerable<TItem>
    {
        public TKey key;
        public List<TItem> Items = new List<TItem>();
        public _Group(TKey k) { key = k; }
        System.Collections.IEnumerable _IGroup.Items => Items;
        public IEnumerator<TItem> GetEnumerator() => Items.GetEnumerator();
        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => Items.GetEnumerator();
    }

}
