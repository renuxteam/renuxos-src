    .section .text
    .global long_mode_entry

long_mode_entry:
    # You are already in 64-bit mode, ready to run the kernel

    # Set up the stack pointer (rsp)
    lea stack_top(%rip), %rsp
    
    call kernel_main

.hang:
    cli             # Disable interrupts
    hlt             # Halt CPU until the next interrupt
    jmp .hang       # Infinite loop to keep CPU halted safely

    .section .bss
    .align 16
stack_bottom:
    .skip 16384     # Reserve 16 KiB for stack
stack_top:
