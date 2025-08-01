// Re-export the VGA driver module,
// so any code importing `lib` can access text-mode screen functions as `lib.vga`.
pub const vga: type = @import("vga/vga.zig");
