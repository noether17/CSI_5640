	.file	"fftw_test.c"
	.text
	.section	.rodata
.LC0:
	.string	"index %d: %f + %fi\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	$256, %edi
	call	fftw_malloc@PLT
	movq	%rax, -24(%rbp)
	movl	$256, %edi
	call	fftw_malloc@PLT
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rax
	movl	$64, %r8d
	movl	$-1, %ecx
	movq	%rax, %rsi
	movl	$16, %edi
	call	fftw_plan_dft_1d@PLT
	movq	%rax, -8(%rbp)
	movl	$0, -32(%rbp)
	jmp	.L2
.L3:
	movl	-32(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	cvtsi2sd	-32(%rbp), %xmm0
	movsd	%xmm0, (%rax)
	addl	$1, -32(%rbp)
.L2:
	cmpl	$15, -32(%rbp)
	jle	.L3
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fftw_execute@PLT
	movl	$0, -28(%rbp)
	jmp	.L4
.L5:
	movl	-28(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movsd	8(%rax), %xmm0
	movl	-28(%rbp), %eax
	cltq
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-28(%rbp), %eax
	movapd	%xmm0, %xmm1
	movq	%rdx, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movl	%eax, %esi
	leaq	.LC0(%rip), %rdi
	movl	$2, %eax
	call	printf@PLT
	addl	$1, -28(%rbp)
.L4:
	cmpl	$15, -28(%rbp)
	jle	.L5
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fftw_destroy_plan@PLT
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	fftw_free@PLT
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fftw_free@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
