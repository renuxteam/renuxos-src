const std = @import("std");

pub fn build(b: *std.Build) void {
    // Variables for the build process

    // Path to the kernel source file
    const kernel_path = b.path("kernel/start.zig");

    // Kernel name
    const kernel_name = "kernel.elf";

    // Linker script path
    const linker_script_path = b.path("linker/linker.ld");

    // Target options
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
        .abi = .none,
    } });

    // Optimization settings
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .Debug });

    // Kernel object file
    const kernel_obj = b.addObject(.{ .name = kernel_name, .target = target, .optimize = optimize, .root_source_file = kernel_path });

    // Kernel file
    const kernel = b.addExecutable(.{
        .name = kernel_name,
        .target = target,
        .optimize = optimize,
        .code_model = .kernel,
        .linkage = .static,
    });
    // Main the kernel
    const main_name = "main";
    const main_kernel_path = b.path("kernel/kernel_main.zig");

    const main_kernel = b.addObject(.{ .name = main_name, .target = target, .optimize = optimize, .root_source_file = main_kernel_path });

    // ASMs names
    const boot_asm_name = "boot";
    const boot_asm_path = b.path("kernel/boot/boot.s");

    // Entry ASM file
    const entry_asm = b.addAssembly(.{ .name = boot_asm_name, .target = target, .optimize = optimize, .source_file = boot_asm_path });

    // Set the linker script for the kernel
    kernel.setLinkerScript(linker_script_path);
    // Add the kernel object file
    kernel.addObject(kernel_obj);
    // Add the Main object file
    kernel.addObject(main_kernel);
    // Add the entry ASM file to the kernel
    kernel.addObject(entry_asm);
    // Disable red zone for the kernel
    kernel.root_module.red_zone = false;
    // Disable PIC
    kernel.root_module.pic = false;
    main_kernel.root_module.pic = false;
    // Disable LTO
    kernel.want_lto = false;
    b.installArtifact(kernel);
}
