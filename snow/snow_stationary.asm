org 0x100

start:
    ; Set video mode 13h (320x200, 256 colors)
    mov ah, 0x00       
    mov al, 0x13        
    int 0x10

    mov bx, 10 ; bx used for random number
    mov si, 10
    mov cx, 1000 ; cx used for loop

draw_pixel:
    call random_number
    
    mov ax, 0xA000
    mov es, ax
    mov di, bx
    mov al, 0x0F
    mov [es:di], al

    loop draw_pixel


    ; Wait for any key to exit
    mov ah, 0x00
    int 0x16

    ; Return to text mode (mode 3)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ;exit the program
    mov ah, 0x4C
    int 0x21

random_number:
    imul bx, 13
    add bx, 15
    ret