.section .text
    # Entry point symbol for the kernel
    .global _start
    .type _start, @function

_start:
    # Populate cpu_vendor and cpu_name using CPUID
    call detect_cpu          
    # Jump into the Zig kernel main function
    call kernel_main         

.hang:
    # Halt the CPU until the next external interrupt
    hlt
    # Loop indefinitely to avoid falling through
    jmp .hang
