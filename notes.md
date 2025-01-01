
# Notes

- Print world code can be found in hello.asm

- Use nasm to make a win32 obj files like this `nasm -f win32 hello.asm -o hello.obj`

- Use gcc to compile it to an.exe like this `gcc hello.obj -o hello.exe -lkernel32 -luser32 -lmsvcrt` the bonus params are for libraries.

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