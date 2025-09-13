const drivers = @import("drivers");
const fb = drivers.kspace.fb;

/// Kernel main entry point
/// This is the first function called after bootloader hands control to the kernel
/// It initializes the framebuffer, clears the screen, and displays a welcome message
export fn _start() void {
    // Initialize framebuffer graphics
    fb.fb_init();

    // Clear screen with black color (0x00000000 = black in 32-bit RGB)
    fb.fb_clear(0x00000000);

    // Display welcome messages using framebuffer text rendering
    fb.fb_draw_string(40, 40, "Hello RenuxOS!"); // Main greeting

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
