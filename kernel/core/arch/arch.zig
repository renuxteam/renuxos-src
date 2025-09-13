const builtin: type = @import("builtin");

pub const Arch = switch (builtin.cpu.arch) {
    .x86_64 => @import("x86_64/"),
    else => @compileError("kernel : Unsupported CPu architecture"),
};
