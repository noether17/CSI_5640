	.file	"perf_test.c"
	.text
	.section	.rodata
.LC0:
	.string	"w"
.LC1:
	.string	"output.txt"
	.align 8
.LC2:
	.string	"## First column is number of threads, following are times in milliseconds\n"
.LC3:
	.string	"## Array size = %d\n"
.LC4:
	.string	"%d"
.LC5:
	.string	" %f"
	.text
	.globl	main
	.type	main, @function
main:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	leaq	.LC0(%rip), %rsi
	leaq	.LC1(%rip), %rdi
	call	fopen@PLT
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rcx
	movl	$74, %edx
	movl	$1, %esi
	leaq	.LC2(%rip), %rdi
	call	fwrite@PLT
	movl	$1024, -20(%rbp)
	jmp	.L2
.L7:
	movl	-20(%rbp), %edx
	movq	-8(%rbp), %rax
	leaq	.LC3(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$1, -16(%rbp)
	jmp	.L3
.L6:
	movl	-16(%rbp), %edx
	movq	-8(%rbp), %rax
	leaq	.LC4(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf@PLT
	movl	$0, -12(%rbp)
	jmp	.L4
.L5:
	movl	-12(%rbp), %edx
	movl	-16(%rbp), %ecx
	movl	-20(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	execution_time
	movq	-8(%rbp), %rax
	leaq	.LC5(%rip), %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	addl	$1, -12(%rbp)
.L4:
	cmpl	$9, -12(%rbp)
	jle	.L5
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$10, %edi
	call	fputc@PLT
	addl	$1, -16(%rbp)
.L3:
	cmpl	$16, -16(%rbp)
	jle	.L6
	sall	-20(%rbp)
.L2:
	cmpl	$268435456, -20(%rbp)
	jle	.L7
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC13:
	.string	"Starting trial run with %d array elements\n"
.LC14:
	.string	"%d threads - "
.LC15:
	.string	"max error: %f; "
	.text
	.globl	execution_time
	.type	execution_time, @function
execution_time:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movl	%edi, -68(%rbp)
	movl	%esi, -72(%rbp)
	movl	%edx, -76(%rbp)
	movl	-68(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -48(%rbp)
	movl	-68(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -40(%rbp)
	movl	-68(%rbp), %eax
	cltq
	salq	$2, %rax
	movq	%rax, %rdi
	call	malloc@PLT
	movq	%rax, -32(%rbp)
	movl	$0, -64(%rbp)
	jmp	.L10
.L11:
	movl	-64(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movss	.LC6(%rip), %xmm0
	movss	%xmm0, (%rax)
	movl	-64(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movss	.LC7(%rip), %xmm0
	movss	%xmm0, (%rax)
	movl	-64(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	pxor	%xmm0, %xmm0
	movss	%xmm0, (%rax)
	addl	$1, -64(%rbp)
.L10:
	movl	-64(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L11
	call	clock@PLT
	movq	%rax, -24(%rbp)
	movl	-72(%rbp), %edi
	movl	-68(%rbp), %ecx
	movq	-40(%rbp), %rdx
	movq	-48(%rbp), %rsi
	movq	-32(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	array_mult
	call	clock@PLT
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	subq	-24(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC9(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	.LC10(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	pxor	%xmm0, %xmm0
	movss	%xmm0, -60(%rbp)
	pxor	%xmm0, %xmm0
	movss	%xmm0, -52(%rbp)
	movl	$0, -56(%rbp)
	jmp	.L12
.L15:
	movl	-56(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movss	.LC11(%rip), %xmm1
	subss	%xmm1, %xmm0
	movss	.LC12(%rip), %xmm1
	andps	%xmm1, %xmm0
	movss	%xmm0, -52(%rbp)
	movss	-52(%rbp), %xmm0
	ucomiss	-60(%rbp), %xmm0
	jbe	.L13
	movss	-52(%rbp), %xmm0
	movss	%xmm0, -60(%rbp)
.L13:
	addl	$1, -56(%rbp)
.L12:
	movl	-56(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jl	.L15
	cmpl	$1, -72(%rbp)
	jne	.L16
	cmpl	$0, -76(%rbp)
	jne	.L16
	movl	-68(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC13(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L16:
	cmpl	$0, -76(%rbp)
	jne	.L17
	movl	-72(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC14(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
.L17:
	cvtss2sd	-60(%rbp), %xmm0
	leaq	.LC15(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	cmpl	$9, -76(%rbp)
	jne	.L18
	movl	$10, %edi
	call	putchar@PLT
.L18:
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	free@PLT
	movsd	-8(%rbp), %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	execution_time, .-execution_time
	.globl	array_mult
	.type	array_mult, @function
array_mult:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$144, %rsp
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%rdx, -120(%rbp)
	movl	%ecx, -124(%rbp)
	movl	%r8d, -128(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -40(%rbp)
	xorl	%eax, %eax
	movq	%rsp, %rax
	movq	%rax, %rbx
	movl	-128(%rbp), %edx
	movslq	%edx, %rax
	subq	$1, %rax
	movq	%rax, -80(%rbp)
	movslq	%edx, %rax
	movq	%rax, -144(%rbp)
	movq	$0, -136(%rbp)
	movslq	%edx, %rax
	movq	%rax, -160(%rbp)
	movq	$0, -152(%rbp)
	movslq	%edx, %rax
	salq	$3, %rax
	leaq	7(%rax), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %edi
	movl	$0, %edx
	divq	%rdi
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -88(%rbp)
	movl	-128(%rbp), %eax
	movslq	%eax, %rdx
	subq	$1, %rdx
	movq	%rdx, -72(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, -176(%rbp)
	movq	$0, -168(%rbp)
	movslq	%eax, %rdx
	movq	%rdx, %r13
	movl	$0, %r14d
	cltq
	salq	$3, %rax
	leaq	7(%rax), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %edi
	movl	$0, %edx
	divq	%rdi
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -64(%rbp)
	movl	-128(%rbp), %ecx
	movslq	%ecx, %rax
	subq	$1, %rax
	movq	%rax, -56(%rbp)
	movslq	%ecx, %rax
	movq	%rax, %r11
	movl	$0, %r12d
	imulq	$320, %r12, %rdx
	imulq	$0, %r11, %rax
	leaq	(%rdx,%rax), %rsi
	movl	$320, %eax
	mulq	%r11
	addq	%rdx, %rsi
	movq	%rsi, %rdx
	movslq	%ecx, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movslq	%ecx, %rax
	movq	%rax, %r9
	movl	$0, %r10d
	imulq	$320, %r10, %rdx
	imulq	$0, %r9, %rax
	leaq	(%rdx,%rax), %rsi
	movl	$320, %eax
	mulq	%r9
	addq	%rdx, %rsi
	movq	%rsi, %rdx
	movslq	%ecx, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	leaq	7(%rax), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %edi
	movl	$0, %edx
	divq	%rdi
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$7, %rax
	shrq	$3, %rax
	salq	$3, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	-104(%rbp), %r8
	movq	-120(%rbp), %rdi
	movq	-112(%rbp), %rcx
	movl	-128(%rbp), %edx
	movl	-124(%rbp), %esi
	movq	%r8, %r9
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	assign_wl_cont
	movl	$0, -92(%rbp)
	jmp	.L22
.L23:
	movq	-48(%rbp), %rcx
	movl	-92(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	leaq	(%rcx,%rax), %rdx
	movq	-88(%rbp), %rax
	movl	-92(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$3, %rcx
	addq	%rcx, %rax
	movq	%rdx, %rcx
	leaq	mult_func(%rip), %rdx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	addl	$1, -92(%rbp)
.L22:
	movl	-92(%rbp), %eax
	cmpl	-128(%rbp), %eax
	jl	.L23
	movl	$0, -96(%rbp)
	jmp	.L24
.L25:
	movq	-64(%rbp), %rax
	movl	-96(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	leaq	(%rax,%rdx), %rcx
	movq	-88(%rbp), %rax
	movl	-96(%rbp), %edx
	movslq	%edx, %rdx
	movq	(%rax,%rdx,8), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	pthread_join@PLT
	addl	$1, -96(%rbp)
.L24:
	movl	-96(%rbp), %eax
	cmpl	-128(%rbp), %eax
	jl	.L25
	movq	%rbx, %rsp
	nop
	movq	-40(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L26
	call	__stack_chk_fail@PLT
.L26:
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	array_mult, .-array_mult
	.globl	assign_wl_cont
	.type	assign_wl_cont, @function
assign_wl_cont:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movq	%rcx, -40(%rbp)
	movq	%r8, -48(%rbp)
	movq	%r9, -56(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L28
.L30:
	movl	-28(%rbp), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	subl	$1, %eax
	cltd
	idivl	-32(%rbp)
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	cmpl	%eax, -28(%rbp)
	jge	.L29
	movl	-28(%rbp), %eax
	subl	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
.L29:
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	movl	%eax, 4(%rdx)
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	$1, 8(%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, 16(%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, 24(%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, 32(%rax)
	addl	$1, -12(%rbp)
.L28:
	movl	-12(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jl	.L30
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	assign_wl_cont, .-assign_wl_cont
	.globl	assign_wl_strided
	.type	assign_wl_strided, @function
assign_wl_strided:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movq	%rcx, -40(%rbp)
	movq	%r8, -48(%rbp)
	movq	%r9, -56(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L32
.L33:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movl	%eax, (%rdx)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-28(%rbp), %eax
	subl	-4(%rbp), %eax
	movl	%eax, 4(%rdx)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-32(%rbp), %eax
	movl	%eax, 8(%rdx)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-40(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, 16(%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-48(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, 24(%rax)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	-56(%rbp), %rdx
	addq	%rcx, %rdx
	movq	%rdx, 32(%rax)
	addl	$1, -4(%rbp)
.L32:
	movl	-4(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jl	.L33
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	assign_wl_strided, .-assign_wl_strided
	.globl	mult_func
	.type	mult_func, @function
mult_func:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -72(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	-72(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	$0, -48(%rbp)
	movq	$1, -40(%rbp)
	movl	$0, -60(%rbp)
	jmp	.L35
.L36:
	movq	-56(%rbp), %rax
	movq	16(%rax), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm1
	movq	-56(%rbp), %rax
	movq	24(%rax), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movss	(%rax), %xmm0
	movq	-56(%rbp), %rax
	movq	32(%rax), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	mulss	%xmm1, %xmm0
	movss	%xmm0, (%rax)
	leaq	-32(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	nanosleep@PLT
	movq	-56(%rbp), %rax
	movl	8(%rax), %eax
	addl	%eax, -60(%rbp)
.L35:
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -60(%rbp)
	jl	.L36
	nop
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L37
	call	__stack_chk_fail@PLT
.L37:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	mult_func, .-mult_func
	.section	.rodata
	.align 4
.LC6:
	.long	1073741824
	.align 4
.LC7:
	.long	1082130432
	.align 8
.LC9:
	.long	0
	.long	1083129856
	.align 8
.LC10:
	.long	0
	.long	1093567616
	.align 4
.LC11:
	.long	1090519040
	.align 16
.LC12:
	.long	2147483647
	.long	0
	.long	0
	.long	0
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
