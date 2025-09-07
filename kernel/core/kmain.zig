const vga: type = @import("drivers").vga;
const print: fn ([]const u8) void = vga.print;

export fn kmain() void {
    print("Hello RenuxOS");

    loop();
}

fn loop() void {
    while (true) {
        asm volatile (
            \\ hlt
        );
    }
}
