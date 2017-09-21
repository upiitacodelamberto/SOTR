/*
|	boot.s

*   This is a rewriting of the linux-0.01/boot.s, using the 
*   GNU assembler syntax with some modifications.

| boot.s is loaded at 0x7c00 by the bios-startup routines, and moves itself
| out of the way to address 0x90000, and jumps there.
|
| It then loads the system at 0x10000, using BIOS interrupts. Thereafter
| it disables all interrupts, moves the system down to 0x0000, changes
| to protected mode, and calls the start of system. System then must
| RE-initialize the protected mode in it's own tables, and enable
| interrupts as needed.

*   Note: I have used function 0x42 of the BIOS service 0x13 instead of
*   function number 0x2 used in the original boot.s!
 
*   copyright(C) 2015 Issam Abdallah, Tunisia.
*   E-mail: iabdallah@yandex.com

*   License: GPL
*/

	.code16
	.text
	.global _start

_start:

BOOTSEG = 0x07c0
INITSEG = 0x9000
SYSSEG  = 0x1000			# system loaded at 0x10000 (65536).
SYSSIZE = 10				# >= size of 'Image' in sectors (512 bytes)

######################################### * move boot.s at 0x1000

	movw	$BOOTSEG, %ax
	movw	%ax, %ds
	movw	$INITSEG, %ax
	movw	%ax, %es
	movw	$256, %cx		# 256 * 2 = 512 bytes
	subw	%si, %si
	subw	%di, %di
	cld
	rep 
	movsw				# move word by word

	ljmp	$INITSEG, $go		# jump to 0x90000

######################################### * Initialize segment registers

go: 
	mov 	%cs, %ax 	
	mov 	%ax, %ds		# ES = CS!
	mov 	%ax, %es		# ES = DS!
	mov 	%ax, %ss		# optional
	mov 	$0x400, %sp		# arbitrary value >>512


#2017.09.16
#	xor	%ah, %ah		# AH = 0: function 0 => set video mode
#	mov	$0x3, %al		# video mode: 80x25 16 colors text mode 
	xor	%bh, %bh		# 
	mov	$0x3, %ah		# read cursor pos
	int	$0x10			# BIOS interrupt number 0x10 (video service)

	movw	$MSG_SIZE, %cx		# size of message
	movb	$0, %bh			# page 0
	movb	$0x07, %bl		# background black (0x0) - foreground white (0x7)
	movw	$msg, %bp		# [ES:BP]: offset of the message
	movb	$0x13, %ah		# write string
	movb	$0x01, %al		# move cursor
	int	$0x10

######################################### * ok, we've written the message, now we want to load the system (at 0x10000)

1:
	xor 	%ax, %ax		# AX=0: Initialize the disk
	int 	$0x13			# BIOS Interrupt number 0x13 (disk service)
	jc	1b
					# Load head.s (kernel) into the memory at the address 0x0: 
	xor	%ax, %ax
	movb	$0x42, %ah		# function 0x42: extended disk sectors read (LBA)
	movw	$dap, %si 		# SI = dap: address of the 'Disk Address Packet' structure
	int	$0x13

######################################### * now we want to move to protected mode ... 

	cli				# no interrupts are allowed! 		

######################################### * first we move the system to it's rightful place

	xor	%ax, %ax
	cld				# 'direction'=0, movs moves forward
do_move:
	movw	%ax, %es		# destination segment
	addw	$0x1000, %ax
	cmpw	$INITSEG, %ax		# we will move segments from 0x1000 to 0x8000
	jz	end_move
	movw	%ax, %ds		# source segment
	xor	%di, %di
	xor	%si, %si
	movw 	$0x8000, %cx		# size of a segment (64Kb) in words
	rep
	movsw				# movsw will move word by word
	jmp	do_move

end_move:
######################################### * then we load the segment descriptors

	mov	$INITSEG, %ax		# right, forgot this at first. didn't work :-)
	mov	%ax, %ds 
	lgdt 	gdt_ptr			# load gdt with whatever appropriate

######################################### * that was painless, now we enable A20

	call	empty_8042

	movb	$0xD1, %al		# command write
	outb	%al, $0x64
	call	empty_8042

	movb	$0xDF, %al		# A20 on
	outb	%al, $0x60
	call	empty_8042

