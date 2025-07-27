const std = @import("std"); // import the Zig standard library

const vga = @import("drivers/video/vga/vga.zig");

// Entry point of the kernel
export fn kernel_main() void {
    vga.clear();
    vga.write("Hello world!\n");
    loop(); // call infinite loop to prevent returning from the kernel
}

// Infinite loop function that halts the CPU when idle
fn loop() void {
    while (true) {
        asm volatile ("hlt"); // execute HLT instruction to pause CPU until next interrupt
    }
}
