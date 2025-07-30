const std: type = @import("std"); // Import Zig's standard library
const logo: type = @import("common/logo.zig"); // Import module for drawing the boot logo
const vga: type = @import("drivers/video/vga/vga.zig"); // Import VGA driver for text output
const print: fn ([]const u8) void = vga.write; // Alias vga.write to a simple print function

// Kernel entry point
pub fn kernel_main() void {
    logo.print_logo();
    print("\n");
    print("Hello World!");
    loop(); // Enter idle loop to keep the kernel alive
}

// Idle loop that halts the CPU until the next interrupt
fn loop() void {
    while (true) {
        asm volatile ("hlt"); // Use the HLT instruction to pause the CPU and reduce power usage
    }
}
