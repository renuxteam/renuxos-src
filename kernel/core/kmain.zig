// External function declarations for framebuffer operations
// These functions are implemented in C and provide graphics capabilities
extern fn fb_init() void; // Initialize framebuffer
extern fn fb_clear(color: u32) void; // Clear screen with specified color
extern fn fb_draw_string(x: usize, y: usize, s: [*]const u8) void; // Draw text at coordinates

/// Kernel main entry point
/// This is the first function called after bootloader hands control to the kernel
/// It initializes the framebuffer, clears the screen, and displays a welcome message
export fn kmain() void {
    // Initialize framebuffer graphics
    fb_init();

    // Clear screen with black color (0x00000000 = black in 32-bit RGB)
    fb_clear(0x00000000);

    // Display welcome messages using framebuffer text rendering
    fb_draw_string(40, 40, "Hello RenuxOS!"); // Main greeting
    fb_draw_string(40, 50, "Now it's 64 bits"); // Architecture info
    fb_draw_string(40, 60, "in modern framebuffer :)"); // Graphics mode info

    // Enter infinite loop to keep the kernel running
    loop();
}

/// Infinite loop function
/// This function puts the CPU in a low-power state using HLT instruction
/// while maintaining kernel operation. The HLT instruction halts the CPU
/// until the next interrupt occurs, saving power while waiting.
fn loop() void {
    while (true) {
        asm volatile (
            \\ hlt  // Halt CPU until interrupt
        );
    }
}
