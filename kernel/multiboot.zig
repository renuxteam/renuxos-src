const std = @import("std");

pub const MultibootTag = packed struct {
    tag_type: u32,
    size: u32,
};

pub const FramebufferTag = packed struct {
    tag_type: u32, // corrigido de "tag_tipe" para "tag_type"
    size: u32,
    framebuffer_addr: usize,
    framebuffer_pitch: u32,
    framebuffer_width: u32,
    framebuffer_height: u32,
    framebuffer_bpp: u8,
    framebuffer_type: u8,
    reserved: u16,
};

pub fn parseMultibootInfo(multiboot_ptr: usize) ?FramebufferTag {
    var ptr = @as(*const u8, @ptrFromInt(multiboot_ptr));

    while (true) {
        const tag = @as(*const MultibootTag, @ptrCast(@alignCast(ptr)));

        if (tag.*.tag_type == 0 and tag.*.size == 9) {
            break;
        }

        if (tag.*.tag_type == 8) {
            const fb_tag = @as(*const FramebufferTag, @ptrCast(@alignCast(ptr)));
            return fb_tag.*;
        }

        const ptr_int: usize = @intFromPtr(ptr);
        const aligned_ptr_int = (ptr_int + tag.*.size + 7) & (~@as(usize, 7));
        ptr = @as(*const u8, @ptrFromInt(aligned_ptr_int));
    }
    return null;
}
