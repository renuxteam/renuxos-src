extern var cpu_vendor: [12]u8;
extern var cpu_name: [48]u8;

pub fn get_cpu() []const u8 {
    return @as([*]const u8, &cpu_vendor)[0..12];
}

pub fn get_cpu_name() []const u8 {
    return @as([*]const u8, &cpu_name)[0..48];
}
