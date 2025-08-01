ENTRY(_start)

SECTIONS
{

    .multiboot_header ALIGN(8) : {
        KEEP(*(.multiboot_header))
    }


    
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
