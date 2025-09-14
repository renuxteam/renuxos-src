// Header guard to prevent multiple inclusions
#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdint.h>  // For fixed-width integer types
#include <stddef.h>  // For size_t and other standard definitions

// Initializes the console
void console_init(void);

// Writes a single character to the console
void console_putchar(char c);

// Writes a string to the console
void console_write(const char* str);

// Clears the console screen
void console_clear(void);

// Sets the text color
void console_set_text_color(uint32_t color);

// Sets the background color
void console_set_background_color(uint32_t color);

// Prints a string to the console (alternative function)
void print(const char* str);

// Prints a string followed by a newline to the console
void println(const char* str);

// Puts a character to the console (alternative function)
void put_char(char c);

#endif // CONSOLE_H