section .data
    message db 'Hello, World!', 0      ;

section .text
    global _main                       ;
    extern _printf                      ;

_main:                                 ;
    push message                       ;
    call _printf                        ;
    add esp, 4                         ;
    ret                                ;