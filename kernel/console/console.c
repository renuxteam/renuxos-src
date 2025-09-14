#include "./include/console.h"
#include "../../drivers/video/include/framebuffer.h"
#include "../../drivers/video/include/color.h"
#include "../../drivers/video/include/video.h"
#include <stdbool.h>


extern uint8_t* fb_addr;          
extern size_t fb_width;           
extern size_t fb_height;          
extern size_t fb_pitch;           
extern size_t fb_bpp;             
extern size_t fb_bytes_per_pixel;  
extern size_t cursor_x;
extern size_t cursor_y;
extern const size_t CHAR_WIDTH;
extern const size_t CHAR_HEIGHT;
extern const size_t SCREEN_WIDTH;
extern const size_t SCREEN_HEIGHT;


// Estado do console
static size_t console_cursor_x = 0;
static size_t console_cursor_y = 0;
static uint32_t text_color = COLOR_WHITE;
static uint32_t bg_color = COLOR_BLACK;
static bool console_initialized = false;

// Dimensões do console em caracteres
static size_t console_cols = 0;
static size_t console_rows = 0;

void console_init(void) {
    if (console_initialized) return;
    
    // Inicializa o framebuffer se ainda não foi
    if (!fb_addr) {
        fb_init();
    }
    
    // Calcula dimensões do console em caracteres
    console_cols = fb_width / CHAR_WIDTH;
    console_rows = fb_height / CHAR_HEIGHT;
    
    // Limpa a tela
    console_clear();
    
    console_initialized = true;
}

void console_set_text_color(uint32_t color) {
    text_color = color;
}

void console_set_background_color(uint32_t color) {
    bg_color = color;
}

void console_clear(void) {
    fb_clear(bg_color);
    console_cursor_x = 0;
    console_cursor_y = 0;
}

void console_scroll(void) {
    // Calcula quantos pixels precisam ser rolados
    size_t scroll_pixels = CHAR_HEIGHT;
    
    // Move todas as linhas para cima
    for (size_t y = scroll_pixels; y < fb_height; y++) {
        for (size_t x = 0; x < fb_width; x++) {
            // Lê o pixel da linha abaixo
            uint8_t* src_pixel = fb_addr + y * fb_pitch + x * 4;
            uint32_t color = *((uint32_t*)src_pixel);
            
            // Escreve na linha acima
            uint8_t* dst_pixel = fb_addr + (y - scroll_pixels) * fb_pitch + x * 4;
            *((uint32_t*)dst_pixel) = color;
        }
    }
    
    // Limpa a última linha
    for (size_t y = fb_height - scroll_pixels; y < fb_height; y++) {
        for (size_t x = 0; x < fb_width; x++) {
            fb_put_pixel(x, y, bg_color);
        }
    }
    
    // Ajusta a posição do cursor
    console_cursor_y -= 1;
}

void console_putchar(char c) {
    if (!console_initialized) {
        console_init();
    }
    
    // Trata caracteres especiais
    switch (c) {
        case '\n': // Nova linha
            console_cursor_x = 0;
            console_cursor_y++;
            break;
            
        case '\r': // Retorno de carro
            console_cursor_x = 0;
            break;
            
        case '\t': // Tabulação
            console_cursor_x = (console_cursor_x + 8) & ~7;
            break;
            
        case '\b': // Backspace
            if (console_cursor_x > 0) {
                console_cursor_x--;
                // Apaga o caractere desenhando um espaço
                fb_draw_char(console_cursor_x * CHAR_WIDTH, 
                            console_cursor_y * CHAR_HEIGHT, 
                            ' ', 
                            bg_color);
            }
            break;
            
        default: // Caracteres imprimíveis
            if (c >= ' ') {
                fb_draw_char(console_cursor_x * CHAR_WIDTH, 
                            console_cursor_y * CHAR_HEIGHT, 
                            c, 
                            text_color);
                console_cursor_x++;
            }
            break;
    }
    
    // Quebra de linha se necessário
    if (console_cursor_x >= console_cols) {
        console_cursor_x = 0;
        console_cursor_y++;
    }
    
    // Scroll se necessário
    if (console_cursor_y >= console_rows) {
        console_scroll();
    }
}

void console_write(const char* str) {
    if (!str) return;
    
    for (size_t i = 0; str[i] != '\0'; i++) {
        console_putchar(str[i]);
    }
}
