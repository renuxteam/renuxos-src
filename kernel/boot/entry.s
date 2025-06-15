.section .text # text section
.global _start # make _start global
.extern _zig_start # declare the Zig start function

_start:
    movl $stack_top, %esp # configure basic stack
    call _zig_start # call the Zig start function

.hang:
    cli
    hlt
    jmp .hang # infinite loop to hang the kernel

.no_multiboot:
    movl $0x4f204f20, 0xb8000 # Write ' ' in red
    jmp .hang

.section .bss
.balign 16
stack_bottom:
    .space 16384 # 16KB of stack
stack_top:
