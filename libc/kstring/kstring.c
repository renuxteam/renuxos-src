// Include the header file for function declarations
#include "./include/kstring.h"

// Function to calculate the length of a string
int strlen(const char* str) {
    int len = 0;
    // Count characters until we reach the null terminator
    while (str[len]) len++;
    return len;
}

// Function to compare two strings
int strcmp(const char* str1, const char* str2) {
    // Continue comparing while characters are equal and not null
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    // Return the difference between the first differing characters
    // Cast to unsigned char to handle negative values correctly
    return *(unsigned char*)str1 - *(unsigned char*)str2;
}

// Function to compare first n characters of two strings
int strncmp(const char* str1, const char* str2, int n) {
    // Compare up to n characters
    for (int i = 0; i < n; i++) {
        // If characters differ, return their difference
        if (str1[i] != str2[i]) {
            return *(unsigned char*)&str1[i] - *(unsigned char*)&str2[i];
        }
        // If we reach end of string, they are equal up to this point
        if (str1[i] == '\0') {
            return 0;
        }
    }
    // All n characters were equal
    return 0;
}

// Function to copy source string to destination
void strcpy(char* dest, const char* src) {
    int i = 0;
    // Copy each character until we reach null terminator
    while (src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    // Add null terminator at the end
    dest[i] = '\0';
}

// Function to reverse a string in place
void reverse(char* str) {
    int len = strlen(str);
    // Swap characters from both ends moving toward the center
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
}

// Function to convert integer to string (itoa = integer to ascii)
void itoa(int num, char* str, int base) {
    int i = 0;
    int isNegative = 0;
    
    // Handle special case of zero
    if (num == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return;
    }
    
    // Handle negative numbers (only for base 10)
    if (num < 0 && base == 10) {
        isNegative = 1;
        num = -num;  // Make it positive for processing
    }
    
    // Convert number to string (in reverse order)
    while (num != 0) {
        int rem = num % base;
        // Convert remainder to character (0-9 or a-z for bases > 10)
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
        num = num / base;
    }
    
    // Add negative sign if needed
    if (isNegative) {
        str[i++] = '-';
    }
    
    // Null terminate the string
    str[i] = '\0';
    
    // Reverse the string to get correct order
    reverse(str);
}