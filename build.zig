const std = @import("std");

pub fn build(b: *std.Build) void {
    // Variables for the build process

    // Path to the kernel source file
    const kernel_path = b.path("kernel/kernel.zig");

    // Kernel name
    const kernel_name = "kernel";

    // Linker script path
    const linker_script_path = b.path("linker/linker.ld");

    // Target options
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = .x86_64,
        .os_tag = .freestanding,
    } });

    // Optimization settings
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    // Kernel object file
    const kernel_obj = b.addObject(.{ .name = kernel_name, .target = target, .optimize = optimize, .root_source_file = kernel_path, .code_model = .kernel, .use_llvm = true });

    // Kernel file
    const kernel = b.addExecutable(.{
        .name = kernel_name,
        .target = target,
        .optimize = optimize,
        .code_model = .kernel,
        .use_llvm = true,
    });
    // Main the kernel
    const main_name = "main";
    const main_kernel_path = b.path("kernel/main.zig");

    const main_kernel = b.addObject(.{ .name = main_name, .target = target, .optimize = optimize, .root_source_file = main_kernel_path, .code_model = .kernel, .use_llvm = true });

    // ASMs names
    const entry_asm_name = "entry";
    const multiboot_header_name = "multiboot_header";

    // ASMs paths
    const entry_path = b.path("kernel/boot/entry.s");
    const multiboot_header_path = b.path("kernel/boot/multiboot_header.s");

    // Multiboot header file
    const multiboot_header = b.addAssembly(.{
        .name = multiboot_header_name,
        .target = target,
        .optimize = optimize,
        .source_file = multiboot_header_path,
    });

    // Entry ASM file
    const entry_asm = b.addAssembly(.{ .name = entry_asm_name, .target = target, .optimize = optimize, .source_file = entry_path });

    // Set the linker script for the kernel
    kernel.setLinkerScript(linker_script_path);
    // Add the multiboot_header ASM to the Kernel
    kernel.addObject(multiboot_header);
    // Add the kernel object file
    kernel.addObject(kernel_obj);
    // Add the Main object file
    kernel.addObject(main_kernel);
    // Add the entry ASM file to the kernel
    kernel.addObject(entry_asm);
    // Disable red zone for the kernel
    kernel.root_module.red_zone = false;
    // Disable LTO
    kernel.want_lto = false;

    b.installArtifact(kernel);
}
