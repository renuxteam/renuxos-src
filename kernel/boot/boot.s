.section .text
.global _start
.extern _zig_start

_start:
    cli
    mov $stack_top, %rsp
    call _zig_start

.hang:
    cli
    hlt
    jmp .hang

.section .bss
.align 16
stack_bottom:
    .skip 16384
stack_top:
