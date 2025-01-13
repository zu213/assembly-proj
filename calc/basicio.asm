org 100h

section .data
    prompt db 'Enter a number: $'
    newline db 0x0A, 0x0D, '$'  ; Newline characters for formatting
    invalid_input db 'Invalid input! Please enter a number.$', 0
    result_msg db 'You entered: $', 0

section .bss
    input resb 1
    result resd 1
    buffer resb 10

section .text
    global _start

_start:

    mov dword [result], 0
    mov ah, 9       ; AH=9 means "print string" function
    mov dx, prompt   ; Load the offset address of 'hello' into DX
    int 21h         ; Call the DOS interrupt 21h to execute the function
    mov ecx, buffer + 10     ; Point ECX to the end of the buffer (we'll fill the buffer backwards)
    mov byte [ecx], '$'

    xor ebx,ebx
    call read_input
    ret

read_input:
    mov ah, 01h         ; Load up read character function
    int 21h

    ; Check if the input is Enter (0x0D), if so, stop reading
    cmp al, 0x0D
    je done_input

    cmp al, '0'         ; Compare if AL >= '0' (ASCII value 0x30)
    jb invalid_input_msg
    cmp al, '9'         ; Compare if AL <= '9' (ASCII value 0x39)
    ja invalid_input_msg

    ; Convert the ASCII value to a numeric value (0-9)
    sub al, '0'         ; Convert ASCII '0'-'9' to numeric value 0-9
    mov [input], al

    ; Multiply result by 10
    mov eax, [result]
    imul eax, 10   ; eax = eax * 10

    ; Add the new digit (al) to the result
    xor edx, edx
    mov dl, [input]
    add eax, edx        ; Add the digit (al) to the result in eax
    mov [result], eax   ; Store updated result back into 'result'

    ; Loop back to read next input
    jmp read_input

done_input:
    ; Print a newline after input
    mov ah, 09h
    mov dx, newline
    int 21h

    ; Print the result message
    mov ah, 09h
    mov dx, result_msg
    int 21h

    ; Convert the number to a string and print it
    xor eax, eax
    mov eax, [result]    ; Load result into eax
    call print_number    ; Convert and print number as string

    ; Exit the program
    mov ah, 4Ch
    int 21h

invalid_input_msg:
    ; Print invalid input message if not a number
    mov ah, 09h
    mov dx, invalid_input
    int 21h
    jmp done_input

; Subroutine to convert the number in eax to a string and print it
print_number:
    mov ecx, buffer + 10
    mov byte [ecx], '$'     ; Null-terminate the string

    mov ebx, 10 ; divisor

    convert_loop:
        dec ecx
        xor edx, edx             ; Clear edx (remainder)
        div ebx
        add dl, '0'              ; Convert remainder to ASCII
        mov byte [ecx], dl            ; Store the ASCII character in the buffer

        ; If eax is 0, we've finished converting the number
        test eax, eax
        jnz convert_loop 

    ; Print the number string
    mov ah, 09h              ; DOS function to print string
    lea dx, [ecx]
    int 21h

    ret
