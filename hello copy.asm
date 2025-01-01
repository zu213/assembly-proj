section .data
    message db 'Hello, World!', 0      ; Null-terminated string

section .text
    global _main                       ; Entry point for GCC
    extern _printf                      ; Declare external `printf`

_main:                                 ; Start of the program
    push message                       ; Push the message address onto the stack
    call _printf                        ; Call the `printf` function
    add esp, 4                         ; Clean up the stack (cdecl)
    ret                                ; Return to exit