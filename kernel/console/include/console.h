#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdint.h>
#include <stddef.h>

// Inicializa o console
void console_init(void);

// Escreve um caractere no console
void console_putchar(char c);

// Escreve uma string no console
void console_write(const char* str);

// Limpa a tela do console
void console_clear(void);

// Define a cor do texto
void console_set_text_color(uint32_t color);

// Define a cor do fundo
void console_set_background_color(uint32_t color);

#endif // CONSOLE_H