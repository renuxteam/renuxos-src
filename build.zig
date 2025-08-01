const std: type = @import("std");

pub fn build(b: *std.Build) void {
    // ----------------------------------------------------------------
    // 1) Define paths to critical source and ASM files
    // ----------------------------------------------------------------
    const kernelMainPath = b.path("kernel/main.zig"); // Primary Zig entry point
    const multibootAsmPath = b.path("kernel/arch/i386/multiboot_header.S"); // Multiboot2 header assembly
    const inputAsmPath = b.path("kernel/arch/i386/input.S"); // PS/2 keyboard I/O assembly
    const cpuInfoAsmPath = b.path("kernel/arch/i386/cpuid.S"); // CPUID detection assembly
    const startAsmPath = b.path("kernel/arch/i386/start.S"); // Entry stub assembly
    const linkerScript = b.path("linker/linker.ld"); // Custom linker script
    const libPath = b.path("kernel/lib.zig"); // Global library hub

    // ----------------------------------------------------------------
    // 2) Configure target: 32-bit x86 freestanding (bare-metal)
    // ----------------------------------------------------------------
    const target = b.standardTargetOptions(
        .{
            .default_target = .{
                .cpu_arch = .x86, // Intel x86 architecture
                .os_tag = .freestanding, // No underlying OS
                .abi = .none, // No ABI conventions
            },
        },
    );

    // ----------------------------------------------------------------
    // 3) Select optimization level (optimize for size)
    // ----------------------------------------------------------------
    const optimize = b.standardOptimizeOption(
        .{
            .preferred_optimize_mode = .ReleaseSmall,
        },
    );

    // ----------------------------------------------------------------
    // 4) Assemble the Multiboot header into an object
    // ----------------------------------------------------------------
    const bootObj = b.addObject(
        .{
            .name = "boot",
            .root_module = b.createModule(.{ .target = target, .optimize = optimize }),
        },
    );
    bootObj.addAssemblyFile(multibootAsmPath); // Embed Multiboot2 header

    // ----------------------------------------------------------------
    // 5) Create global `lib` module for shared imports
    // ----------------------------------------------------------------
    const libMod = b.createModule(
        .{
            .root_source_file = libPath,
            .target = target,
            .optimize = optimize,
        },
    );

    // ----------------------------------------------------------------
    // 6) Compile the main Zig kernel entry point
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
    mainObj.root_module.addImport("lib", libMod); // Inject shared `lib`
    mainObj.root_module.pic = false; // Disable PIC

    // ----------------------------------------------------------------
    // 7) Import the kernel_main symbol for linkage
    // ----------------------------------------------------------------
    const kernelMainMod = b.createModule(
        .{
            .root_source_file = kernelMainPath,
            .target = target,
            .optimize = optimize,
            .red_zone = false,
        },
    );
    kernelMainMod.addImport("lib", libMod);
    mainObj.root_module.addImport("kernel_main", kernelMainMod);

    // ----------------------------------------------------------------
    // 8) Assemble additional low-level stubs (input, cpuid, start)
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
    asmObj.addAssemblyFile(inputAsmPath); // Keyboard I/O
    asmObj.addAssemblyFile(cpuInfoAsmPath); // CPUID info
    asmObj.addAssemblyFile(startAsmPath); // Entry stub

    // ----------------------------------------------------------------
    // 9) Link final ELF using the custom script
    // ----------------------------------------------------------------
    const kernelExe = b.addExecutable(
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
    kernelExe.setLinkerScript(linkerScript);
    kernelExe.root_module.red_zone = false;
    kernelExe.root_module.pic = false;
    kernelExe.want_lto = false;

    const cargo_step = b.addSystemCommand(
        &.{
            "cargo",
            "build",
            "--release",
            "--manifest-path",
            "microkernel/Cargo.toml",
            "--target",
            "microkernel/src/arch/i386/i386-unknown-none.json",
            "-Z",
            "build-std=core,compiler_builtins",
        },
    );

    kernelExe.step.dependOn(&cargo_step.step);
    kernelExe.addObjectFile(b.path("microkernel/target/i386-unknown-none/release/libmicrokernel.a"));

    // ----------------------------------------------------------------
    // 10) Combine all object files into the final kernel image
    // ----------------------------------------------------------------
    kernelExe.addObject(bootObj); // Multiboot header
    kernelExe.addObject(mainObj); // Main kernel logic
    kernelExe.addObject(asmObj); // Assembly stubs

    // ----------------------------------------------------------------
    // 11) Install the final kernel ELF
    // ----------------------------------------------------------------
    b.installArtifact(kernelExe);
}
