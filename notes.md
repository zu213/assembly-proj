
# Notes

### General script

- The data section is used for declaring initialized data or constants. This data does not change at runtime. 

- The bss section is used for declaring variables

- The text section is used for keeping the actual code

### hello world
- Print world code can be found in hello.asm

- Use nasm to make a win32 obj files like this `nasm -f win32 hello.asm -o hello.obj`

#### Linking with c, the with_c file uses printf wihich is external
- Use gcc to compile it to an.exe like this `gcc hello.obj -o hello.exe -lkernel32 -luser32 -lmsvcrt` the bonus params are for libraries.

#### Linking otherwise
- You can use the command `ld hello.o -o hello.exe` to compile otherwise, this can be run by typing .\hello afterwards.

### helper commands
 - You can dump object file with commadn obj `dump -d hello.obj`, for an output like the below 

```
hello.obj:     file format pe-i386

Disassembly of section .text:

00000000 <_main>:
   0:   68 00 00 00 00          push   $0x0
   5:   e8 00 00 00 00          call   a <_main+0xa>
   a:   83 c4 04                add    $0x4,%esp
   d:   c3                      ret
```

- You can inspect the symbol table with this command `objdump -t hello.obj` for an output like the below.

```
hello.obj:     file format pe-i386

SYMBOL TABLE:
[  0](sec -2)(fl 0x00)(ty   0)(scl 103) (nx 1) 0x00000000 hello.asm
File
[  2](sec  1)(fl 0x00)(ty   0)(scl   3) (nx 1) 0x00000000 .data
AUX scnlen 0xe nreloc 0 nlnno 0
[  4](sec  2)(fl 0x00)(ty   0)(scl   3) (nx 1) 0x00000000 .text
AUX scnlen 0xe nreloc 2 nlnno 0
[  6](sec -1)(fl 0x00)(ty   0)(scl   3) (nx 0) 0x00000000 .absolut
[  7](sec  1)(fl 0x00)(ty   0)(scl   3) (nx 0) 0x00000000 message
[  8](sec  0)(fl 0x00)(ty   0)(scl   2) (nx 0) 0x00000000 printf
[  9](sec  2)(fl 0x00)(ty   0)(scl   2) (nx 0) 0x00000000 _main
[ 10](sec -1)(fl 0x00)(ty   0)(scl   3) (nx 0) 0x00000001 @feat.00
```

- you can check function names with the command like `nm -g --defined-only C:/MinGW/lib/libmsvcrt.a | findstr printf`

```
00000000 I __imp__wprintf_s
00000000 T _wprintf_s
00000000 I __imp__wprintf
00000000 T _wprintf
00000000 I __imp__vwprintf_s
00000000 T _vwprintf_s
00000000 I __imp__vwprintf
00000000 T _vwprintf
00000000 I __imp__vswprintf_s
00000000 T _vswprintf_s
00000000 I __imp__vswprintf
00000000 T _vswprintf
00000000 I __imp__vsprintf_s
```

### Graphics with assembly

- Use `nasm -f bin pixel.asm -o pixel.com` to assemble the file as  graphic project and then run it in DOS emulator.
    - Dosbox is used by running dosbox.exe
    - Then running  `MOUNT C C:\Users\evilm\OneDrive\Documents\Work\me\assembly`
    - Then switch to c: by typing c:
    - Then you can run .com files by typing their name e.g. pixel

## Basic assembly commands list for memory

This website [here](https://hackaday.io/project/188193-assembly-language-for-ecm-16ttl-homebrew-cpu/log/213335-mnemonics-list) has more on it

- INC COUNT        ; Increment the memory variable COUNT

- MOV TOTAL, 48    ; Transfer the value 48 in the 
                 ; memory variable TOTAL
					  
- ADD AH, BH       ; Add the content of the 
                 ; BH register into the AH register
					  
- AND MASK1, 128   ; Perform AND operation on the 
                 ; variable MASK1 and 128
					  
- ADD MARKS, 10    ; Add 10 to the variable MARKS
- MOV AL, 10       ; Transfer the value 10 to the AL register