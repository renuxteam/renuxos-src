const std = @import("std");
const teste = @import("drivers/video/vga.zig");

// VGA Debug
const VGA = @as([*]volatile u16, @ptrFromInt(0xb8000));

// Kernel main function
pub fn kernel_main() void {
    // Print RENUXOS in screen using VGA_BUFFER (Text Mode)
    VGA[0] = (@as(u16, 0x0F) << 8) | 'R';
    VGA[1] = (@as(u16, 0x0F) << 8) | 'E';
    VGA[2] = (@as(u16, 0x0F) << 8) | 'N';
    VGA[3] = (@as(u16, 0x0F) << 8) | 'U';
    VGA[4] = (@as(u16, 0x0F) << 8) | 'X';
    VGA[5] = (@as(u16, 0x0F) << 8) | 'O';
    VGA[6] = (@as(u16, 0x0F) << 8) | 'S';

    // Infinite loop to keep the kernel running
    while (true) {
        // Do nothing, just keep the kernel alive
        asm volatile ("hlt");
    }
}
