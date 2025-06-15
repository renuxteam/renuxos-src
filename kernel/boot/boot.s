.section .multiboot
.align 4
    .long 0x1BADB002        # magic number (Multiboot 1)
    .long 0x00000003        # flags (request memory info and boot device)
    .long -(0x1BADB002 + 0x00000003)  # checksum

.section .text
.global _start
.extern _zig_start

_start:
    call _zig_start        # call the boot.zig

hang:
    cli                     # disable interrupts
    hlt                     # halt the CPU
    jmp hang                # infinite loop
