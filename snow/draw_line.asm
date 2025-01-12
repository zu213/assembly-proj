

org 0x100          ; Origin point for the program (COM file)

start:
    ; Set video mode 13h (320x200, 256 colors)
    mov ah, 0x00        ; BIOS interrupt function to set video mode
    mov al, 0x13        ; Mode 13h (320x200, 256 colors)
    int 0x10            ; Call BIOS interrupt
    mov bx, 0x6400
    mov cx, 100 

draw_pixel:

    add bx, 1
    mov ax, 0xA000      
    mov es, ax          
    mov di, bx      
    mov al, 0x0F     
    mov [es:di], al    

    loop draw_pixel

    mov ah, 0x00        
    int 0x16           

    mov ah, 0x00        
    mov al, 0x03      
    int 0x10           

    mov ah, 0x4C       
    int 0x21           