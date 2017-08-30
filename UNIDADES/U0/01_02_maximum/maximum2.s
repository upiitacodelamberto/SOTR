#PURPOSE: This program finds the maximum number of a

# set of data items.

#
#VARIABLES: The registers have the following uses:

#

# %edi - Holds the index of the data item being examined

# %ebx - Largest data item found

# %eax - Current data item

# %ecx - Address of the last item

# %edx - Address of current data item

#

# The following memory locations are used:

#

# data_items - contains the item data. A 0 is used

# to terminate the data

# data_items_end - contains the address inmediatelly after
# the item data

# progname - contains the address of the string 
# "maximum2\n"

#
.section .data

data_items:			# These are the data items
#.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
.long 3,67,34,222,45,75,54,34,44,33,22,11,66
data_items_end:
#.long 0			 # Si se comenta esta linea, echo $? muestra el valor correcto,
			 # 222 (progname=data_items_end)
			 # Si no se comenta, echo $? muestra el valor 255 (progname=data_items_end+4
			 # y por lo tanto progname es diferente de data_items_end; el 255 se coloca 
			 # en %ebx antes de la etiqueta salir)
progname:
.ascii "maximum2\n"

.section .text

.globl _start
_start: 
movl $0,%edi		 # move 0 into the index register
movl data_items(,%edi,4),%eax # load the first byte of data /* direct address mode data_items+0+4*%edi in */
movl %eax,%ebx		 # since this is the first item, %eax is
			 # the biggest

# movl $data_items_end,%esi# %esi or any other register you want
			 #But if you really wanted to...
			 #To calculate the end of the list, base + (4 * num_items)

leal data_items,%ecx	 # base, one can also use:  movl $data_items,%ecx
movl $4,%edx		 # sizeof(long),sizeof(int)
imull $13,%edx		 # num_items
add %edx,%ecx		 # end of list in ECX, now we have base + (4 * num_items) in %ecx
			 # i.e. the address of the 0 after the last data item =66

start_loop:		 # start loop
#cmpl $0,%eax		 # check to see if we’ve hit the end
movl %ebx,%esi
cmpl $data_items_end,%ecx
je etiqueta
   movl $9,%edx           #message length
   movl $progname,%ecx    #message to write
   movl $1,%ebx           #file descriptor (stdout)
   movl $4,%eax           #system call number (sys_write)
   int $0x80              #call kernel
etiqueta:
movl %esi,%ebx
incl %edi		 # load next value
movl data_items(,%edi,4),%eax # Current data item
leal data_items(,%edi,4),%edx # Address of current data item
cmpl %edx,%ecx		 # compare address of the data item in 
			 # %eax and the addess in %ecx
je loop_exit
cmpl %ebx,%eax		 # compare values
jle start_loop		 # jump to loop beginning if the new
			 # one isn’t bigger
movl %eax,%ebx		 # move the value as the largest
jmp start_loop		 # jump to loop beginning

loop_exit:
 # %ebx is the status code for the exit system call
 # and it already has the maximum number
leal data_items_end,%ecx
leal progname,%edx
cmpl %ecx,%edx
je salir		 # if(progname!=data_item_end){
movl $0xff,%ebx		 #   %ebx=255;
			 # }
salir:
movl $1,%eax		 #1 is the exit() syscall
int $0x80
