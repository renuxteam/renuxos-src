const std = @import("std"); // import the Zig standard library

pub fn build(b: *std.Build) void {
    // Path to the kernel start source file
    const kernel_path = b.path("kernel/start.zig");

    // Name of the generated kernel executable
    const kernel_name = "kernel.elf";

    // Path to the custom linker script
    const linker_script_path = b.path("linker/linker.ld");

    // Configure target triple: x86_64, freestanding OS, no ABI
    const target = b.standardTargetOptions(.{
        .default_target = .{
            .cpu_arch = .x86_64,
            .os_tag = .freestanding,
            .abi = .none,
        },
    });

    // Use Debug optimization mode
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    // Compile the initial kernel object from start.zig
    const kernel_obj = b.addObject(.{
        .name = kernel_name,
        .target = target,
        .optimize = optimize,
        .root_source_file = kernel_path,
    });

    // Create the final kernel executable
    const kernel = b.addExecutable(.{
        .name = kernel_name,
        .target = target,
        .optimize = optimize,
        .code_model = .large, // allow large code/data sections
        .linkage = .static, // static linking
    });

    // Compile the main kernel code (kernel_main.zig)
    const main_name = "main";
    const main_kernel_path = b.path("kernel/kernel_main.zig");
    const main_kernel = b.addObject(.{
        .name = main_name,
        .target = target,
        .optimize = optimize,
        .root_source_file = main_kernel_path,
    });

    // Assemble the boot entry (boot.s)
    const boot_asm_name = "boot";
    const boot_asm_path = b.path("kernel/boot/boot.s");
    const entry_asm = b.addAssembly(.{
        .name = boot_asm_name,
        .target = target,
        .optimize = optimize,
        .source_file = boot_asm_path,
    });

    // Apply our custom linker script to the kernel
    kernel.setLinkerScript(linker_script_path);

    // Link in all compiled objects
    kernel.addObject(kernel_obj);
    kernel.addObject(main_kernel);
    kernel.addObject(entry_asm);

    // Kernel-specific flags: disable red zone and PIC
    kernel.root_module.red_zone = false;
    kernel.root_module.pic = false;
    main_kernel.root_module.pic = false;

    // Disable link-time optimizations
    kernel.want_lto = false;

    // Install the final kernel artifact (makes it available after build)
    b.installArtifact(kernel);
}
