org 100h

section .data
    buffer db 10 dup(0) ; buffer for placing output into
    prompt1 db 'Enter first number: $', 0
    prompt2 db 'Enter second number: $', 0
    prompt3 db 'Enter operation: $', 0
    result_msg db 'The answer is: $', 0
    newline db 0x0A, 0x0D, '$'  ; Newline characters for formatting

section .bss
    num1 resb 1
    num2 resb 1
    result resb 1

section .text
    global _start

_start:
    mov ah, 09h
    lea dx, [prompt1]
    int 21h

    ; Read first number
    mov ah, 01h
    int 21h
    sub al, '0'
    mov [num1], al

    ;print new line
    mov ah, 09h       
    lea dx, [newline]
    int 21h
    ; print prompt 2
    mov ah, 09h
    lea dx, [prompt2]
    int 21h

    ; Read second number
    mov ah, 01h 
    int 21h     
    sub al, '0'  
    mov [num2], al 

    ;print new line
    mov ah, 09h       
    lea dx, [newline]
    int 21h

    mov ah, 09h
    lea dx, [prompt3]
    int 21h

    ; Read calc char
    mov ah, 01h
    int 21h

    ;print new line
    mov ah, 09h       
    lea dx, [newline]
    int 21h

    ; check whihc operator is used and jump accordingly
    cmp al, 0x2B
    je add_number

    cmp al, 0x2A
    je mult_number

    cmp al, 0x2D
    je sub_number

    cmp al, 0x2F
    je div_number

    mov ah, 4Ch
    mov al, 1
    int 21h

add_number:
    mov al, [num1]
    add al, [num2]
    mov [result], al

    jmp print_number

mult_number:
    xor ax, ax
    mov al, [num1]
    imul ax, [num2]
    mov [result], al
    jmp print_number


sub_number:
    mov al, [num1]
    sub al, [num2]
    mov [result], al

    jmp print_number


div_number:
    xor ax, ax
    mov al, [num1]
    xor bx, bx
    mov bl, [num2]
    xor dx, dx
    div bl
    mov [result], al

    jmp print_number

print_number:
    ; Print result message
    mov ah, 09h
    lea dx, [result_msg]
    int 21h

    xor ax, ax
    mov al, [result]
    ;mov eax, result
    xor ebx, ebx
    mov ebx, 10
    lea di, [buffer + 10]
    xor edx, edx
    ; Null-terminate the buffer
    mov byte [di], '$'

    .convert_loop: ; convert number to list of chars
        dec di
        xor edx, edx
        div ebx
        add dl, '0'
        mov byte [di], dl

        test eax, eax          ; Check if quotient is zero
        jnz .convert_loop

    ; Print the number string
    mov ah, 09h
    lea dx, [di]
    int 21h

    mov ah, 09h
    lea dx, [newline]
    int 21h

    ; Exit program
    mov ah, 4Ch
    mov al, 0
    int 21h