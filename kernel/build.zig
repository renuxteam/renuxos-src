const std: type = @import("std");
const Builder: type = std.Build;

pub fn build(b: *Builder) void {
    // Configure target options
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86_64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    // Optimization (default: Debug)
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    // Kernel module (root source)
    const kernel_module = b.createModule(.{
        .root_source_file = b.path("core/kernel.zig"),
        .code_model = .kernel,
        .target = target,
        .optimize = optimize,
        .red_zone = false,
        .strip = false,
        .pic = false,
    });

    // Build object from module
    const kernel_obj = b.addObject(.{
        .name = "kernel",
        .root_module = kernel_module,
        .use_llvm = true,
    });

    // Install to custom output dir
    const out_path: []const u8 = "../../obj";
    const install_artifact = b.addInstallArtifact(
        kernel_obj,
        .{
            .dest_dir = .{
                .override = .{
                    .custom = out_path,
                },
            },
        },
    );

    // Ensure install step depends on build
    b.getInstallStep().dependOn(&install_artifact.step);
}