######################################### * well, that went ok, I hope. Now we have to reprogram the interrupts :-(
 					# we put them right after the intel-reserved hardware interrupts, at
					# int 0x20-0x2F. There they won't mess up anything. Sadly IBM really
					# messed this up with the original PC, and they haven't been able to
					# rectify it afterwards. Thus the bios puts interrupts at 0x08-0x0f,
 					# which is used for the internal hardware interrupts as well. We just
					# have to reprogram the 8259's, and it isn't fun. 
					#
					# ICW : Initialisation Command Word
					#
					# PIC 	     type	port
					# ------------------------------
					# 8259A-1   Command 	0x0020
					# 8259A-1   Data 	0x0021
					# 8259A-2   Command 	0x00A0
					# 8259A-2   Data 	0x00A1 

	## ICW1 command: Initialization sequence (control command)
	movb	$0x11, %al		# ICW1 = 0x11 => two PIC(Bit 4), ICW4 is required (bit 0)
	outb	%al, $0x20		# send to 8259A-1 (port 0x20 = command port)
	.word	0x00eb, 0x00eb		# jmp $+2, jmp $+2 => wait untill the port take a breathe :)
	outb	%al, $0xA0		# send to 8259A-2 (port 0xA0 = command/control port)
	.word	0x00eb,0x00eb

	## ICW2 command: send data 
	movb	$0x20, %al		# first 8259A-1 entry in IDT
	outb	%al, $0x21		# IDT[0x20]: timer interrupt (IRQ0)
	.word	0x00eb, 0x00eb		# 
	movb	$0x28, %al		# first 8259A-2 entry in IDT
	outb	%al, $0xA1		# IDT[0x28]: timer interrupt (IRQ8)
					
	.word	0x00eb, 0x00eb

	## ICW3 command: send data
	movb	$0x04, %al		# PIC 8259A-1 is master
	outb	%al, $0x21
	.word	0x00eb, 0x00eb
	movb	$0x02, %al		# PIC 8259A-2 is slave
	outb	%al, $0xA1
	.word	0x00eb, 0x00eb

	## ICW4	: data command 
	movb	$0x01, %al		# no AEOI (bit-1), 8086 mode (bit-0)
	outb	%al, $0x21
	.word	0x00eb, 0x00eb
	outb	%al, $0xA1
	.word	0x00eb, 0x00eb

######################################### * well, that certainly wasn't fun :-(. Hopefully it works, and we don't
					# need no steenking BIOS anyway (except for the initial loading :-).
					# The BIOS-routine wants lots of unnecessary data, and it's less
					# "interesting" anyway. This is how REAL programmers do it.
					# Well, now's the time to actually move into protected mode. To make
					# things as simple as possible, we do no register set-up or anything,
					# we let the gnu-compiled 32-bit programs do that. We just jump to
					# absolute address 0x00000, in 32-bit protected mode.

	mov 	%cr0, %eax		# protected mode (PE) bit
	or 	$1, %ax			# EAX[0] = 1
	mov 	%eax, %cr0 		# this is it!

######################################### * empty the instruction queue of the processor by a LJMP from a 16-bit 
					# code towards a 32-bit code. 

					# Note: We have to use the prefix 0x66 - see INTEL 80386 manual 
					# section: Mixing 16-bit and 32-bit code

	.byte	0x66, 0xea		# prefix (0x66) + ljmp opcode (0xea)
	.long	ok_pm + 0x90000		# offset must be a physical address (we are no longer in real mode!)
	.word	0x8			# CS = 0x8: GDT[1]

	.code32

ok_pm:	

	ljmp	$0x8, $0x0		# Long JAMP to kernel head (CS:EIP)

######################################### * This routine checks that the keyboard command queue is empty
					# No timeout is used - if this hangs there is something wrong with
					# the machine, and we probably couldn't proceed anyway.
empty_8042:
	.word	0x00eb,0x00eb
	inb	$0x64, %al 		# 8042 status port
	testb	$2, %al			# is input buffer full?
	jnz	empty_8042		# yes - loop
	ret

######################################## * DAP: Disk Address Packet
dap:	.byte	0x10			# size of dap = 16 bytes 
	.byte	0			# 0 - unused
	.word	SYSSIZE			# number of sectors to be read
	## buffer = [segment:offset]: memory location to read into it!
	.word	0x0000			# offset
	.word	SYSSEG			# segment
	.word	1,0,0,0			# index of first sector to be read 

######################################### * GDT

gdt:
					## GDT[0]
gdt_null_desc:
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000

					## GDT[1]
gdt_cs_desc:
	.word	0xffff			# Limit 15..0
	.word	0x0000			# Base  15..0
	.byte	0x00			# Base  23..16
	.byte	0b10011011		# P/DPL/S/[Type(1ARC)] = 1/00/1/1011 [ARC = Accessed/Read enable/Conforming]
	.byte	0b11011111		# G/D/L/AVL/[Limit(19..16)] = 1/1/0/1/1111
	.byte	0x00			# Base 31..24

					## GDT[2]
gdt_ds_desc:
	.word	0xffff
	.word	0x0000
	.byte	0x00
	.byte	0b10010011		# P/DPL/S/[Type(0AWE)] = 1/00/1/0011 [AWE = Accessed/Write enable/Expansion dir]
	.byte	0b11011111
	.byte	0x00

gdt_ptr:
	.word	. - gdt - 1		# Limit = (8*3) - 1
	.long	0x90000 + gdt		# Base = (0x7c0 << 4) + offset (must be a physical address!)

######################################### * msg

msg:
	.byte	13, 10			# CR, LF
	.ascii	"Loading system..."
	.byte	13,10,13,10		# CR, LF, CR, LF

MSG_SIZE = . - msg

	.org	510
	.word	0xAA55 

######################################## * boot.s *
