const std = @import("std"); // Import Zig’s standard library (reserved for future use)

// ----------------------------------------------------------------
// VGA text-mode color definitions
// ----------------------------------------------------------------
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

// ----------------------------------------------------------------
// Pack foreground and background colors into a single byte
// ----------------------------------------------------------------
pub fn vgaEntryColor(fg: Color, bg: Color) u8 {
    // Lower 4 bits: foreground color, Upper 4 bits: background color
    return @as(u8, @intFromEnum(fg)) | (@as(u8, @intFromEnum(bg)) << 4);
}

// ----------------------------------------------------------------
// Pack an ASCII character and color attribute into a 16-bit cell
// ----------------------------------------------------------------
pub fn vgaEntry(uc: u8, color: u8) u16 {
    // Low byte = character, High byte = color attribute
    return @as(u16, uc) | (@as(u16, color) << 8);
}

// ----------------------------------------------------------------
// VGA text buffer dimensions
// ----------------------------------------------------------------
pub const VGA_WIDTH: comptime_int = 80;
pub const VGA_HEIGHT: comptime_int = 25;

// ----------------------------------------------------------------
// VGA text-mode driver state and methods
// ----------------------------------------------------------------
pub const VGA = struct {
    row: usize, // Current cursor row (0-based)
    column: usize, // Current cursor column (0-based)
    color: u8, // Current VGA color attribute byte
    buffer: [*]volatile u16, // Pointer to VGA text buffer at 0xB8000

    /// Initialize a VGA driver instance pointing to 0xB8000
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

    /// Write a character `char` at position (x, y) using `self.color`
    pub fn putEntryAt(self: *VGA, char: u8, x: usize, y: usize) void {
        const idx = y * VGA_WIDTH + x;
        self.buffer[idx] = vgaEntry(char, self.color);
    }

    /// Change the current drawing color
    pub fn setColor(self: *VGA, fg: Color, bg: Color) void {
        self.color = vgaEntryColor(fg, bg);
    }

    /// Write a character at the cursor, handle newline and wrapping
    pub fn putChar(self: *VGA, char: u8) void {
        if (char == '\n') {
            self.newLine();
            return;
        }
        self.putEntryAt(char, self.column, self.row);
        self.column += 1;
        if (self.column >= VGA_WIDTH) {
            self.newLine();
        }
    }

    /// Move cursor to the next line, scrolling if at the bottom
    pub fn newLine(self: *VGA) void {
        self.column = 0;
        self.row += 1;
        if (self.row == VGA_HEIGHT) {
            self.scroll();
            self.row = VGA_HEIGHT - 1;
        }
    }

    /// Scroll the text buffer up by one line and clear the last row
    pub fn scroll(self: *VGA) void {
        // Shift each line up by copying cells
        for (1..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const src = y * VGA_WIDTH + x;
                const dst = (y - 1) * VGA_WIDTH + x;
                self.buffer[dst] = self.buffer[src];
            }
        }
        // Clear the bottom line
        const bottom = VGA_HEIGHT - 1;
        for (0..VGA_WIDTH) |x| {
            self.putEntryAt(' ', x, bottom);
        }
    }

    /// Clear the entire screen and reset cursor to (0,0)
    pub fn clear(self: *VGA) void {
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                self.putEntryAt(' ', x, y);
            }
        }
        self.row = 0;
        self.column = 0;
    }

    /// Write a slice of bytes to the screen
    pub fn writeString(self: *VGA, data: []const u8) void {
        for (data) |c| {
            self.putChar(c);
        }
    }

    /// Fill the entire screen with a single character and colors
    pub fn fillScreen(self: *VGA, char: u8, fg: Color, bg: Color) void {
        const attr = vgaEntryColor(fg, bg);
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const idx = y * VGA_WIDTH + x;
                self.buffer[idx] = vgaEntry(char, attr);
            }
        }
        self.row = 0;
        self.column = 0;
        self.color = attr;
    }
};

// ----------------------------------------------------------------
// Global VGA instance and public API wrappers
// ----------------------------------------------------------------
var vga = VGA.init();

// Clear the screen
pub fn clear() void {
    vga.clear();
}

// Fill screen with `char` in specified colors
pub fn fillScreen(char: u8, fg: Color, bg: Color) void {
    vga.fillScreen(char, fg, bg);
}

// Write a string to VGA
pub fn write(data: []const u8) void {
    vga.writeString(data);
}

// Set the text color
pub fn setColor(fg: Color, bg: Color) void {
    vga.setColor(fg, bg);
}
