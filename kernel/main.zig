const std = @import("std");

const VGA_BUFFER = @as([*]volatile u16, @ptrFromInt(0xB8000));

// Kernel main function
pub fn kernel_main() void {
    const attr: u16 = 0x0F << 8; // White text on black background
    // write OK on VGA
    VGA_BUFFER[0] = ('O' | attr);
    VGA_BUFFER[1] = ('K' | attr);

    // Infinite loop to keep the kernel running
    while (true) {
        // Do nothing, just keep the kernel alive
        asm volatile ("hlt");
    }
}
