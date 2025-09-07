#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H

#include <stdint.h>
#include <stddef.h>

// Initialize framebuffer using the Limine-provided framebuffer_request.
// Must be called once after boot (before drawing).
void fb_init(void);

// Clear screen with 0x00RRGGBB color (assumes 32bpp XRGB8888).
void fb_clear(uint32_t color);

// Put a pixel at (x,y). No bounds-check side effects (safe to call, will clip).
void fb_put_pixel(size_t x, size_t y, uint32_t color);

// Draw a null-terminated ASCII string at (x,y).
// Each glyph is 8x8, fixed spacing (8px).
// Accepted characters are simple ASCII (fallback to space for unknown).
void fb_draw_string(size_t x, size_t y, const char* s);

#endif // FRAMEBUFFER_H
