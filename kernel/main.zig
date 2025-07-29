const std: type = @import("std"); // Import Zig's standard library
const logo: type = @import("logo.zig"); // Import module for drawing the boot logo
const vga: type = @import("drivers/video/vga/vga.zig"); // Import VGA driver for text output
const print: fn ([]const u8) void = vga.write; // Alias vga.write to a simple print function

// Kernel entry point
pub fn kernel_main() void {
    vga.clear(); // Clear the VGA text buffer
    logo.print_logo(); // Render the boot logo to the screen
    print("Hello world!\n"); // Print a greeting message
    loop(); // Enter idle loop to keep the kernel alive
}

// Idle loop that halts the CPU until the next interrupt
fn loop() void {
    while (true) {
        asm volatile ("hlt"); // Use the HLT instruction to pause the CPU and reduce power usage
    }
}
