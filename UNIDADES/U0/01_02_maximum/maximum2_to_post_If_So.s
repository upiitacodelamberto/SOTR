#PURPOSE: This program finds the maximum number of a

# set of data items.

#
#VARIABLES: The registers have the following uses:

#

# %edi - Holds the index of the data item being examined

# %ebx - Largest data item found

# %eax - Current data item

# %ecx - Address of location inmediatelly after last item

# %edx - Address of current data item

#

# The following memory locations are used:

#

# data_items - contains the item data.

# data_items_end - contains the address inmediatelly after
# the item data

#
.section .data

data_items:			# These are the data items
#.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
.long 3,67,34,222,45,75,54,34,44,33,22,11,66
data_items_end:


.section .text

.globl _start
_start: 
movl $0,%edi		 # move 0 into the index register
movl data_items(,%edi,4),%eax # load the first byte of data /* direct address mode data_items+0+4*%edi in */
movl %eax,%ebx		 # since this is the first item, %eax is
			 # the biggest

			 # Usually you can simply count the data items and compare to the 
			 # amount of items instead of use an "ending address"
			 # But if you really wanted to...
			 # To calculate the end of the list, base + (4 * num_items)

#leal data_items,%ecx	 # base, one can also use:  movl $data_items,%ecx
#movl $4,%edx		 # sizeof(long),sizeof(int)
#imull $13,%edx		 # num_items
#add %edx,%ecx		 # end of list in ECX, now we have base + (4 * num_items) in %ecx
			 # i.e. the address after the last data item =66
			 # Notice that instead of this one could simply use 
			 # leal data_items_end,%ecx
leal data_items_end,%ecx

start_loop:		 # start loop
			 # check to see if we’ve hit the end
incl %edi		 # load next value
movl data_items(,%edi,4),%eax # Current data item
leal data_items(,%edi,4),%edx # Address of current data item
cmpl %edx,%ecx		 # compare address of the data item in 
			 # %eax and the address in %ecx, (i.e.the ending address)
je loop_exit
cmpl %ebx,%eax		 # compare values
jle start_loop		 # jump to loop beginning if the new
			 # one isn’t bigger
movl %eax,%ebx		 # move the value as the largest
jmp start_loop		 # jump to loop beginning

loop_exit:
 # %ebx is the status code for the exit system call
 # and it already has the maximum number
movl $1,%eax		 #1 is the exit() syscall
int $0x80
