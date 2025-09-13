pub const LimineUUID = extern struct {
    a: u64,
    b: u64,
};

pub const LimineFramebuffer = extern struct {
    address: u64,
    width: u64,
    height: u64,
    pitch: u64,
    bpp: u64,
    memory_type: u64,
};

pub const LimineFramebufferResponse = extern struct {
    framebuffer_count: u64,
    framebuffers: [*]LimineFramebuffer,
};

pub const LimineFramebufferRequest = extern struct {
    id: [2]LimineUUID,
    revision: u64,
    response: ?*LimineFramebufferResponse,
};

pub export var framebuffer_request: LimineFramebufferRequest = .{
    .id = .{
        .{ .a = 0xc7b1dd30df4c8b88, .b = 0x0a82e883a194f07b },
        .{ .a = 0x9d5827dcd881dd75, .b = 0xa3148604f6fab11b },
    },
    .revision = 0,
    .response = null,
};
