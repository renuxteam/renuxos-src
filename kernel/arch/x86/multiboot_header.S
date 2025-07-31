.section .multiboot_header
    # ----------------------------------------------------------------
    # Multiboot2 header for GRUB-compatible bootloaders
    # ----------------------------------------------------------------
    .align 8
    .long 0xe85250d6                                # Magic number
    .long 0                                        # Architecture = 0 (32-bit)
    .long multiboot_end - multiboot_header         # Total header length
    .long -(0xe85250d6 + 0 + (multiboot_end - multiboot_header))  # Checksum

multiboot_header:
    # ----------------------------------------------------------------
    # End tag (terminates the header, at least 8 bytes long)
    # ----------------------------------------------------------------
    .align 8
    .short 0                                      # Type = 0 (end tag)
    .short 0                                      # Reserved
    .long 8                                       # Size of this tag

multiboot_end:
