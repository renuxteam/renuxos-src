#include <limine.h>

/*
 * Limine framebuffer request structure
 * ------------------------------------
 * The Limine bootloader inspects global variables of type
 * `struct limine_framebuffer_request` to determine which framebuffer
 * features the kernel requests. The bootloader will fill the
 * `response` pointer with a `struct limine_framebuffer_response *` if
 * a framebuffer is available.
 *
 * Requirements / notes:
 *  - The variable must be non-static and have external linkage so the
 *    bootloader can find it in the kernel image.
 *  - The field `id` must be set to the LIMINE_FRAMEBUFFER_REQUEST
 *    constant (provided by limine.h). That identifies this request to
 *    the bootloader.
 *  - The `response` pointer is initialized to NULL (0). The bootloader
 *    will populate it before transferring control to the kernel.
 *  - The object should be declared `volatile` to prevent the compiler
 *    from optimizing away reads to the response field (the value is
 *    written by the bootloader, outside the normal C flow).
 *
 * Typical usage in kernel code:
 *  - Check `framebuffer_request.response` for NULL before using the
 *    framebuffer.
 *  - Read `framebuffer_request.response->framebuffers[i]` to access
 *    actual framebuffer info (address, width, height, etc.).
 */

volatile struct limine_framebuffer_request framebuffer_request = {
    /* Identify this request as the framebuffer request */
    .id = LIMINE_FRAMEBUFFER_REQUEST,

    /* The bootloader will fill this in. Initialize to 0 to be explicit. */
    .response = 0,
};
