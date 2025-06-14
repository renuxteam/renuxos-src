.section .text # text section
.global _start # make _start global
.extern _zig_start # declare the Zig start function
_start:
    call _zig_start # call the Zig start function
.hang:
    jmp .hang # infinite loop to hang the kernel