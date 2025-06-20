const std = @import("std");

pub fn build(b: *std.Build) void {
    // ==== Paths to source files and linker script ====
    const kernelMainPath = b.path("kernel/kernel_main.zig");
    const bootAsmPath = b.path("kernel/boot/boot.s");
    const linkerScript = b.path("linker/linker.ld");

    // ==== Target: 32-bit x86 freestanding environment ====
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86, // 32-bit Intel architecture
            .os_tag = .freestanding, // No OS provided services
            .abi = .none, // No ABI (bare-metal)
        },
    });

    // ==== Optimization level (Debug by default) ====
    const optimize = b.standardOptimizeOption(.{});

    // ==== Assemble boot.s (Multiboot header + entry stub) ====
    const bootObj = b.addObject(.{
        .name = "boot",
        .target = target,
        .optimize = optimize,
    });
    bootObj.addAssemblyFile(bootAsmPath);

    // ==== Compile kernel_main.zig (your 32-bit kernel logic) ====
    const mainObj = b.addObject(.{
        .name = "main",
        .target = target,
        .optimize = optimize,
        .root_source_file = kernelMainPath,
    });
    mainObj.root_module.pic = false; // Position-independent code disabled

    // ==== Create final ELF executable with custom linker script ====
    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .target = target,
        .optimize = optimize,
        .code_model = .kernel,
        .linkage = .static,
    });

    // Attach custom linker script for Multiboot loading at 1MB
    kernel.setLinkerScript(linkerScript);
    kernel.root_module.red_zone = false; // Disable red zone for freestanding
    kernel.root_module.pic = false; // Disable PIC
    kernel.want_lto = false; // No LTO

    // ==== Link the assembled and compiled objects ====
    kernel.addObject(bootObj);
    kernel.addObject(mainObj);

    // ==== Install final kernel ELF as build artifact ====
    b.installArtifact(kernel);
}
