// Generated by Mochi transpiler v0.10.31 on 2025-07-19 14:55:02 GMT+7
const std = @import("std");

pub fn main() void {
    const x: i64 = 12;
    const msg: []const u8 = if ((x > 10)) "yes" else "no";
    std.debug.print("{any}\n", .{msg});
}
