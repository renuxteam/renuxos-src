const std = @import("std");

const kernel_main = @import("kernel_main.zig").kernel_main;

export fn _zig_start() callconv(.C) noreturn {
    // Call the kernel main function
    kernel_main();

    // Infinite loop to prevent the kernel from exiting
    while (true) {
        // Infinite loop to keep the kernel running
    }
}
