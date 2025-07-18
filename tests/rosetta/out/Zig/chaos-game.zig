// Generated by Mochi compiler v0.10.26 on 1970-01-01T00:00:00Z
const std = @import("std");

fn handleError(err: anyerror) noreturn {
    std.debug.panic("{any}", .{err});
}

fn _concat_string(a: []const u8, b: []const u8) []const u8 {
    return std.mem.concat(u8, &[_][]const u8{ a, b }) catch |err| handleError(err);
}

const width = 60; // i32
const height = @as(i32, ((@as(f64, width) * 0.86602540378))); // i32
const iterations = 5000; // i32
var grid: []const []const []const u8 = &[]i32{};
var y = 0; // i32
var seed = 1; // i32
const vertices = &[_][]const i32{
    &[_]i32{
    0,
    (height - 1),
},
    &[_]i32{
    (width - 1),
    (height - 1),
},
    &[_]i32{
    @as(i32, ((width / 2))),
    0,
},
}; // []const []const i32
var px = @as(i32, ((width / 2))); // i32
var py = @as(i32, ((height / 2))); // i32
var i = 0; // i32

fn randInt(s: i32, n: i32) []const i32 {
    const next = @mod((((s * 1664525) + 1013904223)), 2147483647); // i32
    return [_]i32{
    next,
    @mod(next, n),
};
}

pub fn main() void {
    while (y < height) {
        var line = std.ArrayList(u8).init(std.heap.page_allocator);
        var x = 0; // i32
        while (x < width) {
            line = blk0: { var _tmp0 = std.ArrayList([]const u8).init(std.heap.page_allocator); defer _tmp0.deinit(); _tmp0.appendSlice(line) catch |err| handleError(err); _tmp0.append(" ") catch |err| handleError(err); break :blk0 _tmp0.items; };
            x = (x + 1);
        }
        grid = blk1: { var _tmp1 = std.ArrayList([]const []const u8).init(std.heap.page_allocator); defer _tmp1.deinit(); _tmp1.appendSlice(grid) catch |err| handleError(err); _tmp1.append(line) catch |err| handleError(err); break :blk1 _tmp1.items; };
        y = (y + 1);
    }
    while (i < iterations) {
        var r = randInt(seed, 3); // []const i32
        seed = r[0];
        const idx = @as(i32, r[1]); // i32
        const v = vertices[idx]; // []const i32
        px = @as(i32, ((((px + v[0])) / 2)));
        py = @as(i32, ((((py + v[1])) / 2)));
        if ((((px >= 0) and (px < width)) and (py >= 0)) and (py < height)) {
            grid.items[py][px] = "*";
        }
        i = (i + 1);
    }
    y = 0;
    while (y < height) {
        var line = ""; // []const u8
        var x = 0; // i32
        while (x < width) {
            line = _concat_string(line, grid[y][x]);
            x = (x + 1);
        }
        std.debug.print("{s}\n", .{line});
        y = (y + 1);
    }
}
