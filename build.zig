const std = @import("std");

pub fn build(b: *std.Build) void {
    // Paths
    const kernel_start_path = b.path("kernel/kernel_start.zig");
    const kernel_main_path = b.path("kernel/kernel_main.zig");
    const linker_script_path = b.path("linker/linker.ld");

    // Import the limime_zig module
    const limine_zig = b.dependency("limine_zig", .{ .api_revision = 3 });
    const limine_module = limine_zig.module("limine");

    // Output kernel name
    const kernel_name = "kernel.elf";

    // Target and optimization
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86_64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    // Compile kernel_start.zig (entry + Limine)
    const kernel_start_obj = b.addObject(.{
        .name = "start",
        .target = target,
        .optimize = optimize,
        .root_source_file = kernel_start_path,
        .code_model = .large,
    });

    kernel_start_obj.root_module.pic = false;
    kernel_start_obj.root_module.addImport("limine", limine_module);

    // Compile kernel_main.zig (your logic)
    const kernel_main_obj = b.addObject(.{
        .name = "main",
        .target = target,
        .optimize = optimize,
        .root_source_file = kernel_main_path,
        .code_model = .large,
    });

    kernel_main_obj.root_module.pic = false;
    kernel_main_obj.root_module.addImport("limine", limine_module);

    // Final executable
    const kernel = b.addExecutable(.{
        .name = kernel_name,
        .target = target,
        .optimize = optimize,
        .code_model = .large,
        .linkage = .static,
    });

    kernel.setLinkerScript(linker_script_path);
    kernel.root_module.red_zone = false;
    kernel.root_module.pic = false;
    kernel.want_lto = false;

    // Link both objects
    kernel.addObject(kernel_start_obj);
    kernel.addObject(kernel_main_obj);

    // Install final ELF
    b.installArtifact(kernel);
}
