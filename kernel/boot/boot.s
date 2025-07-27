.section .multiboot2
.align 8

    # Multiboot2 magic + header length
    .long 0xe85250d6          # Magic number
    .long 0                   # Architecture (0 = 32-bit)
    .long multiboot_end - multiboot_header  # Header length
    .long -(0xe85250d6 + 0 + (multiboot_end - multiboot_header)) # Checksum

multiboot_header:

    # Optional tags: just end tag here
    .align 8
    .short 0                  # Type: end tag
    .short 0
    .long 8                   # Size of end tag

multiboot_end:

.section .text
.type _start, @function
.hang:
    hlt
    jmp .hang

.section .bss
.align 16
stack_bottom:
    .skip 0x4000             # 16KB stack
stack_top:
