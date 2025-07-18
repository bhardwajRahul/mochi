// Generated by Mochi compiler v0.10.25 on 2025-07-13T13:02:15Z
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;

class Program
{
    static void test_Q4_returns_minimum_rating_and_title_for_sequels(dynamic result)
    {
        expect(_equal(result, new List<Item> { new Item { rating = "6.2", movie_title = "Alpha Movie" } }));
    }

    static void Main()
    {
        var info_type = new List<InfoType> { new InfoType { id = 1, info = "rating" }, new InfoType { id = 2, info = "other" } };
        var keyword = new List<Keyword> { new Keyword { id = 1, keyword = "great sequel" }, new Keyword { id = 2, keyword = "prequel" } };
        var title = new List<Title> { new Title { id = 10, title = "Alpha Movie", production_year = 2006 }, new Title { id = 20, title = "Beta Film", production_year = 2007 }, new Title { id = 30, title = "Old Film", production_year = 2004 } };
        List<Dictionary<string, int>> movie_keyword = new List<MovieKeyword> { new MovieKeyword { movie_id = 10, keyword_id = 1 }, new MovieKeyword { movie_id = 20, keyword_id = 1 }, new MovieKeyword { movie_id = 30, keyword_id = 1 } };
        var movie_info_idx = new List<MovieInfoIdx> { new MovieInfoIdx { movie_id = 10, info_type_id = 1, info = "6.2" }, new MovieInfoIdx { movie_id = 20, info_type_id = 1, info = "7.8" }, new MovieInfoIdx { movie_id = 30, info_type_id = 1, info = "4.5" } };
        var rows = (
    from it in info_type
    join mi in movie_info_idx on it["id"] equals mi["info_type_id"]
    join t in title on t["id"] equals mi["movie_id"]
    join mk in movie_keyword on mk["movie_id"] equals t["id"]
    join k in keyword on k["id"] equals mk["keyword_id"]
    where (mk["movie_id"] == mi["movie_id"])
    select new Row { rating = mi["info"], title = t["title"] }
).ToList();
        var result = new List<Result> { new Result { rating = Enumerable.Min(rows.Select(r => r["rating"]).ToList()), movie_title = Enumerable.Min(rows.Select(r => r["title"]).ToList()) } };
        Console.WriteLine(JsonSerializer.Serialize(result));
        test_Q4_returns_minimum_rating_and_title_for_sequels(result);
    }
    public class Item
    {
        public string rating;
        public string movie_title;
    }



    public class InfoType
    {
        public int id;
        public string info;
    }




    public class Keyword
    {
        public int id;
        public string keyword;
    }




    public class Title
    {
        public int id;
        public string title;
        public int production_year;
    }





    public class MovieKeyword
    {
        public int movie_id;
        public int keyword_id;
    }





    public class MovieInfoIdx
    {
        public int movie_id;
        public int info_type_id;
        public string info;
    }





    public class Row
    {
        public dynamic rating;
        public dynamic title;
    }



    public class Result
    {
        public dynamic rating;
        public dynamic movie_title;
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

}
