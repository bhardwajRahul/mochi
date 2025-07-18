// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:59:55Z
const std = @import("std");

fn handleError(err: anyerror) noreturn {
    std.debug.panic("{any}", .{err});
}

fn _sum_int(v: []const i32) i32 {
    var sum: i32 = 0;
    for (v) |it| { sum += it; }
    return sum;
}

fn _concat_string(a: []const u8, b: []const u8) []const u8 {
    return std.mem.concat(u8, &[_][]const u8{ a, b }) catch |err| handleError(err);
}

fn divisors(n: i32) []const i32 {
    var divs: []const i32 = &[_]i32{1}; // []const i32
    var divs2 = std.ArrayList(i32).init(std.heap.page_allocator);
    var i = 2; // i32
    while ((i * i) <= n) {
        if (@mod(n, i) == 0) {
            const j = @as(i32, ((n / i))); // i32
            divs = blk0: { var _tmp0 = std.ArrayList(i32).init(std.heap.page_allocator); defer _tmp0.deinit(); _tmp0.appendSlice(divs) catch |err| handleError(err); _tmp0.append(i) catch |err| handleError(err); const res = _tmp0.toOwnedSlice() catch |err| handleError(err); break :blk0 res; };
            if (i != j) {
                divs2 = blk1: { var _tmp1 = std.ArrayList(i32).init(std.heap.page_allocator); defer _tmp1.deinit(); _tmp1.appendSlice(divs2) catch |err| handleError(err); _tmp1.append(j) catch |err| handleError(err); const res = _tmp1.toOwnedSlice() catch |err| handleError(err); break :blk1 res; };
            }
        }
        i = (i + 1);
    }
    var j = (@as(i32, @intCast((divs2).len)) - 1); // i32
    while (j >= 0) {
        divs = blk2: { var _tmp2 = std.ArrayList(i32).init(std.heap.page_allocator); defer _tmp2.deinit(); _tmp2.appendSlice(divs) catch |err| handleError(err); _tmp2.append(divs2[j]) catch |err| handleError(err); const res = _tmp2.toOwnedSlice() catch |err| handleError(err); break :blk2 res; };
        j = (j - 1);
    }
    return divs.items;
}

fn sum(xs: []const i32) i32 {
    var tot = 0; // i32
    for (xs) |v| {
        tot = (tot + v);
    }
    return tot;
}

fn sumStr(xs: []const i32) []const u8 {
    var s = ""; // []const u8
    var i = 0; // i32
    while (i < @as(i32, @intCast((xs).len))) {
        s = _concat_string(_concat_string(s, std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{xs[i]}) catch |err| handleError(err)), " + ");
        i = (i + 1);
    }
    return s[0..@as(usize, @intCast(@as(i32, @intCast((s).len)) - 3))];
}

fn pad2(n: i32) []const u8 {
    const s = std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{n}) catch |err| handleError(err); // []const u8
    if (@as(i32, @intCast((s).len)) < 2) {
        return _concat_string(" ", s);
    }
    return s;
}

fn pad5(n: i32) []const u8 {
    var s = std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{n}) catch |err| handleError(err); // []const u8
    while (@as(i32, @intCast((s).len)) < 5) {
        s = _concat_string(" ", s);
    }
    return s;
}

fn abundantOdd(searchFrom: i32, countFrom: i32, countTo: i32, printOne: bool) i32 {
    var count = countFrom; // i32
    var n = searchFrom; // i32
    while (count < countTo) {
        const divs = divisors(n); // []const i32
        const tot = _sum_int(divs); // f64
        if (tot > n) {
            count = (count + 1);
            if (printOne and (count < countTo)) {
                n = (n + 2);
                continue;
            }
            const s = sumStr(divs); // []const u8
            if (!printOne) {
                std.debug.print("{any}\n", .{_concat_string(_concat_string(_concat_string(_concat_string(_concat_string(_concat_string(pad2(count), ". "), pad5(n)), " < "), s), " = "), std.fmt.allocPrint(std.heap.page_allocator, "{d:.1}", .{tot}) catch |err| handleError(err))});
            } else {
                std.debug.print("{s}\n", .{_concat_string(_concat_string(_concat_string(_concat_string(std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{n}) catch |err| handleError(err), " < "), s), " = "), std.fmt.allocPrint(std.heap.page_allocator, "{d:.1}", .{tot}) catch |err| handleError(err))});
            }
        }
        n = (n + 2);
    }
    return n;
}

fn user_main() void {
    const max = 25; // i32
    std.debug.print("{s}\n", .{_concat_string(_concat_string("The first ", std.fmt.allocPrint(std.heap.page_allocator, "{any}", .{max}) catch |err| handleError(err)), " abundant odd numbers are:")});
    const n: i32 = abundantOdd(1, 0, max, false); // i32
    std.debug.print("\nThe one thousandth abundant odd number is:\n", .{});
    abundantOdd(n, max, 1000, true);
    std.debug.print("\nThe first abundant odd number above one billion is:\n", .{});
    abundantOdd(1000000001, 0, 1, true);
}

pub fn main() void {
    user_main();
}
