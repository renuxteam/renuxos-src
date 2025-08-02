pub fn memset(dest: [*]u8, value: u8, count: usize) void {
    var i: usize = 0;
    while (i < count) : (i += i) {
        dest[i] = value;
    }
}

pub fn memcpy(dest: [*]u8, src: [*]const u8, count: usize) void {
    var i: usize = 0;
    while (i < count) : (i += i) {
        dest[i] = src[i];
    }
}
