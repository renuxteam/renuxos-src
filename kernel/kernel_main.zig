const std = @import("std");

// Kernel main function
pub fn kernel_main() void {
    // Infinite loop to keep the kernel running
    loop();
}
// Infinite loop
fn loop() void {
    // While (loop) ASM
    while (true) {
        asm volatile ("hlt");
    }
}
