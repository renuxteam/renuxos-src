const std = @import("std");

pub fn build(b: *std.Build) void {
    // ----------------------------------------------------------------
    // Paths to source files and linker script
    // ----------------------------------------------------------------
    const kernelMainPath = b.path("kernel/start.zig");
    const bootAsmPath = b.path("kernel/boot/boot.s");
    const linkerScript = b.path("linker/linker.ld");

    // ----------------------------------------------------------------
    // Target configuration: 32-bit x86, freestanding (bare-metal)
    // ----------------------------------------------------------------
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86, // Intel 32-bit architecture (i386)
            .os_tag = .freestanding, // No operating system services available
            .abi = .none, // No ABI (bare-metal environment)
        },
    });

    // ----------------------------------------------------------------
    // Optimization level (debug mode by default)
    // ----------------------------------------------------------------
    const optimize = b.standardOptimizeOption(.{});

    // ----------------------------------------------------------------
    // Assemble boot.s: includes the Multiboot2 header and entry stub
    // ----------------------------------------------------------------
    const bootObj = b.addObject(.{
        .name = "boot",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });
    bootObj.addAssemblyFile(bootAsmPath);

    // ----------------------------------------------------------------
    // Compile kernel_main.zig: your 32-bit kernel logic module
    // ----------------------------------------------------------------
    const mainObj = b.addObject(.{
        .name = "main",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .root_source_file = kernelMainPath,
        }),
    });
    mainObj.root_module.pic = false; // Disable position-independent code

    // ----------------------------------------------------------------
    // Link final ELF executable with custom linker script
    // ----------------------------------------------------------------
    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .code_model = .kernel, // Use kernel code model
        }),
    });

    // Use custom linker script to place sections at the correct addresses
    kernel.setLinkerScript(linkerScript);
    kernel.root_module.red_zone = false; // Disable red zone for freestanding
    kernel.root_module.pic = false; // Disable PIC
    kernel.want_lto = false; // Disable link-time optimization

    // ----------------------------------------------------------------
    // Combine assembled and compiled object files into the final ELF
    // ----------------------------------------------------------------
    kernel.addObject(bootObj);
    kernel.addObject(mainObj);

    // ----------------------------------------------------------------
    // Install the kernel ELF as a build artifact
    // ----------------------------------------------------------------
    b.installArtifact(kernel);
}
