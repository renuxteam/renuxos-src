.section .multiboot_header
    .align 8
    .long 0xe85250d6                  # Magic
    .long 0                          # Architecture = 0 (32-bit)
    .long multiboot_end - multiboot_header
    .long -(0xe85250d6 + 0 + (multiboot_end - multiboot_header))

multiboot_header:
    .align 8
    .short 0                         # Reserved
    .short 0                         # Reserved
    .long 8                          # Size of end tag
multiboot_end:
