extern fn fb_init() void;
extern fn fb_clear(color: u32) void;
extern fn fb_draw_string(x: usize, y: usize, s: [*]const u8) void;

export fn kmain() void {
    fb_init();
    fb_clear(0x00000000);

    fb_draw_string(40, 40, "Hello RenuxOS !");
    fb_draw_string(40, 50, "Now it's 64 bits");
    fb_draw_string(40, 60,"in  modern framebuffer :)");
    loop();
}

fn loop() void {
    while (true) {
        asm volatile (
            \\ hlt
        );
    }
}
