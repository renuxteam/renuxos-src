ENTRY(_start)

SECTIONS
{
    . = 0xFFFFFFFF80000000;

    .text ALIGN(0x1000) : {
        *(.text)
        *(.text.*)
    }

    .rodata ALIGN(0x1000) : {
        *(.rodata*)
    }

    .data ALIGN(0x1000) : {
        *(.data*)
    }

    .bss ALIGN(0x1000) : {
        *(.bss*)
        *(COMMON)
    }

        .limine_requests_start :
    {
        KEEP(*(.limine_requests_start))
    }

    .limine_requests :
    {
        KEEP(*(.limine_requests))
    }

    .limine_requests_end :
    {
        KEEP(*(.limine_requests_end))
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.eh_frame_hdr)
        *(.comment)
        *(.note.*)
        *(.debug_*)
    }
}