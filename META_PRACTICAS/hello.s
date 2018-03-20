# hello.s
# Un programa hol mundo que utiiza puts
.text
message:
 .ascii "Hello world2!\0"
 .align 4
.globl mainGAS
mainGAS:
 pushl %ebp            
 movl %esp,%ebp
 #call ___main          
 pushl $message       
 call puts
 addl $4,%esp
 xorl %eax,%eax
 movl %ebp,%esp     
 popl %ebp
 ret
 
