// Mochi 0.10.31 - generated 2025-07-19 13:00:04 UTC
using System;
using System.Collections.Generic;

class Program {
    static void Main() {
        var data = new Dictionary<string, Dictionary<string, int>>{{"outer", new Dictionary<string, int>{{"inner", 1}}}};
        data["outer"]["inner"] = 2;
        Console.WriteLine(data["outer"]["inner"]);
    }
}
