const std: type = @import("std");

pub fn build(b: *std.Build) void {
    // ----------------------------------------------------------------
    // Paths to source files and linker script
    // ----------------------------------------------------------------
    const kernelMainPath = b.path("kernel/main.zig");
    const multibootAsmPath = b.path("kernel/arch/x86/multiboot_header.S");
    const inputAsmPath = b.path("kernel/arch/x86/input.S");
    const linkerScript = b.path("linker/linker.ld");
    const cpuInfoAsmPath = b.path("kernel/arch/x86/cpuid.S");
    const startAsmPath = b.path("kernel/arch/x86/start.S");
    const libPath = b.path("kernel/lib.zig");

    // ----------------------------------------------------------------
    // Target configuration: 32-bit x86, freestanding (bare-metal)
    // ----------------------------------------------------------------
    const target = b.standardTargetOptions(
        .{
            .default_target = .{
                .cpu_arch = .x86,
                .os_tag = .freestanding,
                .abi = .none,
            },
        },
    );

    // ----------------------------------------------------------------
    // Optimization level: ReleaseSmall by default
    // ----------------------------------------------------------------
    const optimize = b.standardOptimizeOption(
        .{
            .preferred_optimize_mode = .ReleaseSmall,
        },
    );

    // ----------------------------------------------------------------
    // Assemble multiboot header and entry stub
    // ----------------------------------------------------------------
    const bootObj = b.addObject(
        .{
            .name = "boot",
            .root_module = b.createModule(
                .{
                    .target = target,
                    .optimize = optimize,
                },
            ),
        },
    );
    bootObj.addAssemblyFile(multibootAsmPath);

    const lib = b.createModule(
        .{
            .root_source_file = libPath,
            .target = target,
            .optimize = optimize,
        },
    );

    // ----------------------------------------------------------------
    // Compile kernel main as the entry point
    // ----------------------------------------------------------------
    const mainObj = b.addObject(
        .{
            .name = "main",
            .root_module = b.createModule(
                .{
                    .target = target,
                    .optimize = optimize,
                    .root_source_file = kernelMainPath,
                    .red_zone = false,
                },
            ),
        },
    );
    mainObj.root_module.addImport("lib", lib);
    mainObj.root_module.pic = false;

    // ----------------------------------------------------------------
    // Create and import the kernel main module
    // ---------------------------------------------------------------
    const kernelMainMod = b.createModule(
        .{
            .root_source_file = kernelMainPath,
            .target = target,
            .optimize = optimize,
            .red_zone = false,
        },
    );

    kernelMainMod.addImport("lib", lib);
    mainObj.root_module.addImport("kernel_main", kernelMainMod);

    // ----------------------------------------------------------------
    // Add start-up assembly
    // ----------------------------------------------------------------
    const asmObj = b.addObject(
        .{
            .name = "start",
            .root_module = b.createModule(
                .{
                    .target = target,
                    .optimize = optimize,
                    .red_zone = false,
                },
            ),
        },
    );
    asmObj.addAssemblyFile(multibootAsmPath);
    asmObj.addAssemblyFile(inputAsmPath);
    asmObj.addAssemblyFile(cpuInfoAsmPath);
    asmObj.addAssemblyFile(startAsmPath);

    // ----------------------------------------------------------------
    // Link final ELF executable with custom linker script
    // ----------------------------------------------------------------
    const kernel = b.addExecutable(
        .{
            .name = "kernel.elf",
            .root_module = b.createModule(
                .{
                    .target = target,
                    .optimize = optimize,
                    .code_model = .default,
                },
            ),
        },
    );
    kernel.setLinkerScript(linkerScript);
    kernel.root_module.red_zone = false;
    kernel.root_module.pic = false;
    kernel.want_lto = false;

    // ----------------------------------------------------------------
    // Combine objects into the final ELF
    // ----------------------------------------------------------------
    kernel.addObject(mainObj);
    kernel.addObject(asmObj);
    // ----------------------------------------------------------------
    // Install the kernel ELF as a build artifact
    // ----------------------------------------------------------------
    b.installArtifact(kernel);
}

fn withlib(step: anytype, lib: *std.Build.Module) void {
    step.root_module.addImport("lib", lib);
}
