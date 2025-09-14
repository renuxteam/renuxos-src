extern fn fb_init() void;
extern fn keyboard_init() void;
extern fn fb_clear(color: u32) void;
extern fn fb_put_char_cursor(c: u8, color: u32) void;

/// Kernel main entry point
/// This is the first function called after the bootloader hands control to the kernel.
/// It initializes the framebuffer, clears the screen with a dark blue color, and displays
/// a welcome message. After initialization, it enters an infinite loop to keep the kernel running.
export fn _start() void {
    // Initialize framebuffer graphics using Limine framebuffer request
    fb_init();

    fb_put_char_cursor('A', 0xFFFFFFFF);
    keyboard_init();
    // Enter infinite loop to keep the kernel running
    while (true) {
        asm volatile ("hlt");
    }
}
