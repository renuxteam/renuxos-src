const std = @import("std");
const kernel_main = @import("kernel_main.zig");

export fn _start() noreturn {
    kernel_main();
}
