const std = @import("std");

const Todo = struct { title: []const u8 };

const todo = Todo{ .title = "hi" }; // Todo

pub fn main() void {
    std.debug.print("{s}\n", .{todo.title});
}
