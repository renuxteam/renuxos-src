const std = @import("std");
// Import VGA driver
const vga = @import("drivers/video/vga.zig");
// Kernel main function
pub fn kernel_main() void {
    vga.clear();
    vga.setColor(.LightRed, .Black);
    vga.write("Hello World!\n");
    vga.write("I Love RenuxOS");
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
