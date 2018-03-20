#___________________________________________________________________________
#
#___ include.asm ___________________________________________________________

 .MACRO _print message
 # start _print message
 pushl $\message
 call puts
 addl $4,%esp
 # end   _print message
 .ENDM

 .MACRO _open file mode
 # start _open file mode
 pushl %ebp
 movl %esp,%ebp
 pushl $\mode
 pushl $\file
 call fopen
 addl $8,%esp
 movl %eax,-4(%ebp)
 # %eax = file-handle
 #        - if %eax = 0 then the file doesn't exist
 #        - if %eax >< 0 %eax is the file-handle
 popl %ebp
 # end   _open file mode
 .ENDM

 .MACRO _close filehandle
 # start _close filehandle
 pushl \filehandle
 call fclose
 addl $4,%esp
 # end   _close filehandle
 .ENDM
#___________________________________________________________________________
#
#as test_fopen.s -o test_fopen.o
#gcc test_fopen.o -o test_fopen
