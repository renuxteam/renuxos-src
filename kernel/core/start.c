#include <stdint.h>

// External declaration of the kernel main function
extern void kmain(void);

// Entry point of the kernel (called by the bootloader)
void _start(void) {
    // Call the main kernel function
    kmain();
    
    // Infinite loop to prevent the processor from executing random instructions
    // after kmain() returns. The 'hlt' instruction halts the CPU until the next interrupt.
    while (1) {
        __asm__ ("hlt");
    }
}