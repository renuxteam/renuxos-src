// Include necessary headers for string operations, console output, and shell functions
#include "../../libc/kstring/include/kstring.h"  // Custom kernel string library
#include "../../kernel/console/include/console.h" // Console I/O functions
#include "./include/shell.h"                      // Shell-specific function declarations

// Buffer to store user input from the command line
static char input_buffer[256];

// Function to read a line of input (currently incomplete)
void read_line(char* buffer, int max_length) {
    int i = 0;
    char c;

    // Loop until we reach the maximum allowed length minus one (for null terminator)
    while (i < max_length - 1) {
        // TODO: Read character from keyboard input here
        // Example: c = get_char();
        // if (c == '\n') break;
        // buffer[i++] = c;
        break; // Placeholder - currently does nothing
    }

    // Null-terminate the string
    buffer[i] = '\0';
}

// Help command implementation
void shell_help(void) {
    println("Renux Shell help");             // Print title
    println("help - print help");            // List available command
}

// Echo command implementation
void shell_echo(char* args) {
    // If no arguments provided
    if (args[0] == '\0') {
        println("Use: echo <text>");         // Show usage message
        return;
    }
    print(args);                             // Print the given text
    put_char('\n');                          // Add newline at the end
}

// Version command implementation
void shell_version(void) {
    println("RenuxShell aurora v0.1");       // Display shell version
}

// Main function to parse and execute commands
void execute_command(char* command) {
    // Remove leading spaces
    while (*command == ' ') command++;

    // If command is empty, do nothing
    if (*command == '\0') return;

    // Handle 'help' command
    if (strcmp(command, "help") == 0) {
        shell_help();
        return;
    }

    // Handle 'clear' command
    if (strcmp(command, "clear") == 0) {
        console_clear();                     // Clear screen
        return;
    }

    // Handle 'version' command
    if (strcmp(command, "version") == 0) {
        shell_version();
        return;
    }

    // Handle 'exit' command
    if (strcmp(command, "exit") == 0) {
        print("Exiting shell...\n");         // Notify exit
        return;
    }

    // Handle 'echo' command with arguments
    if (strncmp(command, "echo", 4) == 0) {
        if (command[4] == ' ') {
            shell_echo(command + 5);         // Pass the text after "echo "
        } else {
            print("Usage: echo <text>\n");   // Show correct usage
        }
        return;
    }

    // Unknown command
    print("Command not found: ");
    print(command);
    print("\nType 'help' to see available commands.\n");
}

// Main shell loop
void shell_loop(void) {
    char command[256];                       // Buffer to hold current command

    console_clear();                         // Clear console before starting
    print("Welcome to the Kernel Shell!\n");
    print("Type 'help' to see available commands.\n\n");

    while (1) {
        print("$ ");                         // Display prompt

        // In a real kernel, you would implement:
        // read_line(command, sizeof(command));

        // For demonstration purposes, simulate some commands
        // You need to implement a keyboard driver to actually read input

        // Example usage (uncomment when keyboard driver is ready):
        /*
        read_line(command, sizeof(command));
        if (strcmp(command, "exit") == 0) {
            break;
        }
        execute_command(command);
        */

        // Test case simulation
        static int test_counter = 0;
        switch (test_counter) {
            case 0:
                strcpy(command, "help");
                break;
            case 1:
                strcpy(command, "echo Hello World!");
                break;
            case 2:
                strcpy(command, "version");
                break;
            case 3:
                strcpy(command, "clear");
                break;
            default:
                strcpy(command, "exit");
                break;
        }

        // Exit if command is 'exit'
        if (strcmp(command, "exit") == 0) {
            break;
        }

        execute_command(command);            // Execute the simulated command
        test_counter++;

        // In a real kernel, this would be an infinite loop waiting for input
        if (test_counter > 4) break;
    }

    print("Shell terminated.\n");
}