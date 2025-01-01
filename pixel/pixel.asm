; Example graphic assembly code program made by ChatGPT

; Set video mode to 320x200 256 colors (Mode 13h)
; Draw a single white pixel at coordinates (100, 100)

org 0x100          ; Origin point for the program (COM file)

start:
    ; Set video mode 13h (320x200, 256 colors)
    mov ah, 0x00        ; BIOS interrupt function to set video mode
    mov al, 0x13        ; Mode 13h (320x200, 256 colors)
    int 0x10            ; Call BIOS interrupt

    ; Draw a white pixel at coordinates (100, 100)
    mov ax, 0xA000      ; VGA graphics memory segment
    mov es, ax          ; Set ES to VGA graphics memory segment
    mov di, 0x6400      ; Pixel offset: 100 (x) + 100 * 320 (y) = 6400
    mov al, 0x0F        ; Color value for white (color 15)
    mov [es:di], al     ; Store color value at pixel position

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