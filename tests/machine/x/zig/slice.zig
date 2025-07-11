const std = @import("std");

fn _slice_list(comptime T: type, v: []const T, start: i32, end: i32, step: i32) []T {
    var s = start;
    var e = end;
    var st = step;
    const n: i32 = @as(i32, @intCast(v.len));
    if (s < 0) s += n;
    if (e < 0) e += n;
    if (st == 0) st = 1;
    if (s < 0) s = 0;
    if (e > n) e = n;
    if (st > 0 and e < s) e = s;
    if (st < 0 and e > s) e = s;
    var res = std.ArrayList(T).init(std.heap.page_allocator);
    defer res.deinit();
    var i: i32 = s;
    while ((st > 0 and i < e) or (st < 0 and i > e)) : (i += st) {
        res.append(v[@as(usize, @intCast(i))]) catch |err| handleError(err);
    }
    return res.toOwnedSlice() catch |err| handleError(err);
}

fn _slice_string(s: []const u8, start: i32, end: i32, step: i32) []const u8 {
    var sidx = start;
    var eidx = end;
    var stp = step;
    const n: i32 = @as(i32, @intCast(s.len));
    if (sidx < 0) sidx += n;
    if (eidx < 0) eidx += n;
    if (stp == 0) stp = 1;
    if (sidx < 0) sidx = 0;
    if (eidx > n) eidx = n;
    if (stp > 0 and eidx < sidx) eidx = sidx;
    if (stp < 0 and eidx > sidx) eidx = sidx;
    var res = std.ArrayList(u8).init(std.heap.page_allocator);
    defer res.deinit();
    var i: i32 = sidx;
    while ((stp > 0 and i < eidx) or (stp < 0 and i > eidx)) : (i += stp) {
        res.append(s[@as(usize, @intCast(i))]) catch |err| handleError(err);
    }
    return res.toOwnedSlice() catch |err| handleError(err);
}

pub fn main() void {
    std.debug.print("{any}\n", .{_slice_list(i32, &[_]i32{
    1,
    2,
    3,
}, 1, 3, 1)});
    std.debug.print("{any}\n", .{_slice_list(i32, &[_]i32{
    1,
    2,
    3,
}, 0, 2, 1)});
    std.debug.print("{s}\n", .{_slice_string("hello", 1, 4, 1)});
}
