/* 
*	kernel.s 
*
*   A 32 bit code, running in 386 protected mode. It will setup IDT, GDT, 
*   segment registers, enable interrupts and move to user mode and schedule, using 
*   timer interrupt, two level-3 tasks: task0 and task1. 
*   Each task will make a system call to print a character on the screen.
*   task0 will print 'A', and task1 will print B. 
*   Each task has its own level-0 and level-3 stacks.
*
*   copyright(C) 2015 Issam Abdallah, Tunisia.
*   E-mail: iabdallah@yandex.com
*
*   License: GPL
*
*/
.code32

SCREEN	 = 2000				# video mode: 80x25 16 colors text mode.
					# That is, we can display only 2000 characters ('A' and 'B') at once.

VGA_MEM	 = SCREEN*2			# To be displayed, each character will take 2 bytes in the VGA memory
					# 1 byte to write its ASCII code (even adresses: 0, 2, 4, 6,...)-
					# 1 byte to write its attribute (odd adresses:     1, 3, 5 ,7,...)
					# That is, we will use 4000 bytes in the VGA memory. 

TIMER_FREQ = 1193180 			# timer (INTEL 8253 PIT) oscillator frequency
HZ	 = 100 				# 100 timer interrupts per second

LATCH 	 = (TIMER_FREQ/ HZ)		# The timer will decrement by one this value each T = 0.000838 ms.
					# When it becomes equal to 0, the PIT will generate a timer interrupt (IRQ0)

TSS0_SEL = 0x20				# Those are the selectors of TSS and LDT descriptor,
LDT0_SEL = 0x28				# in the GDT, of the two tasks : task0 and task1.
TSS1_SEL = 0x30				#
LDT1_SEL = 0x38				#
					#
#########################################

	.global	startup_32
	.text

startup_32:

######################################### * load segment register and ESP

	mov 	$0x10, %eax 		# data segment - Selctor 0x10
	mov 	%ax, %ds
	mov 	%ax, %es
	mov 	%ax, %fs 
	mov 	%ax, %gs
	lss	kern_stack_ptr, %esp	# we use 'lss' instruction to load safely both SS and ESP!

######################################### * setup base fields of descriptors 5..8 in GDT

	lea	gdt, %ecx		# LEA: load effective address

	lea	tss0, %eax
	movl	$TSS0_SEL, %edi		# TSS0_SEL = 0x20
	call	set_tssldt_des

	lea	ldt0, %eax
	movl	$LDT0_SEL, %edi		# LDT0_SEL = 0x28
	call	set_tssldt_des

	lea	tss1, %eax
	movl	$TSS1_SEL, %edi		# TSS1_SEL = 0x30
	call	set_tssldt_des

	lea	ldt1, %eax
	movl	$LDT1_SEL, %edi		# LDT1_SEL = 0x38
	call	set_tssldt_des

######################################### * setup GDT and IDT

	call	setup_idt
	call	setup_gdt

#########################################

	mov 	$0x10, %eax 		# data segment - Selctor 0x10
	mov 	%ax, %ds
	mov 	%ax, %es
	mov 	%ax, %fs 
	mov 	%ax, %gs
	lss	kern_stack_ptr, %esp

######################################### * setup system call descriptor 

	call	set_trap_gate

######################################### * programming the timer chip (INTEL 8253 PIT)

					 /* - I/O ports:

						0x40	     Channel 0 data port (read/write) (IRQ0)
						0x41         Channel 1 data port (read/write)
						0x42         Channel 2 data port (read/write)
						0x43         Mode/Command register (write only, a read is ignored)
	
 					    - Output 0 (channel 0) is connected to pin 0 of the 8259A PIC: timer interrupt (IRQ0)

 					    - Mode/Command register (port 0x43)

							 ___7_____6__ __5____4___ __3_____2_____1_____0___
	 						|     |     |     |     |     |     |     | BCD/ |   
	 						|  channel  |Access mode| Operating mode  | BIN  |
	 						|_____|_____|_____|_____|_____|_____|_____|_mode_| 
					*/

	movb $0x36, %al			# binary mode (bit 0), operating mode 3, LSB/MSB, channel 0
	movl $0x43, %edx		# port 0x43
	outb %al, %dx

	movl $LATCH, %eax        	# That is, LATCH=11931
	movl $0x40, %edx		# port 0x40
	outb %al, %dx			# write LSB - bits 7..0
	shr  $8, %ax
	outb %al, %dx			# then, MSB - bits 15..8

######################################### * setup timer interrupt gate descriptor

	call	set_intr_gate

######################################### unmask the timer interrupt

	movl $0x21, %edx
	inb %dx, %al
	andb $0xfe, %al
	outb %al, %dx

######################################### * Move to user mode (task0)
## NOTE: IRET will cause the processor to automatically switch to another task if NT=1! 

	pushfl
	andl	$0xffffbfff, (%esp)	# ensure that NT is clear (NT = 0)! 
	popfl

	movl	$TSS0_SEL, %eax
	ltr	%ax			# Load task register
	movl	$LDT0_SEL, %eax
	lldt	%ax 			# load LDTR

	sti				# IDT is setup, so we can enable interrupts now
 
######################################### * stack layout before IRET with privilege transition - see 80386's manual!

	pushl	$0x17			# task's SS
	pushl	$task0_tos		# task's ESP
	pushfl				# task's EFLAGS
	pushl	$0x0f			# task's CS
	pushl	$task0			# task's EIP

######################################### move to user mode and execute the task by loading EIP, CS, EFLAGS, ESP and SS 
					# by the values previously pushed into the stack
	iret				 
					
#########################################
/* ----------------------------------- */
#########################################

setup_gdt:
	lgdt	gdt_ptr
	ret

######################################### * initialize IDT

					/*		Interrupt gate Descriptor (type=14 = 0xE)
					  _____________________________________________________________
					  |				| |   | |       | | | |       |
					  |	   OFFSET 31..16	|P|DPL|0| TYPE  |0 0 0|unused | <-- EDX
					  |_____________________________|_|_|_|_|1|1|1|0|_|_|_|_|_|_|_|
					  |				|			      |
					  |	      SELECTOR		|	OFFSET 15..0	      | <-- EAX
					  |_____________________________|_____________________________|

					  _____________________________________________________________
					  |				| |   | |       | | | |       |
					  |  &ignore_int 31..16		|1|000|0| TYPE  |0 0 0| 0000  | <-- EDX
					  |_____________________________|_|_|_|_|1|1|1|0|_|_|_|_|_|_|_|
					  |				|			      |
					  |	      0x0008		|	&ignore_int 15..0     | <-- EAX
					  |_____________________________|_____________________________| 

					*/

setup_idt:
	lea	ignore_int, %edx	# this is the default interrupt handler
	movl	$0x00080000, %eax	# CS = 0x8 - kernel code segment
	movw	%dx, %ax
	movw	$0x8e00, %dx		# present=1, DPL=0, type=14 

	lea	idt, %edi
	mov	$256, %ecx		# 256 descriptors in IDT
rp_sidt:
	movl	%eax, (%edi)
	movl	%edx, 4(%edi)
	addl	$8, %edi
	dec	%ecx
	jne	rp_sidt

	lidt	idt_ptr
	ret

######################################### * setup timer interrupt gate descriptor at IDT[0x20]

set_intr_gate:
	movl	$0x20, %ecx
	lea	idt(,%ecx,8), %edi	# IDT[0x20]: system call gate
	mov	$0x80000, %eax		# CS = 0x8
	lea	timer_interrupt, %edx

	mov	%dx, %ax
	mov	%eax, (%edi)
	mov	$0x8e00, %dx		# interrupt gate: Present, DPL=0, type=14
	mov	%edx, 4(%edi)
	ret


######################################### * setup system call gate descriptor at IDT[0x80]
					# We are in Level 3 and we want to call a kernel routine at level 0
					# using the instruction 'int'. INTEL 80386 Manual/section 6.4.3 say:
					#
					# 	To provide protection for control transfers among 
					# 	executable segments at different privilege levels, 
					# 	the 80386 uses gate descriptors.
					# 
					# That is, We can do that through a 'Trap gate' as it's done on linux-0.01. 
					# cool :)

					/*		Trap gate descriptor (type=15 = 0xF)
					  _____________________________________________________________
  					  |				| |   | |       | | | |       |
					  |	   OFFSET 31..16	|P|DPL|0| TYPE  |0 0 0|unused | <-- EDX
					  |_____________________________|_|_|_|_|1|1|1|1|_|_|_|_|_|_|_|
					  |				|			      |
					  |	      SELECTOR		|	OFFSET 15..0	      | <-- EAX
					  |_____________________________|_____________________________|

					  _____________________________________________________________
					  |				| |   | |       | | | |       |
					  |  &system_call 31..16	|1|1 1|0| TYPE  |0 0 0| 0000  | <-- EDX
					  |_____________________________|_|_|_|_|1|1|1|1|_|_|_|_|_|_|_|
					  |				|			      |
					  |	      0x0008		|	&system_call 15..0    | <-- EAX
					  |_____________________________|_____________________________| <-- idt[0x80]

					*/
set_trap_gate:
	movl	$0x80, %ecx
	lea	idt(,%ecx,8), %edi	# IDT[0x80]: system call gate
	mov	$0x80000, %eax		# CS = 0x8
	lea	system_call, %edx

	mov	%dx, %ax
	mov	%eax, (%edi)
	mov	$0xef00, %dx		# interrupt gate: Present, DPL=3, type=15
	mov	%edx, 4(%edi)
	ret

######################################### * Default ISR
	.balign	8
ignore_int:
	nop				# do nothing when an interrupt occurs ...
	iret				# just tickle the processor :)

######################################### * This proc will set the bases fileds
					# of TSS and LDT descriptors in GDT with
					# the adresses 'tss' and 'ldt' at runtime.
set_tssldt_des:

	addl	%ecx, %edi		# ECX = gdt
	movw	%ax, 2(%edi)		# base 0..15
	rorl	$16, %eax
	movb	%al, 4(%edi)		# base 16..23
	movb	%ah, 7(%edi)		# base 31..24
	ret

######################################### * system call handler

	.balign	2
system_call:

	push	%eax
	push	%ds
	push	%gs
	push	%edi

	mov	$0x10, %eax		# set DS to point to kernel data 
	mov	%ax, %ds

	mov	$0x18, %eax		# GDT[3] - VGA memory
	mov	%ax, %gs

	call	print_char		# print the character

	pop	%edi
	pop	%gs
	pop	%ds
	pop	%eax
	iret

print_char:

	mov	char_pos, %edi	
	movb	%cl, %gs:(%edi)		# even address - the ASCII of the character 'A' or 'B'
	incl	%edi
	movb	%dl, %gs:(%edi)		# odd address - it's attribute
	incl	%edi
	cmpl	$VGA_MEM, %edi		# have we reach character 4000 bytes in the screen ?
	jb	1f			# no. continue!
	movl	$0, char_pos		# yes. return to the first character's location on the screen.
	jmp	2f
1:	movl	%edi, char_pos		# save the current screen position
2:
	ret

######################################### * timer interrupt handler

	.balign	2
timer_interrupt:
	pushl	%eax
	push	%ds

	mov	$0x10, %eax		# set DS to point to kernel data 
	mov	%ax, %ds

	movb	$0x20, %al		# EOI to interrupt controller-1
	outb	%al, $0x20

	call	schedule		# schedule

	pop	%ds
	pop	%eax
	iret

######################################### * our kernel's scheduler

schedule:
	mov	current, %eax
	cmpl	$0, %eax		# is task0 is currently executing ?
	je	1f			# yes. so, jump to ..
	movl	$0, current
	ljmp	$TSS0_SEL, $0		# no. so switch to it.
	jmp	2f
1:	movl	$1, current
	ljmp	$TSS1_SEL, $0		# so switch to task1

2:
	ret

######################################### * kernel stack

	.balign	4
	.fill	128, 4, 0		# 32 entries (I think this is the min size:)

kern_stack_ptr:				# for 'lss' instruction	
	.long	.			# ESP0
	.word	0x10			# SS0

#########################################

current: .long 0			# to track the current executing task's ID
char_pos:.long 0			# to track the current screen position

######################################### * IDT

	.balign	8			# align to 8 bytes to increase IDT access speed - (only 1 bus cycle)
idt:	.fill	256, 8, 0		# reserve 256 idt entries - (IDT is not yet initialized!)

idt_ptr:
	.word	256*8 - 1		# Limit: IDT contains 256 entries (8 bytes entries)
	.long	idt			# Base: pointer to the first IDT entry 

######################################### * GDT: granularity = 1 => segment size = limit * 4Kb

	.balign	8
gdt:	.quad	0x0000000000000000	# NULL descriptor!
	.quad	0x00c09a00000007ff	# 8Mb code segment (CS=0x08), base = 0x0000
	.quad	0x00c09200000007ff	# 8Mb data segment (DS=SS=0x10), base = 0x0000
	.quad	0x00c0920b80000001	# 4Kb video memory (Sel=0x18) - with ** DPL=0! ** 
	.quad	0x0000890000000068	# TSS descriptor (Selector = 0x20) - Granularity = 0
	.quad	0x0000820000000040	# LDT descr (Selector = 0x28) - Granularity = 0
	.quad	0x0000890000000068	# TSS1 descriptor (Selector = 0x30)
	.quad	0x0000820000000040	# LDT1 descriptor (Selector = 0x38)

gdt_ptr:
	.word	. - gdt -1		# Limit
	.long	gdt			# Base: pointer to the first GDT entry (the NULL descr) 

######################################### * task0's LDT

	.balign 8
ldt0:	.quad	0x0000000000000000
	.quad	0x00c0fa00000007ff	# the task's local code segment (CS = 0x0f)
	.quad	0x00c0f200000007ff	# the task's local data segment (DS = SS = 0x17)

######################################### * the task's TSS

tss0:
	.long	0 			# back link = 0 (no previous TSS)
	.long	task0_krn_tos		# esp0
	.long	0x10			# ss0
	.long	0			# esp1
	.long	0			# ss1
	.long	0			# esp2
	.long	0			# ss2 
	.long	0			# cr3 (paging is disabled!)
	.long	task0			# eip
	.long	0x200			# eflags
	.long	0, 0, 0, 0		# eax, ecx, edx, ebx
	.long	task0_tos		# esp (level 3 stack pointer)
	.long	0, 0, 0			# ebp, esi, edi 
	.long	0x17			# es
	.long   0x0f			# cs
	.long	0x17			# ss (level 3 stack)
	.long	0x17,0x17,0x17		# ds, fs, gs
	.long	LDT0_SEL		# ldt selector
	.long	0x8000000		# I/O map base + T-bit

task_stack0:
	.fill	128,4,0
task0_krn_tos:				# TOS: Top Of Stack

######################################### * the task's purpose

task0:
	mov	$'A, %ecx		# print 'A'
	mov	$0x2f, %edx
	int	$0x80
	jmp	task0

######################################### * task0's level-3 stack

	.balign	4
task0_stack:
	.fill	128,4,0
task0_tos:

######################################### * task1's LDT

	.balign 8
ldt1:	.quad	0x0000000000000000
	.quad	0x00c0fa00000007ff	# task1's local code segment (CS = 0x0f)
	.quad	0x00c0f200000007ff	# task1's local data segment (DS = SS = 0x17)

######################################### * task1's TSS

	.balign	4
tss1:
	.long	0 			# back link = 0 (no previous TSS)
	.long	task1_krn_tos		# esp0
	.long	0x10			# ss0
	.long	0			# esp1
	.long	0			# ss1
	.long	0			# esp2
	.long	0			# ss2 
	.long	0			# cr3 (paging is disabled!)
	.long	task1			# eip
	.long	0x200			# eflags
	.long	0, 0, 0, 0		# eax, ecx, edx, ebx
	.long	task1_tos		# esp (level 3 stack pointer)
	.long	0, 0, 0			# ebp, esi, edi 
	.long	0x17			# es
	.long   0x0f			# cs
	.long	0x17			# ss (level 3 stack)
	.long	0x17,0x17,0x17		# ds, fs, gs
	.long	LDT1_SEL		# ldt selector
	.long	0x8000000		# I/O map base + T-bit

	.fill 128,4,0
task1_krn_tos:

######################################### * task1's purpose

task1:
	mov	$'B, %ecx		# print 'B'
	mov	$0x1f, %edx	
	int	$0x80			# system call
	jmp	task1

######################################### * task1's level-3 stack

	.balign	4
task1_stack:
	.fill	128,4,0
task1_tos:				# ESP

######################################## * kernel.s *

