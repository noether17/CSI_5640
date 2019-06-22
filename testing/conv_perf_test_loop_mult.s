	.file	"conv_perf_test.c"
	.text
	.section	.rodata
.LC0:
	.string	"w"
.LC1:
	.string	"conv_out.txt"
	.align 8
.LC2:
	.string	"## First column is array size, following are times in milliseconds\n"
.LC3:
	.string	"%7d"
.LC4:
	.string	" %f"
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
	subq	$16, %rsp
	leaq	.LC0(%rip), %rsi
	leaq	.LC1(%rip), %rdi
	call	fopen@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rcx
	movl	$67, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rdi
	call	fwrite@PLT
	movl	$1024, -16(%rbp)
	jmp	.L2
.L5:
	movl	-16(%rbp), %edx
	movq	-8(%rbp), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -12(%rbp)
	jmp	.L3
.L4:
	movl	-12(%rbp), %edx
	movl	-16(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	execution_time
	movq	-8(%rbp), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	addl	$1, -12(%rbp)
.L3:
	cmpl	$9, -12(%rbp)
	jle	.L4
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	sall	-16(%rbp)
.L2:
	cmpl	$1048576, -16(%rbp)
	jle	.L5
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
.LC5:
	.string	"%d array elements"
.LC10:
	.string	" max error: %f;"
	.text
	.globl	execution_time
	.type	execution_time, @function
execution_time:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movl	%edi, -100(%rbp)
	movl	%esi, -104(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$0, -104(%rbp)
	jne	.L8
	movl	-100(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L8:
	movl	-100(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	fftwf_malloc@PLT
	movq	%rax, -56(%rbp)
	movl	-100(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	fftwf_malloc@PLT
	movq	%rax, -48(%rbp)
	movl	-100(%rbp), %eax
	cltq
	salq	$3, %rax
	movq	%rax, %rdi
	call	fftwf_malloc@PLT
	movq	%rax, -40(%rbp)
	movq	-56(%rbp), %rdx
	movq	-56(%rbp), %rsi
	movl	-100(%rbp), %eax
	movl	$0, %r8d
	movl	$-1, %ecx
	movl	%eax, %edi
	call	fftwf_plan_dft_1d@PLT
	movq	%rax, -72(%rbp)
	movq	-56(%rbp), %rdx
	movq	-56(%rbp), %rsi
	movl	-100(%rbp), %eax
	movl	$0, %r8d
	movl	$1, %ecx
	movl	%eax, %edi
	call	fftwf_plan_dft_1d@PLT
	movq	%rax, -64(%rbp)
	movl	$0, -88(%rbp)
	jmp	.L9
.L10:
	movl	-88(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	cvtsi2ss	-88(%rbp), %xmm0
	movss	%xmm0, (%rax)
	movl	-88(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-56(%rbp), %rdx
	addq	%rcx, %rdx
	movss	(%rax), %xmm0
	movss	%xmm0, (%rdx)
	movl	-88(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movss	%xmm0, 4(%rax)
	movl	-88(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-56(%rbp), %rdx
	addq	%rcx, %rdx
	movss	4(%rax), %xmm0
	movss	%xmm0, 4(%rdx)
	movl	-88(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movss	%xmm0, 4(%rax)
	movl	-88(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movss	4(%rax), %xmm0
	movss	%xmm0, (%rdx)
	addl	$1, -88(%rbp)
.L9:
	movl	-88(%rbp), %eax
	cmpl	-100(%rbp), %eax
	jl	.L10
	cvtsi2ss	-100(%rbp), %xmm0
	movss	.LC7(%rip), %xmm1
	divss	%xmm0, %xmm1
	movaps	%xmm1, %xmm0
	movq	-48(%rbp), %rax
	movss	%xmm0, (%rax)
	call	clock@PLT
	movq	%rax, -32(%rbp)
	leaq	-64(%rbp), %rdi
	leaq	-72(%rbp), %rcx
	movl	-100(%rbp), %edx
	movq	-48(%rbp), %rsi
	movq	-56(%rbp), %rax
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	convolve
	call	clock@PLT
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	subq	-32(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC8(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	.LC9(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -16(%rbp)
	pxor	%xmm0, %xmm0
	movss	%xmm0, -84(%rbp)
	pxor	%xmm0, %xmm0
	movss	%xmm0, -76(%rbp)
	movl	$0, -80(%rbp)
	jmp	.L11
.L14:
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movl	-80(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-56(%rbp), %rax
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	error
	movd	%xmm0, %eax
	movl	%eax, -76(%rbp)
	movss	-76(%rbp), %xmm0
	ucomiss	-84(%rbp), %xmm0
	jbe	.L12
	movss	-76(%rbp), %xmm0
	movss	%xmm0, -84(%rbp)
.L12:
	addl	$1, -80(%rbp)
.L11:
	movl	-80(%rbp), %eax
	cmpl	-100(%rbp), %eax
	jl	.L14
	cvtss2sd	-84(%rbp), %xmm0
	leaq	.LC10(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	cmpl	$9, -104(%rbp)
	jne	.L15
	movl	$10, %edi
	call	putchar@PLT
.L15:
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	fftwf_destroy_plan@PLT
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	fftwf_destroy_plan@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	fftwf_free@PLT
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fftwf_free@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	fftwf_free@PLT
	movsd	-16(%rbp), %xmm0
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	execution_time, .-execution_time
	.globl	convolve
	.type	convolve, @function
convolve:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movl	%edx, -36(%rbp)
	movq	%rcx, -48(%rbp)
	movq	%r8, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	-24(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fftwf_execute_dft@PLT
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	-32(%rbp), %rdx
	movq	-32(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fftwf_execute_dft@PLT
	movl	$0, -4(%rbp)
	jmp	.L20
.L21:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	mult_inplace
	addl	$1, -4(%rbp)
.L20:
	movl	-4(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L21
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	-24(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	fftwf_execute_dft@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	convolve, .-convolve
	.globl	mult
	.type	mult, @function
mult:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-16(%rbp), %rax
	movss	(%rax), %xmm1
	movq	-24(%rbp), %rax
	movss	(%rax), %xmm0
	mulss	%xmm1, %xmm0
	movq	-16(%rbp), %rax
	addq	$4, %rax
	movss	(%rax), %xmm2
	movq	-24(%rbp), %rax
	addq	$4, %rax
	movss	(%rax), %xmm1
	mulss	%xmm2, %xmm1
	subss	%xmm1, %xmm0
	movq	-8(%rbp), %rax
	movss	%xmm0, (%rax)
	movq	-16(%rbp), %rax
	movss	(%rax), %xmm1
	movq	-24(%rbp), %rax
	addq	$4, %rax
	movss	(%rax), %xmm0
	mulss	%xmm0, %xmm1
	movq	-16(%rbp), %rax
	addq	$4, %rax
	movss	(%rax), %xmm2
	movq	-24(%rbp), %rax
	movss	(%rax), %xmm0
	mulss	%xmm2, %xmm0
	movq	-8(%rbp), %rax
	addq	$4, %rax
	addss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	mult, .-mult
	.globl	mult_inplace
	.type	mult_inplace, @function
mult_inplace:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	leaq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	mult
	movss	-16(%rbp), %xmm0
	movq	-24(%rbp), %rax
	movss	%xmm0, (%rax)
	movq	-24(%rbp), %rax
	addq	$4, %rax
	movss	-12(%rbp), %xmm0
	movss	%xmm0, (%rax)
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L24
	call	__stack_chk_fail@PLT
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	mult_inplace, .-mult_inplace
	.globl	array_mult_inplace
	.type	array_mult_inplace, @function
array_mult_inplace:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movl	%edx, -52(%rbp)
	movl	$0, -28(%rbp)
	jmp	.L26
.L27:
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	%xmm0, -24(%rbp)
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movss	4(%rax), %xmm0
	movss	%xmm0, -20(%rbp)
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	%xmm0, -16(%rbp)
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movss	4(%rax), %xmm0
	movss	%xmm0, -12(%rbp)
	movss	-24(%rbp), %xmm0
	mulss	-16(%rbp), %xmm0
	movss	-20(%rbp), %xmm1
	mulss	-12(%rbp), %xmm1
	subss	%xmm1, %xmm0
	movss	%xmm0, -8(%rbp)
	movss	-24(%rbp), %xmm0
	movaps	%xmm0, %xmm1
	mulss	-12(%rbp), %xmm1
	movss	-20(%rbp), %xmm0
	mulss	-16(%rbp), %xmm0
	addss	%xmm1, %xmm0
	movss	%xmm0, -4(%rbp)
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movss	-8(%rbp), %xmm0
	movss	%xmm0, (%rax)
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movss	-4(%rbp), %xmm0
	movss	%xmm0, 4(%rax)
	addl	$1, -28(%rbp)
.L26:
	movl	-28(%rbp), %eax
	cmpl	-52(%rbp), %eax
	jl	.L27
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	array_mult_inplace, .-array_mult_inplace
	.globl	error
	.type	error, @function
error:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movss	(%rax), %xmm0
	movq	-32(%rbp), %rax
	movss	(%rax), %xmm1
	subss	%xmm1, %xmm0
	movss	%xmm0, -8(%rbp)
	movq	-24(%rbp), %rax
	addq	$4, %rax
	movss	(%rax), %xmm0
	movq	-32(%rbp), %rax
	addq	$4, %rax
	movss	(%rax), %xmm1
	subss	%xmm1, %xmm0
	movss	%xmm0, -4(%rbp)
	movss	-8(%rbp), %xmm0
	movaps	%xmm0, %xmm1
	mulss	-8(%rbp), %xmm1
	movss	-4(%rbp), %xmm0
	mulss	-4(%rbp), %xmm0
	addss	%xmm1, %xmm0
	call	sqrtf@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	error, .-error
	.section	.rodata
	.align 4
.LC7:
	.long	1065353216
	.align 8
.LC8:
	.long	0
	.long	1083129856
	.align 8
.LC9:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
