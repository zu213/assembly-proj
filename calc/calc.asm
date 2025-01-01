section .data
    prompt db 'Enter a number: $'
    newline db 0x0A, 0x0D, '$'  ; Newline characters for formatting
    invalid_input db 'Invalid input! Please enter a number.$', 0
    result_msg db 'You entered: $', 0

section .bss
    input resb 1        ; Reserve space for one character of input
    result resd 1       ; Reserve space for the result (32-bit number)
    digit resb 1        ; Temporary storage for the digit being read
    buffer resb 10      ; Reserve space for the result string (max 10 digits)

section .text
    global _start

_start:
    ; Initialize result to 0
    mov dword [result], 0

    ; Print the prompt message
    mov ah, 09h          ; DOS function to print a string
    mov dx, prompt       ; Load address of prompt
    int 21h              ; Call interrupt 21h (DOS function)

read_input:
    ; Read a character from input
    mov ah, 01h          ; DOS function to read a character from input
    int 21h              ; Call interrupt 21h (DOS function)
    mov [input], al      ; Store the character in input variable

    ; Check if the input is Enter (0x0D), if so, stop reading
    cmp al, 0x0D         ; Compare input character with Enter (0x0D)
    je done_input        ; If Enter, jump to done_input

    ; Check if the input is a digit ('0' to '9')
    sub al, '0'          ; Convert ASCII to numeric value (0-9)
    jb invalid_input_msg ; If the character is not a digit, jump to error message

    ; Multiply result by 10 (using proper multiplication)
    mov eax, [result]    ; Load current result into eax
    mov edx, eax         ; Copy eax to edx
    imul eax, edx, 10    ; Multiply result by 10 using edx
    add eax, al          ; Add the new digit to the result

    mov [result], eax    ; Store the updated result

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
    ; Convert the number in eax to a string
    mov ecx, buffer + 10 ; Point ECX to the end of the buffer (we'll fill the buffer backwards)
    mov byte [ecx], 0     ; Null-terminate the string

    convert_loop:
        dec ecx            ; Move buffer pointer backwards
        xor edx, edx       ; Clear edx (remainder)
        mov ecx, 10        ; Load the divisor into ecx
        div ecx            ; Divide eax by 10, result in eax, remainder in edx
        add dl, '0'        ; Convert remainder to ASCII
        mov [ecx], dl      ; Store the ASCII character in the buffer

        ; If eax is 0, we've finished converting the number
        test eax, eax
        jnz convert_loop

    ; Print the number string
    mov ah, 09h
    mov dx, ecx
    int 21h
    ret
