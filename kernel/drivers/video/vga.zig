const std = @import("std");

const PHYS_BASE: usize = 0xFFFF800000000000;

pub const Color = enum(u4) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    Pink = 13,
    Yellow = 14,
    White = 15,
};

pub fn vgaEntryColor(fg: Color, bg: Color) u8 {
    return @as(u8, @intFromEnum(fg)) | @as(u8, @intFromEnum(bg)) << 4;
}

pub fn vgaEntry(uc: u8, color: u8) u16 {
    return @as(u16, uc) | (@as(u16, color) << 8);
}

pub const VGA_WIDTH = 80;
pub const VGA_HEIGHT = 25;

pub const VGA = struct {
    row: usize,
    column: usize,
    color: u8,
    buffer: [*]volatile u16,

    pub fn init() VGA {
        const pys_addr: usize = 0xB8000;
        const buffer_ptr = @as([*]volatile u16, @ptrFromInt(pys_addr));
        return VGA{
            .row = 0,
            .column = 0,
            .color = vgaEntryColor(Color.LightGray, Color.Black),
            .buffer = buffer_ptr,
        };
    }

    pub fn putEntryAt(self: *VGA, char: u8, x: usize, y: usize) void {
        const index = y * VGA_WIDTH + x;
        self.buffer[index] = vgaEntry(char, self.color);
    }

    pub fn setColor(self: *VGA, fg: Color, bg: Color) void {
        self.color = vgaEntryColor(fg, bg);
    }

    pub fn putChar(self: *VGA, char: u8) void {
        if (char == '\n') {
            self.newLine();
            return;
        }
        self.putEntryAt(char, self.column, self.row);
        self.column += 1;
        if (self.column >= VGA_WIDTH) self.newLine();
    }

    pub fn newLine(self: *VGA) void {
        self.column = 0;
        self.row += 1;

        if (self.row == VGA_HEIGHT) {
            self.scroll();
            self.row = VGA_HEIGHT - 1;
        }
    }

    pub fn scroll(self: *VGA) void {
        for (1..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const src_index = y * VGA_WIDTH + x;
                const dst_index = (y - 1) * VGA_WIDTH + x;
                self.buffer[dst_index] = self.buffer[src_index];
            }
        }
        const last_line = VGA_HEIGHT - 1;
        for (0..VGA_WIDTH) |x| {
            self.putEntryAt(' ', x, last_line);
        }
    }

    pub fn clear(self: *VGA) void {
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                self.putEntryAt(' ', x, y);
            }
        }
        self.row = 0;
        self.column = 0;
    }

    pub fn writeString(self: *VGA, data: []const u8) void {
        for (data) |char| {
            self.putChar(char);
        }
    }

    pub fn fillScreen(self: *VGA, char: u8, fg: Color, bg: Color) void {
        const color = vgaEntryColor(fg, bg);
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const index = y * VGA_WIDTH + x;
                self.buffer[index] = vgaEntry(char, color);
            }
        }
        self.row = 0;
        self.column = 0;
        self.color = color;
    }
};

var vga = VGA.init();

pub fn clear() void {
    vga.clear();
}

pub fn fillScreen(char: u8, fg: Color, bg: Color) void {
    vga.fillScreen(char, fg, bg);
}

pub fn write(data: []const u8) void {
    vga.writeString(data);
}

pub fn setColor(fg: Color, bg: Color) void {
    vga.setColor(fg, bg);
}
