const std = @import("std"); // import the Zig standard library

// Define the Limine base revision identifiers for boot protocol
pub const LimineBaseRevision = extern struct {
    id: u64 = 0xC7A1BA4BA2A399BE, // unique Limine request ID
    revision: u64 = 0x1A4C23D86BF7C74E, // specific Limine protocol revision
};

// Declare the global Limine request variable, exported for the bootloader
pub export var limine_request: LimineBaseRevision = .{};

// Import the kernel_main function from another Zig file
const kernel_main = @import("kernel_main.zig").kernel_main;

// Entry point for the kernel, using C calling convention and never returning
export fn _kernel_start() callconv(.C) noreturn {
    // Call the main kernel function
    kernel_main();

    // Prevent return by looping indefinitely
    while (true) {
        asm volatile ("hlt"); // halt CPU until next interrupt
    }
}
