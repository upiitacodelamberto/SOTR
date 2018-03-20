;-------------NASM's standalone Hello-World.asm for Linux --------
section .text
extern puts
global main
extern mainGAS

main:    
   push dword msg                ;stash the location of msg on the stack.
   call puts                     ;call the 'puts' routine (libc?) 
   add esp, byte 4               ;clean the stack?
;call main
call mainGAS
   ret                           ;exit.

msg:
   db "Hello World1!",0            

