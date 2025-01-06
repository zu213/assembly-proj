org 100h

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
    ; Print the message to the screen
    mov ah, 9       ; AH=9 means "print string" function
    mov dx, prompt   ; Load the offset address of 'hello' into DX
    int 21h         ; Call the DOS interrupt 21h to execute the function

    call read_input
    ret
    ; Exit the program
    mov ah, 4Ch     ; AH=4Ch means "exit" function
    xor al, al      ; Set AL to 0 (return code)
    int 21h         ; Call the DOS interrupt 21h to exit the program

read_input:
    mov ah, 01h     ; load up read character function     
    int 21h         ; execute
    mov [input], al  ; saved read to input


    ; Check if the input is Enter (0x0D), if so, stop reading
    cmp al, 0x0D         ; Compare input character with Enter (0x0D)
    je done_input        ; If Enter, jump to done_input

    ; Check if the input is a digit ('0' to '9')
    sub al, '0'          ; Convert ASCII to numeric value (0-9)
    jb invalid_input_msg ; If the character is not a digit, jump to error message

    ; Multiply result by 10 (using proper multiplication)

    mov eax, [result]   ; Load current result into eax
    shl eax, 1          ; Multiply result by 2 (eax * 2)
    shl eax, 2          ; Multiply result by 4 (eax * 4), now eax = eax * 10
    movzx eax, al       ; Zero-extend al (8-bit) to eax (32-bit)
    add eax, [result]   ; Add the new value (al) to eax
    mov [result], eax   ; Store updated result

    ;mov [result], eax    ; Store the updated result

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
        mov ecx, buffer + 5
        dec ecx                  ; Move buffer pointer backwards
        mov byte [ecx], 'a'  
    ; Convert the number in eax to a string
    mov ecx, buffer + 10     ; Point ECX to the end of the buffer (we'll fill the buffer backwards)
    mov byte [ecx], '$'     ; Null-terminate the string

    ; Save the divisor in another register (ebx)
    mov ebx, 10              ; Divisor (base 10)

    convert_loop: 
        dec ecx
        xor edx, edx             ; Clear edx (remainder)
        div ebx                  ; Divide eax by 10, result in eax, remainder in edx
        add dl, '0'              ; Convert remainder to ASCII
        mov byte [ecx], dl            ; Store the ASCII character in the buffer

        ; If eax is 0, we've finished converting the number
        test eax, eax
        jnz convert_loop         ; If eax != 0, continue the loop

    ; Print the number string
    mov ah, 09h              ; DOS function to print string
    lea dx, [ecx]            ; Load address of the string into dx
    int 21h                  ; Call interrupt 21h to print the string

    ret
