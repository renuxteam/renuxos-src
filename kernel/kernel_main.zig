const std = @import("std");
const multiboot = @import("multiboot.zig");

const VGA = @as([*]volatile u16, @ptrFromInt(0xB8000));

// Kernel main function
pub fn kernel_main() void {
    VGA[0] = (@as(u16, 0x0F) << 8) | 'R';
    VGA[1] = (@as(u16, 0x0F) << 8) | 'E';
    VGA[2] = (@as(u16, 0x0F) << 8) | 'N';
    VGA[3] = (@as(u16, 0x0F) << 8) | 'U';
    VGA[4] = (@as(u16, 0x0F) << 8) | 'X';
    VGA[5] = (@as(u16, 0x0F) << 8) | 'O';
    VGA[6] = (@as(u16, 0x0F) << 8) | 'S';
    VGA[7] = (@as(u16, 0x0F) << 8) | ' ';
    VGA[8] = (@as(u16, 0x0F) << 8) | 'B';
    VGA[9] = (@as(u16, 0x0F) << 8) | 'Y';
    VGA[10] = (@as(u16, 0x0F) << 8) | ' ';
    VGA[11] = (@as(u16, 0x0F) << 8) | 'R';
    VGA[12] = (@as(u16, 0x0F) << 8) | 'E';
    VGA[13] = (@as(u16, 0x0F) << 8) | 'N';
    VGA[14] = (@as(u16, 0x0F) << 8) | 'A';
    VGA[15] = (@as(u16, 0x0F) << 8) | 'N';

    // Infinite loop to keep the kernel running
    while (true) {
        // Do nothing, just keep the kernel alive
        asm volatile ("hlt");
    }
}
