ENTRY(_start)

SECTIONS
{
    # Start placing sections at physical address 0x0
    . = 0x0;

    # Multiboot2 header must reside at the very beginning
    # Keep it even if unused by linker optimizations
    .multiboot_header ALIGN(4) : {
        KEEP(*(.multiboot_header))
    }

    # Move location counter to 0x1000 to begin the .text segment
    . = 0x1000;

    # .text segment: all executable code, aligned on a 4 KiB boundary
    .text ALIGN(4K) : {
        *(.text*)
    }

    # Read-only data: constant data and string literals
    .rodata : {
        *(.rodata*)
    }

    # Initialized data: globals with predefined values
    .data : {
        *(.data*)
    }

    # Uninitialized data: zero-filled at load time
    .bss : {
        *(.bss*)
    }

    # Discard debug, comment, and note sections from the final image
    /DISCARD/ : {
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.comment)
        *(.note.*)
        *(.debug_*)
    }
}
