const lib: type = @import("lib");
const vga: type = lib.drivers.video.vga;
const keyboard: type = lib.drivers.input.keyboard;
const commands: type = @import("commands.zig");

const print: fn ([]const u8) void = vga.write;
const print_char: fn (u8) void = vga.write_char;

pub fn run() void {
    print("RenuxShell v0.1\n");

    while (true) {
        print("> ");
        var input: [128]u8 = undefined;
        const len = read_line(&input);
        if (len > 0) {
            commands.exec(input[0..len]);
        }
    }
}

fn read_line(buf: *[128]u8) usize {
    var index: usize = 0;

    while (true) {
        const key: u8 = keyboard.get_key();
        if (key == 0) {
            continue;
        }
        switch (key) {
            '\n' => {
                print_char('\n');
                break;
            },
            8 => { // Backspace
                if (index > 0) {
                    index -= 1;
                }
            },
            else => {
                if (index < buf.len) {
                    buf[index] = key;
                    print_char(key);
                    index += 1;
                }
            },
        }
    }
    return index;
}
