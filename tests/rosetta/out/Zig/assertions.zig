// Generated by Mochi compiler v0.10.28 on 2025-07-18T10:00:57Z
const std = @import("std");

fn user_main() void {
    const x = 43; // i32
    if (x != 42) {
        std.debug.print("Assertion failed\n", .{});
    } else {
        std.debug.print("Assertion passed\n", .{});
    }
}

pub fn main() void {
    user_main();
}
