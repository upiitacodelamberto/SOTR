#
# This program is based on 
#
#; N A M E : x p u t c h a r . a s m
#;
#; D E S C : putchar() by assembly
#;
#; A U T H : Wataru Nishida, M.D., Ph.D.
#;           wnishida@skyfree.org
#;           http://www.skyfree.org
#;
#; M A K E : nasm -f elf xputchar.asm
#;
#; V E R S : 1.0
#;
#; D A T E : Dec. 17, 2000
#;
# taken from the web page:
# http://lsi.ugr.es/jagomez/sisopi_archivos/HolaMundo.htm
# visited on Sunday August 6, 2017.
# 
# Translation to AT&T syntax by Lamberto Maza Casas
# Make : asm --32 -m elf_i386 xexit.s -o xexit.o

#bits    32              ; Use 32bit mode.
#; [ NOTE ] Code starts from here.
#section .text          ; Code must resides in the ".text" in GCC.
#global  xputchar       ; Declare xputchar() as a public function.
#;
#;     p u t c      
#;
#;       int  putc (unsigned int fd,unsigned int ch)
#;
#;       --- return one (success) or -1 (error)
#;
#;                                             August. 11, 2017
#xputchar:
#        push    ebp                    ; Remember EBP.
#        mov            ebp, esp       ; Prepare my stack frame.
#                                              ; Now, [ ebp ] points saved EBP,
#                                              ; and [ ebp+4 ] points return address.
#
#        ; [ NOTE ] We must preserve registers except EAX, ECX, and EDX.
#
#        push    ebx                    ; Save EBX.
#
#        ; [ NOTE ] 1st argument appears in [ ebp+8 ], and 2nd [ ebp+12 ]...
#
#        mov     eax, [ ebp + 8 ]; Get character code.
#        mov     [ msgbuf ], al ; And save it.
#        mov     edx, 1                 ; Set character count.
#        mov     ecx, msgbuf            ; Set buffer pointer.
#        mov     ebx, 1                 ; Set STDOUT.
#        mov     eax, 4                 ; Call sys_write().
#        int     0x80
#
#        pop     ebx                            ; Recover EBX.
#        leave                          ; Perform ESP=EBP and EBP=pop().
#        ret
#
#; [ NOTE ] Storage area for the variables starts from here.
.code32			# Use 32bit mode.
.section .text		# Code must resides in the ".text" in GCC.
.globl putc		# Declare putc() as a public function.
putc:
pushl %ebp		# Remember %ebp.
movl %esp,%ebp		# Prepare my stack frame.
			# Now, (%ebp) points saved %ebp,
			# and 4(%ebp) points return address.
# [ NOTE ] We must preserve registers except %eax, %ecx, and %edx.
pushl %ebx		# Save EBX.
# [ NOTE ] 1st argument appears in 8(%ebp), and 2nd 12(%ebp) ...

movl 12(%ebp),%eax	# Get character code. (2nd argument)
movb %al,(msgbuf)	# And save it.
movl $1,%edx		# Set character count.
movl $msgbuf,%ecx	# Set buffer pointer.
#movl $1,%ebx		# Set STDOUT.
movl 8(%ebp),%ebx	# Get file descriptor and set STDOUT. (1st argument)
movl $4,%eax		# Call sys_write().
int $0x80

popl %ebx		# Recover %ebx.

movl %ebp,%esp		# Perform %esp=%ebp
popl %ebp		# and EBP=pop().
ret

# [ NOTE ] Storage area for the variables starts from here.
.section .data		# Variables must reside in the ".data" in GCC.
msgbuf:
.byte 0			# Message buffer.

