// vga.cpp
#include "vga.hpp"

VGA::VGA()
    : buffer(reinterpret_cast<volatile uint16_t*>(0xB8000)),
      color(static_cast<uint8_t>(Color::LightGray) | (static_cast<uint8_t>(Color::Black) << 4)),
      row(0), column(0)
{
    clear();
}

uint16_t VGA::vgaEntry(char c, uint8_t color) const {
    return static_cast<uint16_t>(color) << 8 | static_cast<uint16_t>(c);
}

void VGA::clear() {
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            buffer[y * WIDTH + x] = vgaEntry(' ', color);
        }
    }   
    row = column = 0;
}

void VGA::setColor(Color fg, Color bg) {
    color = static_cast<uint8_t>(fg) | (static_cast<uint8_t>(bg) << 4);
}

void VGA::putChar(char c) {
    if (c == '\n') {
        column = 0;
        row++;
    } else {
        buffer[row * WIDTH + column] = vgaEntry(c, color);
        column++;
        if (column >= WIDTH) {
            column = 0;
            row++;
        }
    }

    if (row >= HEIGHT) {
        // Scroll
        for (int y = 1; y < HEIGHT; y++) {
            for (int x = 0; x < WIDTH; x++) {
                buffer[(y - 1) * WIDTH + x] = buffer[y * WIDTH + x];
            }
        }
        for (int x = 0; x < WIDTH; x++) {
            buffer[(HEIGHT - 1) * WIDTH + x] = vgaEntry(' ', color);
        }
        row = HEIGHT - 1;
    }
}

void VGA::print(const char* str) {
    while (*str) {
        putChar(*str++);
    }
}

void VGA::println(const char* str) {
    while (*str) {
        putChar(*str++);
    }
    putChar('\n');
}

void VGA::fill(char c, Color fg, Color bg) {
    uint8_t col = static_cast<uint8_t>(fg) | (static_cast<uint8_t>(bg) << 4);
    for (int y = 0; y < HEIGHT; y++) {
        for (int x = 0; x < WIDTH; x++) {
            buffer[y * WIDTH + x] = vgaEntry(c, col);
        }
    }
    row = column = 0;
    color = col;
}
