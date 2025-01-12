

; Set video mode to 320x200 256 colors (Mode 13h)

org 0x100          ; Origin point for the program (COM file)

extern Sleep  

section .bss
    col resb 1   

start:
    ; Set video mode 13h (320x200, 256 colors)
    mov ah, 0x00       
    mov al, 0x13        
    int 0x10

    mov bx, 10 ; bx used for random number
    mov si, 10
    mov cx, 1000 ; cx used for loop

draw_pixel:
    ; Draw a white pixel at coordinates (100, 100)
    call random_number
    
    mov ax, 0xA000      ; VGA graphics memory segment
    mov es, ax          ; Set ES to VGA graphics memory segment
    mov di, bx      ; Pixel offset: 100 (x) + 100 * 320 (y) = 6400
    mov al, 0x0F        ; Color value for white (color 15)
    mov [es:di], al     ; Store color value at pixel position

    loop draw_pixel

    mov cx, 1000

animate:
    mov bx, 0
    mov eax, 1000      ; 1000 milliseconds = 1 second
    call Sleep   
change_pixel:
    inc byte [col]      ; Increment column by 1
    add bx, 1
    mov ax, 0xA000      ; VGA graphics memory segment
    mov es, ax          ; Set ES to VGA graphics memory segment
    mov di, bx      ; Pixel offset: 100 (x) + 100 * 320 (y) = 6400
    mov al, [es:di]        ; Color value for white (color 15)
    cmp al, 0x0F
    je change_to_black

    cmp al, 0x00
    je change_to_white  
    ; Check if we've printed all 80 columns (end of row)
    cmp byte [col], 6000  ; Column counter reaches 81 (end of 80 columns)

    jl inner_loop  

    loop animate


    ; Wait for any key to exit
    mov ah, 0x00        ; BIOS interrupt for keyboard input
    int 0x16            ; Wait for key press

    ; Return to text mode (mode 3)
    mov ah, 0x00        ; BIOS interrupt function to set video mode
    mov al, 0x03        ; Mode 3 (80x25 text mode)
    int 0x10            ; Call BIOS interrupt

    ; Exit the program
    mov ah, 0x4C        ; Exit program interrupt
    int 0x21            ; Call DOS interrupt to exit

random_number:
    imul bx, 13
    add bx, 15
    ret

change_to_black:
    mov al, 0x00        ; Set the color to black (0x00)
    mov [es:di], al

change_to_white:
    mov al, 0x0F        ; Set the color to black (0x00)
    mov [es:di], al
