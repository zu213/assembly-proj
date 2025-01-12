

; Set video mode to 320x200 256 colors (Mode 13h)

org 0x100          ; Origin point for the program (COM file)

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