const std = @import("std"); // import the Zig standard library

// Entry point of the kernel
pub fn kernel_main() void {
    loop(); // call infinite loop to prevent returning from the kernel
}

// Infinite loop function that halts the CPU when idle
fn loop() void {
    while (true) {
        asm volatile ("hlt"); // execute HLT instruction to pause CPU until next interrupt
    }
}
