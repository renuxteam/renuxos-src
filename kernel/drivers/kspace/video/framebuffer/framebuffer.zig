const limine: type = @import("limine_request.zig");

pub extern fn fb_init() void;
pub extern fn fb_clear(color: u32) void;
pub extern fn fb_draw_string(x: usize, y: usize, s: [*]const u8) void;
