const std = @import("std");

pub fn exec(command: []const u8) void {
    if (std.mem.eql(u8, command, "help")) {
        print("Comandos disponíveis:\n");
        print(" - help: mostra os comandos\n");
    } else {
        print("Comando desconhecido: ");
        print(command);
        print("\n");
    }
}

fn print(text: []const u8) void {
    const vga = @import("lib").drivers.video.vga;
    vga.write(text);
}
