.section .text
    .global _start
    .type _start, @function

_start:
    call kmain         
.hang:
    hlt
    jmp .hang