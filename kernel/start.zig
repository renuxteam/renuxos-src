const std = @import("std");
const main = @import("main.zig");

export fn _start() void {
    main.kernel_main();
}
