;RESB	Reserve a Byte
;RESW	Reserve a Word
;RESD	Reserve a Doubleword
;RESQ	Reserve a Quadword
;REST	Reserve a Ten Bytes

;choice	  DB 	'Y' 		 ;ASCII of y = 79H
;number1	  DW 	12345 	 ;12345D = 3039H
;number2    DD  12345679  ;123456789D = 75BCD15H

;The assembler allocates contiguous memory for multiple variable definitions.
;
;Multiple Initializations
;The TIMES directive allows multiple initializations to the same value. For example, an array named marks ;of size 9 can be defined and initialized to zero using the following statement -
;
;marks  TIMES  9  DW  0
;The TIMES directive is useful in defining arrays and tables. The following program displays 9 asterisks ;on the screen -
section	.text
   global _start        ;must be declared for linker (ld)
	
_start:                 ;tell linker entry point
   mov	edx,9		;message length
   mov	ecx, stars	;message to write
   mov	ebx,1		;file descriptor (stdout)
   mov	eax,4		;system call number (sys_write)
   int	0x80		;call kernel

   mov	eax,1		;system call number (sys_exit)
   int	0x80		;call kernel

section	.data
stars   times 9 db '*'
:When the above code is compiled and executed, it produces the following result -
:
:*********