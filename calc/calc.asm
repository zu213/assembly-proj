org 100h

section .data
    buffer db 10 dup(0) 
    prompt1 db 'Enter first number: $', 0
    prompt2 db 'Enter second number: $', 0
    result_msg db 'The sum is: $', 0
    newline db 0x0A, 0x0D, '$'  ; Newline characters for formatting

section .bss
    num1 resb 1  ; Reserve space for first input number
    num2 resb 1  ; Reserve space for second input number
    result resb 1  ; Reserve space for result (store sum as a single byte)

section .text
    global _start

_start:
    ; Print prompt1
    mov ah, 09h
    lea dx, [prompt1]
    int 21h

    ; Read first number
    mov ah, 01h  ; Function to read a character
    int 21h      ; Read character into AL
    sub al, '0'  ; Convert ASCII to numeric (0-9)
    mov [num1], al  ; Save the first number

    ; Print prompt2
    mov ah, 09h
    lea dx, [prompt2]
    int 21h

    ; Read second number
    mov ah, 01h  ; Function to read a character
    int 21h      ; Read character into AL
    sub al, '0'  ; Convert ASCII to numeric (0-9)
    mov [num2], al  ; Save the second number

    ; Add the numbers
    mov al, [num1]    ; Load first number into AL
    add al, [num2]    ; Add second number to AL
    mov [result], al  ; Store the result

    ; Print result message
    mov ah, 09h
    lea dx, [result_msg]
    int 21h

    jmp print_number

print_number:
    xor ax, ax
    mov al, [result]
    ;mov eax, result
    mov ebx, 10            ; Base 10
    lea di, [buffer + 10]  ; Point DI to the end of the buffer
    xor edx, edx           ; Clear edx (will hold remainder)
    ;mov eax, 12
    ; Null-terminate the buffer
    mov byte [di], '$'

    .convert_loop:
        dec di                 ; Move buffer pointer backwards
        xor edx, edx           ; Clear edx before division
        div ebx                ; Divide eax by 10, quotient in eax, remainder in dl
        add dl, '0'            ; Convert remainder (digit) to ASCII
        mov byte [di], dl           ; Store the ASCII character in the buffer

        test eax, eax          ; Check if quotient is zero
        jnz .convert_loop      ; If not, continue dividing

    ; Print the number string
    mov ah, 09h
    lea dx, [di]       ; Load address of the number string (skip null terminator)
    int 21h

    mov ah, 09h
    lea dx, [newline]
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h