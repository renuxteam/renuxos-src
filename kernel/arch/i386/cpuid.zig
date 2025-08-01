extern var cpu_vendor: [12]u8;
extern var cpu_name: [48]u8;

// ----------------------------------------------------------------
// Extern CPU identifier buffers
// ----------------------------------------------------------------
//
// cpu_vendor is populated in assembly (cpuid.S) with the
// 12-byte CPU vendor ID string.
//
// cpu_name is populated in assembly with the
// 48-byte full CPU brand string.
//
pub fn get_cpu() []const u8 {
    // Return a slice of the 12-byte vendor buffer
    return @as([*]const u8, &cpu_vendor)[0..12];
}

// ----------------------------------------------------------------
// Extern CPU brand name buffer
// ----------------------------------------------------------------
//
// Returns the full 48-byte CPU brand string
// as a read-only byte slice.
//
pub fn get_cpu_name() []const u8 {
    // Return a slice of the 48-byte name buffer
    return @as([*]const u8, &cpu_name)[0..48];
}
