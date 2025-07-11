const std = @import("std");

fn _read_input(path: ?[]const u8) []const u8 {
    const alloc = std.heap.page_allocator;
    if (path == null or std.mem.eql(u8, path.?, "-")) {
        return std.io.getStdIn().readAllAlloc(alloc, 1 << 20) catch |err| handleError(err);
    } else {
        return std.fs.cwd().readFileAlloc(alloc, path.?, 1 << 20) catch |err| handleError(err);
    }
}

fn _write_output(path: ?[]const u8, data: []const u8) void {
    if (path == null or std.mem.eql(u8, path.?, "-")) {
        std.io.getStdOut().writeAll(data) catch |err| handleError(err);
    } else {
        std.fs.cwd().writeFile(path.?, data) catch |err| handleError(err);
    }
}

fn _save_json(rows: anytype, path: ?[]const u8) void {
    var buf = std.ArrayList(u8).init(std.heap.page_allocator);
    defer buf.deinit();
    if (rows.len == 1) {
        std.json.stringify(rows[0], .{}, buf.writer()) catch |err| handleError(err);
    } else {
        std.json.stringify(rows, .{}, buf.writer()) catch |err| handleError(err);
    }
    _write_output(path, buf.items);
}

const PeopleItem = struct {
    name: []const u8,
    age: i32,
};
const people = &[_]PeopleItem{
    PeopleItem{
    .name = "Alice",
    .age = 30,
},
    PeopleItem{
    .name = "Bob",
    .age = 25,
},
}; // []const Peopleitem

pub fn main() void {
    _save_json(people, "-");
}
