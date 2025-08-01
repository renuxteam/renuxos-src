const lib: type = @import("lib"); // Import the global lib hub
const logo: type = lib.common.logo; // Alias to the boot logo module
const color: type = lib.drivers.video.vga.Color; // VGA color enum
const shell = @import("shell/shell.zig");
const set_color: fn (color, color) void = lib.drivers.video.vga.setColor;
// Function to set foreground & background
const print: fn ([]const u8) void = lib.drivers.video.vga.write;
// Function to write a byte slice to screen
const cpu: type = lib.arch; // Alias to architecture-specific code

// ----------------------------------------------------------------
// Kernel Entry Point
// ----------------------------------------------------------------
// `kernel_main` is the symbol that GRUB (multiboot2) will jump to.
// It prints the logo, a greeting, CPU info, and then enters idle.
export fn kernel_main() void {
    // 1) Change text color to Green on Black background
    set_color(color.Green, color.Black);

    // 2) Draw the ASCII art boot logo
    print(logo.logo_ascii);

    // 3) Move to next line after logo
    print("\n");

    // 4) Print a welcome message
    print("Hello World!");
    print("\n");

    // 5) Show CPU vendor string
    print("CPU Vendor: ");
    print(cpu.get_cpu()); // 12-char vendor ID, e.g. "GenuineIntel"
    print("\n");

    // 6) Show CPU brand/name string
    print("CPU: ");
    print(cpu.get_cpu_name()); // 48-char brand, e.g. "Intel(R) Core(TM) i7..."
    print("\n");
    shell.run();
    // 7) Hand off to idle loop (HTL) — kernel never returns
    loop();
}

// ----------------------------------------------------------------
// Idle HLT Loop
// ----------------------------------------------------------------
// This loop halts the CPU until the next interrupt, saving power
// and preventing the kernel from busy-waiting.
fn loop() void {
    while (true) {
        asm volatile ("hlt"); // Inline assembly: execute HLT instruction
    }
}
