.section .text
    .global _start
    .type _start, @function

_start:
    call detect_cpu          
    call kernel_main         
.hang:
    hlt
    jmp .hang
