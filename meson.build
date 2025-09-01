project('RenuxOS','cpp',
    default_options: [
        'cpp_std=c++23',
        'buildtype=debugoptimized',
    ]
)

configure_file(
    input: 'linker/linker.ld',
    output: 'linker.ld',
    copy: true
)

kernel_src = files(
    'kernel/kmain.cpp',
    'kernel/arch/i386/multiboot_header.S',
    'kernel/arch/i386/boot.S',
    'kernel/drivers/video/vga/vga.cpp',
)


executable('renuxos.elf',kernel_src,
cpp_args: [
    '-ffreestanding','-fno-exceptions','-fno-rtti','-m32','-Os', '-no-pie', '-nostdlib'
],
link_args: [
    '-m32', '-T','linker.ld','-nostdlib'
]
)