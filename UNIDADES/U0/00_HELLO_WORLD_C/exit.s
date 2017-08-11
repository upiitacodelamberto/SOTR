#PURPOSE: Simple program that exits and returns a
# status code back to the Linux kernel
#
#INPUT: none
#
#OUTPUT: returns a status code. This can be viewed
# by typing
#
# echo $?
#
# after running the program
#
#VARIABLES:
# %eax holds the system call number
# %ebx holds the return status
#
.section .data

.section .text
.globl _start
.globl salir
_start:
salir:
movl $1,%eax	# this is the linux kernel command 
#mov $1,%rax	# this is the linux kernel command 
		# number (system call) for exiting
		# a program


movl $0xa,%ebx	# this is the status number we will
#mov $0,%rbx	# this is the status number we will
		# return to the operating system.
		# Change this around and it will
		# return different things to
		# echo $?

int $0x80	# this wakes up the kernel to run
		# the exit command
#int $128	# this wakes up the kernel to run
