const std = @import("std"); // import the Zig standard library

const PHYS_BASE: usize = 0xFFFF800000000000; // base of higher-half direct map

// Define VGA text colors as 4-bit enum values
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

// Combine foreground and background into a single byte
pub fn vgaEntryColor(fg: Color, bg: Color) u8 {
    return @as(u8, @intFromEnum(fg)) // low 4 bits for fg
    | (@as(u8, @intFromEnum(bg)) << 4); // high 4 bits for bg
}

// Pack an ASCII character and its color into a 16-bit VGA entry
pub fn vgaEntry(uc: u8, color: u8) u16 {
    return @as(u16, uc) | (@as(u16, color) << 8);
}

pub const VGA_WIDTH = 80; // screen width in characters
pub const VGA_HEIGHT = 25; // screen height in characters

pub const VGA = struct {
    row: usize, // current cursor row
    column: usize, // current cursor column
    color: u8, // current text color
    buffer: [*]volatile u16, // pointer to VGA text buffer

    // Initialize VGA struct with default settings
    pub fn init() VGA {
        const phys_addr: usize = 0xB8000; // physical VGA buffer
        const buffer_ptr = @as([*]volatile u16, @ptrFromInt(phys_addr));
        return VGA{
            .row = 0,
            .column = 0,
            .color = vgaEntryColor(Color.LightGray, Color.Black),
            .buffer = buffer_ptr,
        };
    }

    // Write a character at specific (x, y) coordinates
    pub fn putEntryAt(self: *VGA, char: u8, x: usize, y: usize) void {
        const index = y * VGA_WIDTH + x;
        self.buffer[index] = vgaEntry(char, self.color);
    }

    // Change the current text color
    pub fn setColor(self: *VGA, fg: Color, bg: Color) void {
        self.color = vgaEntryColor(fg, bg);
    }

    // Write a single character at cursor position, handling newline
    pub fn putChar(self: *VGA, char: u8) void {
        if (char == '\n') {
            self.newLine();
            return;
        }
        self.putEntryAt(char, self.column, self.row);
        self.column += 1;
        if (self.column >= VGA_WIDTH) self.newLine();
    }

    // Move cursor to next line, scrolling if at bottom
    pub fn newLine(self: *VGA) void {
        self.column = 0;
        self.row += 1;
        if (self.row == VGA_HEIGHT) {
            self.scroll();
            self.row = VGA_HEIGHT - 1;
        }
    }

    // Scroll screen up by one line to make room
    pub fn scroll(self: *VGA) void {
        // shift all lines up
        for (1..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                const src_index = y * VGA_WIDTH + x;
                const dst_index = (y - 1) * VGA_WIDTH + x;
                self.buffer[dst_index] = self.buffer[src_index];
            }
        }
        // clear the last line
        const last_line = VGA_HEIGHT - 1;
        for (0..VGA_WIDTH) |x| {
            self.putEntryAt(' ', x, last_line);
        }
    }

    // Clear entire screen and reset cursor
    pub fn clear(self: *VGA) void {
        for (0..VGA_HEIGHT) |y| {
            for (0..VGA_WIDTH) |x| {
                self.putEntryAt(' ', x, y);
            }
        }
        self.row = 0;
        self.column = 0;
    }

    // Write a string to the screen
    pub fn writeString(self: *VGA, data: []const u8) void {
        for (data) |char| {
            self.putChar(char);
        }
    }

    // Fill the screen with a character and color
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

var vga = VGA.init(); // global VGA instance

// Public API: clear the screen
pub fn clear() void {
    vga.clear();
}

// Public API: fill screen with a pattern
pub fn fillScreen(char: u8, fg: Color, bg: Color) void {
    vga.fillScreen(char, fg, bg);
}

// Public API: write a text buffer
pub fn write(data: []const u8) void {
    vga.writeString(data);
}

// Public API: set text color
pub fn setColor(fg: Color, bg: Color) void {
    vga.setColor(fg, bg);
}
