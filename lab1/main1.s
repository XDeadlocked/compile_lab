	.text
	.file	"main1.c"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$0, -8(%rbp)
	movl	$1, i
	movabsq	$.L.str, %rdi
	movb	$0, %al
	callq	printf@PLT
	movabsq	$.L.str.1, %rdi
	leaq	-4(%rbp), %rsi
	movb	$0, %al
	callq	__isoc99_scanf@PLT
	movl	-4(%rbp), %edi
	callq	print_fibonacci_sequence
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	print_fibonacci_sequence        # -- Begin function print_fibonacci_sequence
	.p2align	4, 0x90
	.type	print_fibonacci_sequence,@function
print_fibonacci_sequence:               # @print_fibonacci_sequence
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -8(%rbp)
	movl	a, %esi
	movl	b, %edx
	movabsq	$.L.str.2, %rdi
	movb	$0, %al
	callq	printf@PLT
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	movl	i, %eax
	cmpl	-8(%rbp), %eax
	jge	.LBB1_3
# %bb.2:                                #   in Loop: Header=BB1_1 Depth=1
	movl	b, %eax
	movl	%eax, -4(%rbp)
	movl	a, %eax
	addl	b, %eax
	movl	%eax, b
	movl	b, %esi
	movabsq	$.L.str.3, %rdi
	movb	$0, %al
	callq	printf@PLT
	movl	-4(%rbp), %eax
	movl	%eax, a
	movl	i, %eax
	addl	$1, %eax
	movl	%eax, i
	jmp	.LBB1_1
.LBB1_3:
	addq	$16, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	print_fibonacci_sequence, .Lfunc_end1-print_fibonacci_sequence
	.cfi_endproc
                                        # -- End function
	.type	a,@object                       # @a
	.bss
	.globl	a
	.p2align	2
a:
	.long	0                               # 0x0
	.size	a, 4

	.type	b,@object                       # @b
	.data
	.globl	b
	.p2align	2
b:
	.long	1                               # 0x1
	.size	b, 4

	.type	i,@object                       # @i
	.bss
	.globl	i
	.p2align	2
i:
	.long	0                               # 0x0
	.size	i, 4

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"\350\257\267\350\276\223\345\205\245\346\226\220\346\263\242\351\202\243\345\245\221\346\225\260\345\210\227\347\232\204\351\241\271\346\225\260\357\274\232"
	.size	.L.str, 40

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"%d"
	.size	.L.str.1, 3

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"%d\n%d\n"
	.size	.L.str.2, 7

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"%d\n"
	.size	.L.str.3, 4

	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
