ENTRY(_start)

SECTIONS
{
    /* Header tem que estar em 0x0 */
    .multiboot_header ALIGN(4) : {
        KEEP(*(.multiboot_header))
    }

    /* Kernel começa a partir de 0x1000, por exemplo */
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
        *(.comment)
    }
}
