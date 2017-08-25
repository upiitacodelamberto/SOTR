#PURPOSE: This program finds the minimum number of a

# set of data items.

#
#VARIABLES: The registers have the following uses:

#

# %edi - Holds the index of the data item being examined

# %ebx - Largest data item found

# %eax - Current data item

#

# The following memory locations are used:

#

# data_items - contains the item data. A 0 is used

# to terminate the data

#
.section .data

data_items:			# These are the data items
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
progname:
.ascii "maximun1\n"

.section .text

.globl _start
_start: 
   movl $9,%edx           #message length
   movl $progname,%ecx    #message to write
   movl $1,%ebx           #file descriptor (stdout)
   movl $4,%eax           #system call number (sys_write)
   int $0x80              #call kernel



movl $0,%edi		 # move 0 into the index register
movl data_items(,%edi,4),%eax # load the first byte of data
movl %eax,%ebx		 # since this is the first item, %eax is
			 # the biggest
start_loop:		 # start loop
#cmpl $0,%eax		 # check to see if we’ve hit the end
#je loop_exit
incl %edi		 # load next value
movl data_items(,%edi,4),%eax
cmpl $0,%eax		 # check to see if we’ve hit the end
je loop_exit
cmpl %ebx,%eax		 # compare values
#jle start_loop		 # jump to loop beginning if the new
			 # one isn’t bigger
jge start_loop		 # jump to loop beginning if the new
			 # one isn’t smaller
#movl %eax,%ebx		 # move the value as the largest
movl %eax,%ebx		 # move the value as the smallest
jmp start_loop		 # jump to loop beginning

loop_exit:
 # %ebx is the status code for the exit system call
 # and it already has the maximum number
movl $1,%eax		 #1 is the exit() syscall
int $0x80
