const vga: type = @import("vga");
const VGA = vga.VGA;
const cursor: usize = 0;

pub fn backspace() void {
    if (cursor > 0) {
        cursor -= 1;
        VGA[cursor] = 0x0720;
    }
}
