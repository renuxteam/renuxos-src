// vga.hpp
#pragma once
#include <stdint.h>

class VGA {
public:
    enum class Color : uint8_t {
        Black = 0,
        Blue = 1,
        Green = 2,
        Cyan = 3,
        Red = 4,
        Magenta = 5,
        Brown = 6,
        LightGray = 7,
        DarkGray = 8,
        LightBlue = 9,
        LightGreen = 10,
        LightCyan = 11,
        LightRed = 12,
        Pink = 13,
        Yellow = 14,
        White = 15
    };

    static constexpr int WIDTH = 80;
    static constexpr int HEIGHT = 25;

    VGA(); // constructor

    void clear();
    void setColor(Color fg, Color bg);
    void putChar(char c);
    void print(const char* str);
    void println(const char* str);
    void fill(char c, Color fg, Color bg);

private:
    uint16_t vgaEntry(char c, uint8_t color) const;
    volatile uint16_t* const buffer;
    uint8_t color;
    int row;
    int column;
};
