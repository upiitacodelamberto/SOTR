#PURPOSE: This function is used to compute
# the value of a number raised to
# a power.
#

#INPUT: First argument - the base number
# Second argument - the power to
# raise it to
#
#OUTPUT: Will give the result as a return value
#
#NOTES: The power must be 1 or greater
#
#VARIABLES:
# %ebx - holds the base number
# %ecx - holds the power
#
# -4(%ebp) - holds the current result
#
# %eax is used for temporary storage
#

.globl power
.type power,@function
power:
  pushl %ebp		#save old base pointer
#  pushq %rbp		#save old base pointer
  movl %esp,%ebp	#make stack pointer the base pointer
  subl $4,%esp		#get room for our local storage
  movl 8(%ebp),%ebx	#put first argument in %ebx
  movl 12(%ebp),%ecx	#put second argument in %ecx
  movl %ebx,-4(%ebp)	#store current result

power_loop_start:
  cmpl $1,%ecx		#if the power is 1, we are done
  je end_power
  movl -4(%ebp),%eax	#move the current result into %eax
  imull %ebx,%eax	#multiply the current result by
			#the base number
  movl %eax,-4(%ebp)	#the base number
  decl %ecx		#decrease the power
  jmp power_loop_start	#run for the next power

end_power:
  movl -4(%ebp),%eax	#return value goes in %eax
  movl %ebp,%esp	#restore the stack pointer
  popl %ebp		#restore the base pointer
#  popq %rbp		#restore the base pointer
  ret

