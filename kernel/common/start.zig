const std = @import("std"); // Import Zig’s standard library (available for future use)
const main = @import("main.zig"); // Bring in your kernel’s main module

// Low-level entry point symbol recognized by the linker/bootloader
export fn _start() void {
    main.kernel_main(); // Jump into the kernel’s main function
}
