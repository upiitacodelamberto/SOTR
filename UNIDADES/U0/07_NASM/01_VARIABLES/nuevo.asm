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



;section .text          ;estas primeras dos lineas no son necesarias.
;   global _start       ;must be declared for linker (gcc)
section .data
global variable        ;aqui declaro el char variable, que en start.c
variable DB 'A'        ;/*el caracter 'A'*/  aparece: extern char variable;  
