#include "./include/console.h"
#include "../../drivers/video/include/framebuffer.h"
#include "../../drivers/video/include/color.h"
#include <stdbool.h>

// External framebuffer parameters provided by the video driver
extern uint8_t* fb_addr;          // Pointer to the start of the framebuffer memory
extern size_t fb_width;           // Framebuffer width in pixels
extern size_t fb_height;          // Framebuffer height in pixels
extern size_t fb_pitch;           // Number of bytes per framebuffer row (stride)
extern size_t fb_bpp;             // Bits per pixel
extern size_t fb_bytes_per_pixel; // Bytes per pixel (usually fb_bpp / 8)
extern size_t cursor_x;           // (Optional) Global cursor X in pixels
extern size_t cursor_y;           // (Optional) Global cursor Y in pixels
extern const size_t CHAR_WIDTH;   // Width of one glyph in pixels
extern const size_t CHAR_HEIGHT;  // Height of one glyph in pixels
extern const size_t SCREEN_WIDTH; // Screen width in pixels (alias for fb_width)
extern const size_t SCREEN_HEIGHT;// Screen height in pixels (alias for fb_height)

// Console state (local to this translation unit)
static size_t console_cursor_x = 0; // Cursor column (in characters)
static size_t console_cursor_y = 0; // Cursor row (in characters)
static uint32_t text_color = COLOR_WHITE; // Foreground/text color
static uint32_t bg_color = COLOR_BLACK;   // Background color
static bool console_initialized = false;  // Guard to avoid re-initialization

// Console dimensions in characters (calculated at init)
static size_t console_cols = 0; // Number of character columns
static size_t console_rows = 0; // Number of character rows

/**
 * Initialize the console subsystem.
 * Ensures the framebuffer is ready, computes column/row counts and clears the screen.
 */
void console_init(void) {
    if (console_initialized) return; // Already initialized
    
    // Initialize the framebuffer if driver hasn't done so yet
    if (!fb_addr) {
        fb_init(); // This should populate fb_addr, fb_width, fb_height, etc.
    }
    
    // Calculate console size in characters based on glyph dimensions
    // This uses integer division: any leftover pixels are unused.
    console_cols = fb_width / CHAR_WIDTH;
    console_rows = fb_height / CHAR_HEIGHT;
    
    // Clear the entire screen to the background color and reset cursor
    console_clear();
    
    console_initialized = true;
}

/**
 * Set the text (foreground) color for subsequent characters.
 */
void console_set_text_color(uint32_t color) {
    text_color = color;
}

/**
 * Set the console background color.
 */
void console_set_background_color(uint32_t color) {
    bg_color = color;
}

/**
 * Clear the console: fill the framebuffer with bg_color and reset cursor to origin.
 */
void console_clear(void) {
    fb_clear(bg_color); // Clear the raw framebuffer via the driver's helper
    console_cursor_x = 0;
    console_cursor_y = 0;
}

/**
 * Scroll the console up by one character row.
 * This moves pixel rows up by CHAR_HEIGHT and clears the bottom row.
 * Notes:
 *  - The implementation assumes 32-bit color (4 bytes per pixel) where it
 *    directly uses 4 when computing per-pixel offsets. If fb_bytes_per_pixel
 *    or fb_bpp differs, this code must be adapted.
 *  - Uses fb_pitch for the row stride in bytes.
 */
void console_scroll(void) {
    // Number of pixel rows to move up (one character height)
    size_t scroll_pixels = CHAR_HEIGHT;
    
    // Move each pixel row up by copying memory from the row below.
    // We iterate y from scroll_pixels..fb_height-1 and copy that row to y-scroll_pixels.
    for (size_t y = scroll_pixels; y < fb_height; y++) {
        for (size_t x = 0; x < fb_width; x++) {
            // Calculate source pixel address in framebuffer
            // Assumes 4 bytes per pixel in the cast below. If bytes-per-pixel varies,
            // replace the constant 4 with fb_bytes_per_pixel.
            uint8_t* src_pixel = fb_addr + y * fb_pitch + x * 4;
            uint32_t color = *((uint32_t*)src_pixel);
            
            // Destination address (one character row higher)
            uint8_t* dst_pixel = fb_addr + (y - scroll_pixels) * fb_pitch + x * 4;
            *((uint32_t*)dst_pixel) = color; // Copy the pixel value
        }
    }
    
    // Clear the bottom scroll_pixels rows to the background color
    for (size_t y = fb_height - scroll_pixels; y < fb_height; y++) {
        for (size_t x = 0; x < fb_width; x++) {
            fb_put_pixel(x, y, bg_color); // Driver helper to set a single pixel
        }
    }
    
    // Move the console cursor up one text row since everything scrolled up
    if (console_cursor_y > 0) {
        console_cursor_y -= 1;
    } else {
        console_cursor_y = 0;
    }
}

/**
 * Put a single character to the console at the current cursor position.
 * Handles special characters like newline, carriage return, tab and backspace.
 */
void console_putchar(char c) {
    if (!console_initialized) {
        console_init(); // Ensure console is ready before printing
    }
    
    // Handle control characters
    switch (c) {
        case '\n': // New line: move to column 0 of next row
            console_cursor_x = 0;
            console_cursor_y++;
            break;
            
        case '\r': // Carriage return: move to column 0 on same row
            console_cursor_x = 0;
            break;
            
        case '\t': // Tab: move cursor to the next 8-column boundary
            // This implements a typical tab-stop behavior (8 columns)
            console_cursor_x = (console_cursor_x + 8) & ~7;
            break;
            
        case '\b': // Backspace: move one column left and erase the glyph
            if (console_cursor_x > 0) {
                console_cursor_x--;
                // Draw a space character using the background color to erase
                fb_draw_char(console_cursor_x * CHAR_WIDTH, 
                            console_cursor_y * CHAR_HEIGHT, 
                            ' ', 
                            bg_color);
            }
            break;
            
        default: // Printable characters
            if (c >= ' ') {
                // Draw the character glyph at the current cursor position
                fb_draw_char(console_cursor_x * CHAR_WIDTH, 
                            console_cursor_y * CHAR_HEIGHT, 
                            c, 
                            text_color);
                console_cursor_x++;
            }
            break;
    }
    
    // Wrap to next line if we exceeded the number of columns
    if (console_cursor_x >= console_cols) {
        console_cursor_x = 0;
        console_cursor_y++;
    }
    
    // Scroll the framebuffer if we exceeded the number of rows
    if (console_cursor_y >= console_rows) {
        console_scroll();
    }
}

/**
 * Write a null-terminated string to the console by outputting each character.
 */
void console_write(const char* str) {
    if (!str) return; // Guard against NULL pointers
    
    for (size_t i = 0; str[i] != '\0'; i++) {
        console_putchar(str[i]);
    }
}

// Convenience function aliases
void print(const char* str) {
    console_write(str);
}

void println(const char* str) {
    console_write(str);
    console_putchar('\n');
}

void put_char(char c) {
    console_putchar(c);
}