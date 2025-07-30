const std: type = @import("std");

pub fn build(b: *std.Build) void {
    // ----------------------------------------------------------------
    // Paths to source files and linker script
    // ----------------------------------------------------------------
    const kernelStartPath = b.path(
        "kernel/init/start.zig",
    );
    const kernelMainPath = b.path(
        "kernel/main.zig",
    );
    const bootAsmPath = b.path(
        "kernel/arch/x86/boot.s",
    );
    const linkerScript = b.path(
        "linker/linker.ld",
    );

    // ----------------------------------------------------------------
    // Target configuration: 32-bit x86, freestanding (bare-metal)
    // ----------------------------------------------------------------
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86, // Intel 32-bit architecture (i386)
            .os_tag = .freestanding, // No OS services available
            .abi = .none, // Bare-metal environment
        },
    });

    // ----------------------------------------------------------------
    // Optimization level (ReleaseSmall mode by default)
    // ----------------------------------------------------------------
    const optimize = b.standardOptimizeOption(
        .{
            .preferred_optimize_mode = .ReleaseSmall,
        },
    );

    // ----------------------------------------------------------------
    // Assemble boot.s: includes the Multiboot2 header and entry stub
    // ----------------------------------------------------------------
    const bootObj = b.addObject(.{
        .name = "boot",
        .root_module = b.createModule(
            .{
                .target = target,
                .optimize = optimize,
            },
        ),
    });
    bootObj.addAssemblyFile(bootAsmPath);

    // ----------------------------------------------------------------
    // Compile start.zig: sets up the entry point of the kernel
    // ----------------------------------------------------------------
    const mainObj = b.addObject(.{
        .name = "main",
        .root_module = b.createModule(
            .{
                .target = target,
                .optimize = optimize,
                .root_source_file = kernelStartPath,
            },
        ),
    });
    mainObj.root_module.pic = false; // Disable position-independent code

    // ----------------------------------------------------------------
    // Create and import the kernel main module
    // ----------------------------------------------------------------
    const kernelMainMod = b.createModule(
        .{
            .root_source_file = kernelMainPath,
            .target = target,
            .optimize = optimize,
        },
    );
    mainObj.root_module.addImport("kernel_main", kernelMainMod);

    // ----------------------------------------------------------------
    // Link final ELF executable with custom linker script
    // ----------------------------------------------------------------
    const kernel = b.addExecutable(.{
        .name = "kernel.elf",
        .root_module = b.createModule(
            .{
                .target = target,
                .optimize = optimize,
                .code_model = .default, // Use default code model for kernel
            },
        ),
    });

    // Use the custom linker script to place sections correctly
    kernel.setLinkerScript(linkerScript);
    kernel.root_module.red_zone = false; // Disable red zone
    kernel.root_module.pic = false; // Disable PIC
    kernel.want_lto = false; // Disable link-time optimization

    // ----------------------------------------------------------------
    // Combine assembled and compiled objects into the final ELF
    // ----------------------------------------------------------------
    kernel.addObject(bootObj);
    kernel.addObject(mainObj);

    // ----------------------------------------------------------------
    // Install the kernel ELF as a build artifact
    // ----------------------------------------------------------------
    b.installArtifact(kernel);
}
