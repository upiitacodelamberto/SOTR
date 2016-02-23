;Supongase que hay que cargar con 0x00, 10 bytes de datos, 
;en una zona de la memoria llamada (BUFFER). Esto se logra 
;con una serie de 10 instrucciones STOSB o con una instruccion 
;STOSB con prefijo REP, si CX es 10 al inicio. Con el programa 
;siguiente se limpia la zona de memoria.

      ;inicializar a cero un bloque de memoria usando STOS

section .text             ;code section
      global main         ;make label available to linker

main:                 ;standar gcc entry point
      
      cld                 ;seleccionar autoincremento
;;      les EDI,BUFFER       ;obtiene direccion de BUFFER
;;      les BX,BUFFER
;      ;mov DI,BUFFER0
;;      mov AX,0xB800       ;direcciona el segmento B800
;;      mov ES,AX
      mov DI,0
      mov CX,10           ;cargar contador
      mov AL,0x0          ;poner 0 en AL
      rep stosb           ;poner diez 0's en BUFFER
    mov esp,kernel_stack+KERNEL_STACK_SIZE  ;point esp to the start of the 
                                            ;stack (end of memory area)
extern stosb_f        ;function defined in stosb.c
    push dword 10
    push dword 0xAA
    push dword BUFFER
;    call stosb_f
     

      mov ebx,0		; exit code, 0=normal
      mov eax,1		; exit command to kernel
      int 0x80		; interrupt 80 hex, call kernel


KERNEL_STACK_SIZE equ 4096  ;size of stack inbytes
BUFFER_SIZE equ 64
;section .data

section .bss
align 4                     ;align at 4 bytes 
;BUFFER: db "0123456789"   ;region de memoria de 10 bytes 
;BUFFER:   resq 16       ;reserve 64 bytes
BUFFER:   resb BUFFER_SIZE       ;reserve 64 bytes
kernel_stack:            ;label points to begining of memory 
    resb KERNEL_STACK_SIZE  ;reserve stack for the kernel
;BUFFER0:  db 0x20
;BUFFER1:  db 0x20
;BUFFER2:  db 0x20
;BUFFER3:  db 0x20
;BUFFER4:  db 0x20
;BUFFER5:  db 0x20
;BUFFER6:  db 0x20
;BUFFER7:  db 0x20
;BUFFER8:  db 0x20
;BUFFER9:  db 0x20
;BUFFERA:  db 0x20
;BUFFERB:  db 0x20
;BUFFERC:  db 0x20
;BUFFERD:  db 0x20
;BUFFERE:  db 0x20
;BUFFERF:  db 0x20
