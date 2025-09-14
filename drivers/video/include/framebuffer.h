#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H

#include <stdint.h>
#include <stddef.h>

// External declarations for framebuffer state variables
extern uint8_t* fb_addr;          // Pointer to framebuffer memory
extern size_t fb_width;           // Width of framebuffer in pixels
extern size_t fb_height;          // Height of framebuffer in pixels
extern size_t fb_pitch;           // Pitch (bytes per scanline)
extern size_t fb_bpp;             // Bits per pixel
extern size_t fb_bytes_per_pixel; // Bytes per pixel (bpp / 8)
extern size_t cursor_x;
extern size_t cursor_y;
extern const size_t CHAR_WIDTH;
extern const size_t CHAR_HEIGHT;
extern const size_t SCREEN_WIDTH;
extern const size_t SCREEN_HEIGHT;

// Initialize framebuffer using the Limine-provided framebuffer_request.
// Must be called once after boot (before drawing).
void fb_init(void);

// Clear screen with 0x00RRGGBB color (assumes 32bpp XRGB8888).
void fb_clear(uint32_t color);

void fb_put_char_cursor(char c, uint32_t color);

void fb_draw_char(size_t x, size_t y, char ch, uint32_t color);

// Put a pixel at (x,y). No bounds-check side effects (safe to call, will clip).
void fb_put_pixel(size_t x, size_t y, uint32_t color);

// Draw a null-terminated ASCII string at (x,y).
// Each glyph is 8x8, fixed spacing (8px).
// Accepted characters are simple ASCII (fallback to space for unknown).
void fb_draw_string(size_t x, size_t y, const char* s);

#endif // FRAMEBUFFER_H
