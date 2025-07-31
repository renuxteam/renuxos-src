const std: type = @import("std"); // Import Zig’s standard library for future utilities
const logo: type = @import("common/logo.zig"); // Module that renders the boot logo
const vga: type = @import("drivers/video/vga/vga.zig"); // VGA text‐mode driver for output
const cpu: type = @import("arch/x86/cpuid.zig"); // CPUID wrapper to query CPU info

// Create a simple `print` alias pointing to the VGA write function
const print: fn ([]const u8) void = vga.write;

// ----------------------------------------------------------------
// Kernel Entry Point
// ----------------------------------------------------------------
// This function is exported as the symbol `_start` by the linker.
// It draws the ASCII art logo, prints greetings, displays CPU data,
// and then spins in an idle loop to keep the kernel alive.
export fn kernel_main() void {
    logo.print_logo(); // Draw the boot logo
    print("\n"); // Newline after logo

    print("Hello World!"); // Print greeting
    print("\n"); // Newline after greeting
    print("CPU Vendor: "); // Print CPU vendor
    print(cpu.get_cpu()); // Print the 12‐byte CPU vendor string
    print("\n"); // Newline between vendor and brand
    print("CPU: "); // Print CPU
    print(cpu.get_cpu_name()); // Print the 48‐byte CPU brand string

    loop(); // Enter idle HLT loop
}

// ----------------------------------------------------------------
// Idle HLT Loop
// ----------------------------------------------------------------
// Halts the CPU until the next external interrupt, then repeats.
// This reduces power usage and prevents the kernel from “running off.”
fn loop() void {
    while (true) {
        asm volatile ("hlt"); // Issue HLT instruction in-line
    }
}
