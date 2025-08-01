.section .multiboot_header, "a"

.align 8
multiboot_header:
    .long 0xe85250d6
    .long 0               # Arch = 0
    .long multiboot_end - multiboot_header
    .long -(0xe85250d6 + 0 + (multiboot_end - multiboot_header))

    .align 8
    .short 0              # Tag: type = 0
    .short 0
    .long 8               # Size

multiboot_end:
