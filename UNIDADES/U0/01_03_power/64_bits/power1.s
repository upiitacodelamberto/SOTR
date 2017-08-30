#PURPOSE: Program to illustrate how functions work

# This program will compute the value of

# 2^3 + 5^2 = 8 + 25 = 33

#

#Everything in the main program is stored in registers,

#so the data section doesn’t have anything.
.section .data
#answer:
#.asciz "Current byte: %d\n"

.section .text

.global _start
_start:
subq $8,%rsp		# allocate 8-byte stack frame

#leaq answer(%rip),%rdi
#movq $0,%rsi
#movb (%rsp),%sil
#movb $0,%al
#call printf

movq $2,%rdi		#push first argument
#movq $3,%rdi		#push first argument

movq $3,%rsi		#push second argument
#movq $2,%rsi		#push second argument

call power		#call the function
pushq %rax		#save the first answer before
			#calling the next function

movq $5,%rdi		#push first argument
#movq $4,%rdi		#push first argument

movq $2,%rsi		#push second argument

call power		#call the function
popq %rbx		#The second answer is already
			#in %rax. We saved the
			#first answer onto the stack,
			#so now we can just pop it
			#out into %rbx

addq %rax,%rbx		#add them together
			#the result is in %rbx
movq %rbx,%rdi

addq $8,%rsp		# deallocate stack frame
#movl $1,%eax		#exit (%ebx is returned)
#int $0x80
movq $60,%rax		#exit (%rdi is returned)
syscall

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
# %rdi - holds the base number
# %rsi - holds the power
#
# %edx - holds the current result
#
# %rax is used for temporary storage
#

#.type power,@function
power:
  movq %rdi,%rbx	#put first argument in %rbx
  movq %rsi,%rcx	#put second argument in %rcx
#  movq %rbx,%rdx	#move the current result into %rdx
movq %rbx,16(%rsp)	#move the current result into 16(%rsp) i
			#because at 8(%esp) is the return address

power_loop_start:
  cmpq $1,%rcx		#if the power is 1, we are done
  je end_power
#  movq %rdx,%rax	#move the current result into %rax
movq 16(%rsp),%rax	#move the current result into %rax

  imulq %rdi,%rax	#multiply the current result by
			#the base number
#  movq %rax,%rdx	#store the current result
movq %rax,16(%rsp)	#store the current result
  decq %rcx		#decrease the power
  jmp power_loop_start	#run for the next power

end_power:
#  movq %rdx,%rax	#return value goes in %rax
movq 16(%rsp),%rax	#return value goes in %rax
  ret
