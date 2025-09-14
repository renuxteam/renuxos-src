#ifndef COLOR_H
#define COLOR_H

#include <stdint.h>

/**
 * @file color.h
 * @brief Predefined color constants in 0x00RRGGBB format
 * 
 * This header provides commonly used color constants
 * for framebuffer operations. All colors are in 0x00RRGGBB format
 * where:
 * - RR: 8-bit red component (0x00-0xFF)
 * - GG: 8-bit green component (0x00-0xFF)  
 * - BB: 8-bit blue component (0x00-0xFF)
 */

// Predefined color constants
#define COLOR_BLACK      0x00000000  ///< Black: RGB(0, 0, 0)
#define COLOR_WHITE      0x00FFFFFF  ///< White: RGB(255, 255, 255)
#define COLOR_RED        0x00FF0000  ///< Red: RGB(255, 0, 0)
#define COLOR_GREEN      0x0000FF00  ///< Green: RGB(0, 255, 0)
#define COLOR_BLUE       0x000000FF  ///< Blue: RGB(0, 0, 255)
#define COLOR_YELLOW     0x00FFFF00  ///< Yellow: RGB(255, 255, 0)
#define COLOR_MAGENTA    0x00FF00FF  ///< Magenta: RGB(255, 0, 255)
#define COLOR_CYAN       0x0000FFFF  ///< Cyan: RGB(0, 255, 255)
#define COLOR_GRAY       0x00808080  ///< Gray: RGB(128, 128, 128)
#define COLOR_LIGHT_GRAY 0x00C0C0C0  ///< Light Gray: RGB(192, 192, 192)
#define COLOR_DARK_GRAY  0x00404040  ///< Dark Gray: RGB(64, 64, 64)
#define COLOR_ORANGE     0x00FFA500  ///< Orange: RGB(255, 165, 0)
#define COLOR_PURPLE     0x00800080  ///< Purple: RGB(128, 0, 128)
#define COLOR_BROWN      0x00A52A2A  ///< Brown: RGB(165, 42, 42)
#define COLOR_PINK       0x00FFC0CB  ///< Pink: RGB(255, 192, 203)

#endif // COLOR_H
