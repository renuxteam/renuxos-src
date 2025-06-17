const std = @import("std"); // import the Zig standard library

const vga = 0xB80000; // base address of VGA text buffer

// Entry point of the kernel
pub fn kernel_main() void {
    // Prevent the kernel from returning by entering an infinite loop
    loop();
}

// Infinite loop function that halts the CPU when idle
fn loop() void {
    // Continuously execute the HLT instruction to reduce power/heat
    while (true) {
        asm volatile ("hlt"); // halt CPU until next interrupt
    }
}
