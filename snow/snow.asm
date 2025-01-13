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
    ; Draw initial pixels in loop
    call random_number
    
    mov ax, 0xA000
    mov es, ax
    mov di, bx
    mov al, 0x0F
    mov [es:di], al

    loop draw_pixel

    ; setup duration for animate is cx
    mov cx, 30
    mov dx, 0

animate:
    mov ebx, 64000
    ;call delay ; dont need delay cause its already slow :0

change_pixel: ; iterate through the pixels editing them
  
    sub ebx, 1
    mov ax, 0xA000
    mov es, ax
    mov di, bx

    ; if we find a white pixel change it to black
    mov al, [es:di]    
    cmp al, 0x0F
    je change_to_black

check_count:
    ; end of inner loop
    cmp ebx, 0
    jg change_pixel 

    ; once we reach top paint new row of pixels  for new snow
    mov bx, 10 ; set this for number of new snows per row
    call paint_new_pixel
    ; end of outer loop
    loop animate

    ; Return to text mode (mode 3)
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; Exit the program
    mov ah, 0x4C
    int 0x21

; jumping functions

change_to_black:
    mov al, 0x00        ; Set the color to black (0x00)
    mov [es:di], al
    add di, 319
    test cl, 1
    jz skip_bonus_add

    add di, 2

skip_bonus_add:
    mov al, 0x0F 
    mov [es:di], al
    sub di, 321

    jmp check_count

;delay:
;    mov bx, 0x000F 
;delay_loop:
;    dec bx       
;    jnz delay_loop
;    ret

; callable functions

random_number:
    imul bx, 13
    add bx, 15
    ret

paint_new_pixel: ; paint the new row of pixels
    
    mov ax, 0xA000
    mov es, ax     
    add dx, 149

    cmp dx, 321
    jl print_colour ; skip minus if we are less than 320

    sub dx, 320

print_colour:
    mov di, dx

    mov al, 0x0F
    mov [es:di], al

    sub bx, 1
    cmp bx, 0
    jg paint_new_pixel ;loop until bx is 0

    ret
