// Generated by Mochi compiler v0.10.27 on 1970-01-01T00:00:00Z
using System;

class Program
{
    static bool boom()
    {
        Console.WriteLine("boom");
        return true;
    }

    static void Main()
    {
        Console.WriteLine(((((1 < 2)) && ((2 < 3))) && ((3 < 4))));
        Console.WriteLine(((((1 < 2)) && ((2 > 3))) && boom()));
        Console.WriteLine((((((1 < 2)) && ((2 < 3))) && ((3 > 4))) && boom()));
    }
}
