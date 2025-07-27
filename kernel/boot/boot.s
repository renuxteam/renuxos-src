    .section .multiboot2            # Define the Multiboot2 header section
    .align 8                       # Align to 8-byte boundary

    # Multiboot2 header fields
    .long 0xe85250d6               # Magic value required by Multiboot2 spec
    .long 0                        # Architecture: 0 = 32-bit
    .long multiboot_end - multiboot_header
                                   # Total header size in bytes
    .long -(0xe85250d6 + 0 + (multiboot_end - multiboot_header))
                                   # Checksum so that all four longs sum to zero

multiboot_header:
    .align 8                       # Align tags to 8-byte boundary

    # Tag list: here we only have the mandatory end tag
    .short 0                       # Tag type: 0 (end tag)
    .short 0                       # Flags (unused for end tag)
    .long 8                        # Size of this tag in bytes

multiboot_end:                     # Label marking end of header and tags

    .section .text                 # Start of code section
    .type _start, @function        # Declare _start as a function symbol

_start:
.hang:
    hlt                            # Halt CPU until next interrupt
    jmp .hang                      # Infinite loop after halt

    .section .bss                  # Uninitialized data section
    .align 16                      # Align stack to 16-byte boundary

stack_bottom:
    .skip 0x4000                   # Reserve 16 KB for the stack
stack_top:                         # Label for the top of the stack
