const std: type = @import("std");

const Builder: type = std.Build;

pub fn build(b: *Builder) void {
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

    const kernel_module = b.createModule(.{
        .root_source_file = b.path("core/kmain.zig"),
        .code_model = .kernel,
        .target = target,
        .optimize = optimize,
        .red_zone = false,
        .strip = false,
        .pic = false,
    });

    const drivers_module = b.addModule("drivers", .{
        .root_source_file = b.path("../drivers/drivers.zig"),
        .code_model = .kernel,
        .target = target,
        .optimize = optimize,
        .red_zone = false,
        .strip = false,
    });

    const kernel_obj = b.addObject(.{
        .name = "kernel",
        .root_module = kernel_module,
        .use_llvm = true,
    });

    kernel_obj.root_module.addImport("drivers", drivers_module);

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

    b.getInstallStep().dependOn(&install_artifact.step);
}
