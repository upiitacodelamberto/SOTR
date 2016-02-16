;nasm -f elf64 datoinicializado.asm
;objdump -Sr datoinicializado.o
;ld -o datoinicializado datoinicializado.o
;chmod u+x datoinicializado
;./datoinicializado


;choice		DB	'y'
;number		DW	12345
;neg_number	DW	-12345
;big_number	DQ	123456789
;real_number1	DD	1.234
;real_number2	DQ	123.456

section .text
   global _start       ;must be declared for linker (gcc)

_start:                ;tell linker entry point
;   mov edx,1           ;message length
   mov edx,2           ;message length
   mov ecx,choice      ;message to write
   mov ebx,1           ;file descriptor (stdout)
   mov eax,4           ;system call number (sys_write)
   int 0x80            ;call kernel

   mov eax,1           ;system call (sys_exit)
   int 0x80            ;call kernel

section .data
;choice DB 'y'
choice DB "y",10       ;cr=10
