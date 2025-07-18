// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:59:56Z
const std = @import("std");

fn handleError(err: anyerror) noreturn {
    std.debug.panic("{any}", .{err});
}

fn _concat_string(a: []const u8, b: []const u8) []const u8 {
    return std.mem.concat(u8, &[_][]const u8{ a, b }) catch |err| handleError(err);
}

var pps: std.AutoHashMap(i32, bool) = undefined; // std.AutoHashMap(i32, bool)

fn pow10(exp: i32) i32 {
    var n = 1; // i32
    var i = 0; // i32
    while (i < exp) {
        n = (n * 10);
        i = (i + 1);
    }
    return n;
}

fn totient(n: i32) i32 {
    var tot = n; // i32
    var nn = n; // i32
    var i = 2; // i32
    while ((i * i) <= nn) {
        if (@mod(nn, i) == 0) {
            while (@mod(nn, i) == 0) {
                nn = (nn / i);
            }
            tot = (tot - (tot / i));
        }
        if (i == 2) {
            i = 1;
        }
        i = (i + 2);
    }
    if (nn > 1) {
        tot = (tot - (tot / nn));
    }
    return tot;
}

fn getPerfectPowers(maxExp: i32) void {
    const upper = pow10(maxExp); // i32
    var i = 2; // i32
    while ((i * i) < upper) {
        var p = (i * i); // i32
        while (true) {
            p = (p * i);
            if (p >= upper) {
                break;
            }
            _ = pps.put(p, true) catch |err| handleError(err);
        }
        i = (i + 1);
    }
}

fn getAchilles(minExp: i32, maxExp: i32) std.AutoHashMap(i32, bool) {
    const lower = pow10(minExp); // i32
    const upper = pow10(maxExp); // i32
    var achilles = std.AutoHashMap(i32, bool).init(std.heap.page_allocator);
    var b = 1; // i32
    while (((b * b) * b) < upper) {
        const b3 = ((b * b) * b); // i32
        var a = 1; // i32
        while (true) {
            const p = ((b3 * a) * a); // i32
            if (p >= upper) {
                break;
            }
            if (p >= lower) {
                if (!(pps.contains(p))) {
                    _ = achilles.put(p, true) catch |err| handleError(err);
                }
            }
            a = (a + 1);
        }
        b = (b + 1);
    }
    return achilles;
}

fn sortInts(xs: []const i32) []const i32 {
    var res = std.ArrayList(i32).init(std.heap.page_allocator);
    var tmp = xs; // []const i32
    while (@as(i32, @intCast((tmp).len)) > 0) {
        var min = tmp[0]; // i32
        var idx = 0; // i32
        var i = 1; // i32
        while (i < @as(i32, @intCast((tmp).len))) {
            if (tmp[i] < min) {
                min = tmp[i];
                idx = i;
            }
            i = (i + 1);
        }
        try res.append(@as(i32,@intCast(min)));
        var out = std.ArrayList(i32).init(std.heap.page_allocator);
        var j = 0; // i32
        while (j < @as(i32, @intCast((tmp).len))) {
            if (j != idx) {
                try out.append(@as(i32,@intCast(tmp[j])));
            }
            j = (j + 1);
        }
        tmp = out;
    }
    return res.items;
}

fn pad(n: i32, width: i32) []const u8 {
    var s = std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{n}) catch |err| handleError(err); // []const u8
    while (@as(i32, @intCast((s).len)) < width) {
        s = _concat_string(" ", s);
    }
    return s;
}

fn user_main() void {
    const maxDigits = 15; // i32
    getPerfectPowers(maxDigits);
    const achSet = getAchilles(1, 5); // std.AutoHashMap(i32, bool)
    var ach = std.ArrayList(i32).init(std.heap.page_allocator);
    for (achSet.keys()) |k| {
        try ach.append(@as(i32,@intCast(k)));
    }
    ach = sortInts(ach);
    std.debug.print("First 50 Achilles numbers:\n", .{});
    var i = 0; // i32
    while (i < 50) {
        var line = ""; // []const u8
        var j = 0; // i32
        while (j < 10) {
            line = _concat_string(line, pad(ach[i], 4));
            if (j < 9) {
                line = _concat_string(line, " ");
            }
            i = (i + 1);
            j = (j + 1);
        }
        std.debug.print("{s}\n", .{line});
    }
    std.debug.print("\nFirst 30 strong Achilles numbers:\n", .{});
    var strong = std.ArrayList(i32).init(std.heap.page_allocator);
    var count = 0; // i32
    var idx = 0; // i32
    while (count < 30) {
        const tot = totient(ach[idx]); // i32
        if (achSet.contains(tot)) {
            try strong.append(@as(i32,@intCast(ach[idx])));
            count = (count + 1);
        }
        idx = (idx + 1);
    }
    i = 0;
    while (i < 30) {
        var line = ""; // []const u8
        var j = 0; // i32
        while (j < 10) {
            line = _concat_string(line, pad(strong[i], 5));
            if (j < 9) {
                line = _concat_string(line, " ");
            }
            i = (i + 1);
            j = (j + 1);
        }
        std.debug.print("{s}\n", .{line});
    }
    std.debug.print("\nNumber of Achilles numbers with:\n", .{});
    const counts = &[_]i32{
    1,
    12,
    47,
    192,
    664,
    2242,
    7395,
    24008,
    77330,
    247449,
    788855,
    2508051,
    7960336,
    25235383,
}; // []const i32
    var d = 2; // i32
    while (d <= maxDigits) {
        const c = counts[(d - 2)]; // i32
        std.debug.print("{s}\n", .{_concat_string(_concat_string(pad(d, 2), " digits: "), std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{c}) catch |err| handleError(err))});
        d = (d + 1);
    }
}

pub fn main() void {
    pps = (blk0: { var _map0 = std.AutoHashMap(i32, i32).init(std.heap.page_allocator); break :blk0 _map0; });
    user_main();
}
