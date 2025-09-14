#ifndef KSTRING_H
#define KSTRING_H

int strlen(const char* str);
int strcmp(const char* str1, const char* str2);
int strncmp(const char* str1, const char* str2, int n);
void strcpy(char* dest, const char* src);
void reverse(char* str);
void itoa(int num, char* str, int base);

#endif