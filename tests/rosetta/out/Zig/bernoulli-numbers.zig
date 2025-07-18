// Generated by Mochi compiler v0.10.28 on 2025-07-18T10:01:15Z
const std = @import("std");

fn handleError(err: anyerror) noreturn {
    std.debug.panic("{any}", .{err});
}

fn _concat_string(a: []const u8, b: []const u8) []const u8 {
    return std.mem.concat(u8, &[_][]const u8{ a, b }) catch |err| handleError(err);
}

fn bernoulli(n: i32) i32 {
    var a = std.ArrayList(i32).init(std.heap.page_allocator);
    var m = 0; // i32
    while (m <= n) {
        a = blk0: { var _tmp0 = std.ArrayList(i32).init(std.heap.page_allocator); defer _tmp0.deinit(); _tmp0.appendSlice(a) catch |err| handleError(err); _tmp0.append((@as(i32, 1) / (@as(i32, ((m + 1)))))) catch |err| handleError(err); const res = _tmp0.toOwnedSlice() catch |err| handleError(err); break :blk0 res; };
        var j = m; // i32
        while (j >= 1) {
            a.items[(j - 1)] = ((@as(i32, j)) * ((a[(j - 1)] - a[j])));
            j = (j - 1);
        }
        m = (m + 1);
    }
    return a.items[0];
}

pub fn main() void {
    for (0 .. 61) |i| {
        const b: i32 = bernoulli(i); // i32
        if (num(b) != 0) {
            const numStr: i32 = std.fmt.allocPrint(std.heap.page_allocator, "{any}", .{num(b)}) catch |err| handleError(err); // i32
            const denStr: i32 = std.fmt.allocPrint(std.heap.page_allocator, "{any}", .{denom(b)}) catch |err| handleError(err); // i32
            std.debug.print("{s}\n", .{_concat_string(_concat_string(_concat_string(_concat_string(_concat_string("B(", std.fmt.allocPrint(std.heap.page_allocator, "{d}", .{i}) catch |err| handleError(err)(2, " ")), ") ="), numStr.padStart(45, " ")), "/"), denStr)});
        }
    }
}
