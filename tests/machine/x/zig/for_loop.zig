const std = @import("std");

pub fn main() void {
    for (1 .. 4) |i| {
        std.debug.print("{d}\n", .{i});
    }
}
