// Generated by Mochi compiler v0.10.27 on 2025-07-17T17:59:22Z
const std = @import("std");

fn expect(cond: bool) void {
    if (!cond) @panic("expect failed");
}

fn test_addition_works() void {
    const x = (1 + 2); // i32
    expect((x == 3));
}

pub fn main() void {
    std.debug.print("ok\n", .{});
    test_addition_works();
}
