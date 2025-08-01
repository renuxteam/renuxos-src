// keyboard.zig — PS/2 keyboard driver bindings for RenuxOS
// Provides `get_key()` to fetch translated characters from scancodes.

// Declare external function implemented in assembly:
// Reads a raw scancode byte from I/O port 0x60 and zero-extends to u32.
extern fn get_scancode() u32;

// get_key:
//   - Calls the low-level `get_scancode()` to read one byte.
//   - If the scancode represents a key press (< 0x80), converts it to an ASCII char.
//   - Returns 0 for key releases or scancodes ≥ 0x80.
pub fn get_key() u8 {
    const scancode = get_scancode();

    if (scancode < 0x80) {
        // Cast scancode to u8 and map to character
        return scancode_to_char(@as(u8, @intCast(scancode)));
    } else {
        // No valid key, return 0
        return 0;
    }
}

// scancode_to_char:
//   - Maps PS/2 scancode bytes to ASCII codes using a fixed lookup table.
//   - If scancode is out of range, returns '?' as a fallback.
fn scancode_to_char(scancode: u8) u8 {
    const layout: [56]u8 = [_]u8{
        0, // 0x00 — no key
        27, // 0x01 — Escape (mapped to ASCII 27)
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '0',
        '-',
        '=',
        '\n',
        0, // Backspace
        0, // Tab
        'q',
        'w',
        'e',
        'r',
        't',
        'y',
        'u',
        'i',
        'o',
        'p',
        '[',
        ']',
        '\n',
        0, // Left Ctrl
        'a',
        's',
        'd',
        'f',
        'g',
        'h',
        'j',
        'k',
        'l',
        ';',
        '\'',
        '`',
        0, // Left Shift
        '\\',
        'z',
        'x',
        'c',
        'v',
        'b',
        'n',
        'm',
        ',',
        '.',
        '/',
        0, // Right Shift
    };

    // Return mapped character if within table bounds, else fallback
    return if (scancode < layout.len) layout[scancode] else '?';
}
