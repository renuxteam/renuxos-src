const std = @import("std");

const kernel_main = @import("kernel_main.zig").kernel_main;

const multiboot = @import("multiboot.zig");

const ptr = @as([*]volatile u16, @ptrFromInt(0xB8000));

export fn _zig_start() callconv(.C) noreturn {
    // Call the kernel main function
    kernel_main();

    // Infinite loop to prevent the kernel from exiting
    while (true) {
        // Infinite loop to keep the kernel running
    }
}
