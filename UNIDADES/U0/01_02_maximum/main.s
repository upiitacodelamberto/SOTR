	.file	"main.c"
	.text
	.globl	funcion
	.type	funcion, @function
funcion:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	$3, -20(%ebp)
	movl	$67, -16(%ebp)
	movl	$44, -12(%ebp)
	movl	-20(%ebp), %eax
	subl	$12, %esp
	pushl	%eax
	call	salir
	addl	$16, %esp
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	funcion, .-funcion
	.ident	"GCC: (Debian 6.1.1-11) 6.1.1 20160802"
	.section	.note.GNU-stack,"",@progbits
