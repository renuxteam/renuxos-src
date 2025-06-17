const std = @import("std");

const limine = @cImport({
    @cInclude("limine.h");
});

pub const LimineBaseRevision = extern struct {
    id: u64 = 0xC7A1BA4BA2A399BE,
    revision: u64 = 0x1A4C23D86BF7C74E,
};

pub export var limine_request: LimineBaseRevision = .{};

const kernel_main = @import("kernel_main.zig").kernel_main;

export fn _zig_start() callconv(.C) noreturn {

    // Call the kernel main function
    kernel_main();

    // Infinite loop to prevent the kernel from exiting
    while (true) {
        // Infinite loop to keep the kernel running
    }
}
