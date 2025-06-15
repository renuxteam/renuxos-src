ENTRY(_start)

SECTIONS
{
    
    .multiboot_header ALIGN(16) : {
        KEEP(*(.multiboot_header))
    }

    
    . = 0x1000;

    .text ALIGN(4K) : {
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(.bss*)
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.comment)
        *(.note.*)
        *(.debug_*)
    }
}