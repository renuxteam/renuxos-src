#include <stdint.h>      // Standard integer types
#include <limine.h>      // Limine boot protocol headers

/**
 * Framebuffer request structure for the Limine boot protocol
 * 
 * This volatile struct is used to request a framebuffer from the bootloader.
 * The Limine boot protocol uses this structure to communicate framebuffer
 * capabilities and provide a graphical display interface to the kernel.
 * 
 * The 'volatile' keyword ensures the compiler doesn't optimize away this
 * structure, as it needs to be accessible to the bootloader during early boot.
 */
volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,  // Unique identifier for framebuffer request
    .revision = 0,                     // Protocol revision (0 for current version)
};
