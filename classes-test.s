	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_c_puts
	.p2align	4, 0x90
_c_puts:                                ## @c_puts
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	callq	_puts
	xorps	%xmm0, %xmm0
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_c_puti
	.p2align	4, 0x90
_c_puti:                                ## @c_puti
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi3:
	.cfi_def_cfa_offset 16
Lcfi4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi5:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, %ecx
	movl	%ecx, -4(%rbp)
	leaq	L_.str(%rip), %rdi
	xorl	%eax, %eax
	movl	%ecx, %esi
	callq	_printf
	xorps	%xmm0, %xmm0
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_c_putd
	.p2align	4, 0x90
_c_putd:                                ## @c_putd
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi6:
	.cfi_def_cfa_offset 16
Lcfi7:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi8:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	leaq	L_.str.1(%rip), %rdi
	movb	$1, %al
	callq	_printf
	xorps	%xmm0, %xmm0
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__Z9do_loop_1R6Person
	.p2align	4, 0x90
__Z9do_loop_1R6Person:                  ## @_Z9do_loop_1R6Person
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi9:
	.cfi_def_cfa_offset 16
Lcfi10:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi11:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)
	movl	$0, -4(%rbp)
	cmpl	$2, -4(%rbp)
	jg	LBB3_3
	.p2align	4, 0x90
LBB3_2:                                 ## %for.body
                                        ## =>This Inner Loop Header: Depth=1
	movq	-16(%rbp), %rdi
	callq	__ZN6Person6getAgeEv
	movl	%eax, %edi
	callq	_c_puti
	incl	-4(%rbp)
	cmpl	$2, -4(%rbp)
	jle	LBB3_2
LBB3_3:                                 ## %for.end
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__ZN6Person6getAgeEv
	.weak_definition	__ZN6Person6getAgeEv
	.p2align	4, 0x90
__ZN6Person6getAgeEv:                   ## @_ZN6Person6getAgeEv
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi12:
	.cfi_def_cfa_offset 16
Lcfi13:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi14:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movl	(%rdi), %eax
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__literal8,8byte_literals
	.p2align	3
LCPI5_0:
	.quad	4619567317775286272     ## double 7
LCPI5_1:
	.quad	4607182418800017408     ## double 1
	.section	__TEXT,__text,regular,pure_instructions
	.globl	__Z9do_loop_2R6Person
	.p2align	4, 0x90
__Z9do_loop_2R6Person:                  ## @_Z9do_loop_2R6Person
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi15:
	.cfi_def_cfa_offset 16
Lcfi16:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi17:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)
	movq	$0, -8(%rbp)
	jmp	LBB5_1
	.p2align	4, 0x90
LBB5_2:                                 ## %for.body
                                        ##   in Loop: Header=BB5_1 Depth=1
	movq	-16(%rbp), %rdi
	callq	__ZN6Person6getAgeEv
	movl	%eax, %edi
	callq	_c_puti
	movsd	-8(%rbp), %xmm0         ## xmm0 = mem[0],zero
	addsd	LCPI5_1(%rip), %xmm0
	movsd	%xmm0, -8(%rbp)
LBB5_1:                                 ## %for.cond
                                        ## =>This Inner Loop Header: Depth=1
	movsd	LCPI5_0(%rip), %xmm0    ## xmm0 = mem[0],zero
	ucomisd	-8(%rbp), %xmm0
	ja	LBB5_2
## BB#3:                                ## %for.end
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi18:
	.cfi_def_cfa_offset 16
Lcfi19:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi20:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	subq	$56, %rsp
Lcfi21:
	.cfi_offset %rbx, -24
	movl	$0, -12(%rbp)
	leaq	-48(%rbp), %rbx
	movl	$34, %esi
	movq	%rbx, %rdi
	callq	__ZN6PersonC1Ei
	movq	%rbx, %rdi
	callq	__Z9do_loop_1R6Person
	movq	%rbx, %rdi
	callq	__Z9do_loop_2R6Person
	movq	%rbx, %rdi
	callq	__ZN6Person17getChildrenAgeAVGEv
	callq	_c_putd
	movq	%rbx, %rdi
	callq	__ZN6Person7getNameEv
	movq	%rax, %rdi
	callq	_c_puts
	movq	%rbx, %rdi
	callq	__ZN6Person4getZEv
	movq	%rbx, %rdi
	callq	__ZN6Person7getNameEv
	xorl	%eax, %eax
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__ZN6PersonC1Ei
	.weak_def_can_be_hidden	__ZN6PersonC1Ei
	.p2align	4, 0x90
__ZN6PersonC1Ei:                        ## @_ZN6PersonC1Ei
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi22:
	.cfi_def_cfa_offset 16
Lcfi23:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi24:
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rdi
	callq	__ZN6PersonC2Ei
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__ZN6Person17getChildrenAgeAVGEv
	.weak_definition	__ZN6Person17getChildrenAgeAVGEv
	.p2align	4, 0x90
__ZN6Person17getChildrenAgeAVGEv:       ## @_ZN6Person17getChildrenAgeAVGEv
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi25:
	.cfi_def_cfa_offset 16
Lcfi26:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi27:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movsd	8(%rdi), %xmm0          ## xmm0 = mem[0],zero
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__ZN6Person7getNameEv
	.weak_definition	__ZN6Person7getNameEv
	.p2align	4, 0x90
__ZN6Person7getNameEv:                  ## @_ZN6Person7getNameEv
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi28:
	.cfi_def_cfa_offset 16
Lcfi29:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi30:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	16(%rdi), %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__ZN6Person4getZEv
	.weak_definition	__ZN6Person4getZEv
	.p2align	4, 0x90
__ZN6Person4getZEv:                     ## @_ZN6Person4getZEv
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi31:
	.cfi_def_cfa_offset 16
Lcfi32:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi33:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movl	24(%rdi), %eax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	__ZN6PersonC2Ei
	.weak_def_can_be_hidden	__ZN6PersonC2Ei
	.p2align	4, 0x90
__ZN6PersonC2Ei:                        ## @_ZN6PersonC2Ei
	.cfi_startproc
## BB#0:                                ## %entry
	pushq	%rbp
Lcfi34:
	.cfi_def_cfa_offset 16
Lcfi35:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi36:
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movl	%esi, (%rax)
	movabsq	$4614388178203810202, %rcx ## imm = 0x400999999999999A
	movq	%rcx, 8(%rax)
	leaq	L_.str.2(%rip), %rcx
	movq	%rcx, 16(%rax)
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"

L_.str.1:                               ## @.str.1
	.asciz	"%f\n"

L_.str.2:                               ## @.str.2
	.asciz	"foo bar baz quux"


.subsections_via_symbols
