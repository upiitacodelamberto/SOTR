;-------------NASM's standalone Hello-World.asm for Linux --------
section .text
extern puts
global main

main:    
   push dword msg                ;stash the location of msg on the stack.
   call puts                     ;call the 'puts' routine (libc?) 
   add esp, byte 4               ;clean the stack?
   ret                           ;exit.

msg:
   db "Hello World!",0            

