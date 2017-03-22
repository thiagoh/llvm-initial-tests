	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_foo
	.p2align	4, 0x90
_foo:                                   ## @foo
	.cfi_startproc
## BB#0:                                ## %entry
	movapd	%xmm1, %xmm2
	mulsd	%xmm2, %xmm2
	mulsd	%xmm1, %xmm2
	addsd	%xmm2, %xmm0
	retq
	.cfi_endproc

	.section	__TEXT,__literal8,8byte_literals
	.p2align	3
LCPI1_0:
	.quad	4607182418800017408     ## double 1
LCPI1_1:
	.quad	4611686018427387904     ## double 2
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rax
Lcfi0:
	.cfi_def_cfa_offset 16
	movsd	LCPI1_0(%rip), %xmm0    ## xmm0 = mem[0],zero
	movsd	LCPI1_1(%rip), %xmm1    ## xmm1 = mem[0],zero
	callq	_foo
	callq	_putchar
	popq	%rax
	retq
	.cfi_endproc


.subsections_via_symbols
