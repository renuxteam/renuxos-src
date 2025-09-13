// Kernel build configuration for RenuxOS
// This file defines the build process for the RenuxOS kernel using Zig's build system

const std: type = @import("std");
const Builder: type = std.Build;

/// Main build function called by Zig's build system
/// Configures the kernel compilation process including target, optimization, and module setup
pub fn build(b: *Builder) void {
    // Configure target options for the kernel
    // x86_64 architecture, freestanding environment (no OS), no specific ABI

    
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86_64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    // Set optimization level - default to Debug for development
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    // Create the main kernel module
    // This module contains the core kernel entry point and functionality
    const kernel_module = b.createModule(.{
        .root_source_file = b.path("core/kernel.zig"), // Main kernel entry point
        .code_model = .kernel, // Use kernel code model
        .target = target, // Target configuration
        .optimize = optimize, // Optimization level
        .red_zone = false, // Disable red zone for kernel code
        .strip = false, // Keep debug symbols
        .pic = false, // No position independent code
    });

    // Create drivers module that contains all hardware drivers
    const drivers_module = b.addModule("drivers", .{
        .root_source_file = b.path("drivers/drivers.zig"), // Drivers entry point
        .code_model = .kernel, // Use kernel code model
        .target = target, // Target configuration
        .optimize = optimize, // Optimization level
        .red_zone = false, // Disable red zone
        .strip = false, // Keep debug symbols
    });

    const limine_request_module = b.addModule("limine_request", .{
        .root_source_file = b.path("drivers/kspace/video/framebuffer/limine_request.zig"), // Drivers entry point
        .code_model = .kernel, // Use kernel code model
        .target = target, // Target configuration
        .optimize = optimize, // Optimization level
        .red_zone = false, // Disable red zone
        .strip = false, // Keep debug symbols
    });

    

    // Create kernel object file from the kernel module
    const limine_request_obj = b.addObject(.{
        .name = "limine_request", // Output filename
        .root_module = limine_request_module, // Use kernel module as root
        .use_llvm = true, // Use LLVM backend for compilation
    });


    // Create kernel object file from the kernel module
    const kernel_obj = b.addObject(.{
        .name = "kernel", // Output filename
        .root_module = kernel_module, // Use kernel module as root
        .use_llvm = true, // Use LLVM backend for compilation
    });

    // Import drivers module into kernel module so kernel can access drivers
    kernel_obj.root_module.addImport("drivers", drivers_module);
    kernel_obj.addObject(limine_request_obj);

    // Output directory for the compiled kernel object
    const out_path: []const u8 = "../../obj";

    // Configure installation artifact - specifies where to place the compiled kernel
    const install_artifact = b.addInstallArtifact(
        kernel_obj,
        .{
            .dest_dir = .{
                .override = .{
                    .custom = out_path, // Custom output directory
                },
            },
        },
    );

    // Make the install step depend on our kernel compilation
    // This ensures the kernel gets built when running 'zig build'
    b.getInstallStep().dependOn(&install_artifact.step);
}
