ENTRY(_start)

SECTIONS
{
    . = 0x00100000;   

    .multiboot_header : {
        KEEP(*(.multiboot_header))
    }

    .text : {
        *(.text._start)
        *(.text*)
    }

    .rodata : { *(.rodata*) }
    .data   : { *(.data*) }
    .bss    : { *(.bss*) }

    /DISCARD/ : {
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.comment)
        *(.note.*)
        *(.debug_*)
    }
}
