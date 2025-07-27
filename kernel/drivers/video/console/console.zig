const fmt = @import("std").fmt;
const vga = @import("../vga/vga.zig");

pub fn print(comptime format: []const u8, args: anytype) void {
    var buffer: [512]u8 = undefined;

    const len = fmt.format(&buffer, format, args) catch return;

    var i: usize = 0;

    while (i < len) : (i += 1) {}
}
