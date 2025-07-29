const std = @import("std"); // Import Zig’s standard library (reserved for future use)

// Define text color codes for VGA text mode
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

// Combine a foreground and background color into a single byte
pub fn vgaEntryColor(fg: Color, bg: Color) u8 {
    return @as(u8, @intFromEnum(fg)) // low 4 bits = foreground
    | (@as(u8, @intFromEnum(bg)) << 4); // high 4 bits = background
}

// Pack a character byte and a color byte into a 16-bit VGA entry
pub fn vgaEntry(uc: u8, color: u8) u16 {
    return @as(u16, uc) // lower 8 bits = ASCII character
    | (@as(u16, color) << 8); // upper 8 bits = color attribute
}

// Dimensions of the VGA text buffer
pub const VGA_WIDTH: comptime_int = 80;
pub const VGA_HEIGHT: comptime_int = 25;

// VGA text-mode driver state and methods
pub const VGA = struct {
    row: usize, // current cursor row
    column: usize, // current cursor column
    color: u8, // current text color attribute
    buffer: [*]volatile u16, // pointer to VGA text buffer in memory

    // Initialize a VGA instance pointing at physical 0xB8000
    pub fn init() VGA {
        const phys_addr = 0xB8000;
        const buffer_ptr = @as([*]volatile u16, @ptrFromInt(phys_addr));
        return VGA{
            .row = 0,
            .column = 0,
            .color = vgaEntryColor(Color.LightGray, Color.Black),
            .buffer = buffer_ptr,
        };
    }

    // Write a character at (x, y) with the current color
    pub fn putEntryAt(self: *VGA, char: u8, x: usize, y: usize) void {
        const index = y * VGA_WIDTH + x;
        self.buffer[index] = vgaEntry(char, self.color);
    }

    // Change the current text color
    pub fn setColor(self: *VGA, fg: Color, bg: Color) void {
        self.color = vgaEntryColor(fg, bg);
    }

    // Write a single character at the cursor, handling newlines and wrapping
    pub fn putChar(self: *VGA, char: u8) void {
        if (char == '\n') {
            self.newLine();
            return;
        }
        self.putEntryAt(char, self.column, self.row);
        self.column += 1;
        if (self.column >= VGA_WIDTH) self.newLine();
    }

    // Advance to the next line, scrolling if at bottom of screen
    pub fn newLine(self: *VGA) void {
        self.column = 0;
        self.row += 1;
        if (self.row == VGA_HEIGHT) {
            self.scroll();
            self.row = VGA_HEIGHT - 1;
        }
    }

    // Scroll the buffer up by one line and clear the last line
    pub fn scroll(self: *VGA) void {
        // Move each line up
        for (1..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const src_idx = y * VGA_WIDTH + x;
                const dst_idx = (y - 1) * VGA_WIDTH + x;
                self.buffer[dst_idx] = self.buffer[src_idx];
            }
        }
        // Clear the bottom line
        const bottom = VGA_HEIGHT - 1;
        for (0..VGA_WIDTH) |x| {
            self.putEntryAt(' ', x, bottom);
        }
    }

    // Clear the entire screen and reset cursor to top-left
    pub fn clear(self: *VGA) void {
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                self.putEntryAt(' ', x, y);
            }
        }
        self.row = 0;
        self.column = 0;
    }

    // Write a slice of bytes (string) to the screen
    pub fn writeString(self: *VGA, data: []const u8) void {
        for (data) |char| {
            self.putChar(char);
        }
    }

    // Fill the whole screen with a given character and colors
    pub fn fillScreen(self: *VGA, char: u8, fg: Color, bg: Color) void {
        const col_attr = vgaEntryColor(fg, bg);
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const idx = y * VGA_WIDTH + x;
                self.buffer[idx] = vgaEntry(char, col_attr);
            }
        }
        // Reset cursor and current color
        self.row = 0;
        self.column = 0;
        self.color = col_attr;
    }
};

// Global VGA instance
var vga = VGA.init();

// Public wrappers around the VGA instance methods

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
