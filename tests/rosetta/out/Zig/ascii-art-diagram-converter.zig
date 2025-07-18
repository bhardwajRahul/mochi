// Generated by Mochi compiler v0.10.28 on 2025-07-18T10:00:45Z
const std = @import("std");

fn user_main() void {
    std.debug.print("Diagram after trimming whitespace and removal of blank lines:\n\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("|                      ID                       |\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("|                    QDCOUNT                    |\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("|                    ANCOUNT                    |\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("|                    NSCOUNT                    |\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("|                    ARCOUNT                    |\n", .{});
    std.debug.print("+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\n", .{});
    std.debug.print("\nDecoded:\n\n", .{});
    std.debug.print("Name     Bits  Start  End\n", .{});
    std.debug.print("=======  ====  =====  ===\n", .{});
    std.debug.print("ID        16      0    15\n", .{});
    std.debug.print("QR         1     16    16\n", .{});
    std.debug.print("Opcode     4     17    20\n", .{});
    std.debug.print("AA         1     21    21\n", .{});
    std.debug.print("TC         1     22    22\n", .{});
    std.debug.print("RD         1     23    23\n", .{});
    std.debug.print("RA         1     24    24\n", .{});
    std.debug.print("Z          3     25    27\n", .{});
    std.debug.print("RCODE      4     28    31\n", .{});
    std.debug.print("QDCOUNT   16     32    47\n", .{});
    std.debug.print("ANCOUNT   16     48    63\n", .{});
    std.debug.print("NSCOUNT   16     64    79\n", .{});
    std.debug.print("ARCOUNT   16     80    95\n", .{});
    std.debug.print("\nTest string in hex:\n", .{});
    std.debug.print("78477bbf5496e12e1bf169a4\n", .{});
    std.debug.print("\nTest string in binary:\n", .{});
    std.debug.print("011110000100011101111011101111110101010010010110111000010010111000011011111100010110100110100100\n", .{});
    std.debug.print("\nUnpacked:\n\n", .{});
    std.debug.print("Name     Size  Bit pattern\n", .{});
    std.debug.print("=======  ====  ================\n", .{});
    std.debug.print("ID        16   0111100001000111\n", .{});
    std.debug.print("QR         1   0\n", .{});
    std.debug.print("Opcode     4   1111\n", .{});
    std.debug.print("AA         1   0\n", .{});
    std.debug.print("TC         1   1\n", .{});
    std.debug.print("RD         1   1\n", .{});
    std.debug.print("RA         1   1\n", .{});
    std.debug.print("Z          3   011\n", .{});
    std.debug.print("RCODE      4   1111\n", .{});
    std.debug.print("QDCOUNT   16   0101010010010110\n", .{});
    std.debug.print("ANCOUNT   16   1110000100101110\n", .{});
    std.debug.print("NSCOUNT   16   0001101111110001\n", .{});
    std.debug.print("ARCOUNT   16   0110100110100100\n", .{});
}

pub fn main() void {
    user_main();
}
