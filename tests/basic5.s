	.file	"basic5.tt.bc"
	.text
	.globl	doStuff
	.align	16, 0x90
	.type	doStuff,@function
doStuff:                                # @doStuff
	.cfi_startproc
# BB#0:                                 # %entry
	movb	param_taint(%rip), %al
	movb	%al, return_taint1(%rip)
	movl	%edi, %eax
	ret
.Ltmp0:
	.size	doStuff, .Ltmp0-doStuff
	.cfi_endproc

	.globl	main
	.align	16, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:                                 # %entry
	pushq	%rax
.Ltmp2:
	.cfi_def_cfa_offset 16
	xorl	%edi, %edi
	callq	time
	movl	%eax, %edi
	callq	srand
	callq	rand
	xorb	%cl, %cl
	testb	%cl, %cl
	jne	.LBB1_6
# BB#1:                                 # %cont_BB
	movl	%eax, %ecx
	shrl	$31, %ecx
	addl	%eax, %ecx
	andl	$-2, %ecx
	movl	%eax, %edx
	subl	%ecx, %edx
	testl	%edx, %edx
	je	.LBB1_4
# BB#2:                                 # %if.then
	movb	$1, %cl
	testb	%cl, %cl
	je	.LBB1_3
	.align	16, 0x90
.LBB1_6:                                # %abortBB
                                        # =>This Inner Loop Header: Depth=1
	movl	$.L.str2, %edi
	xorb	%al, %al
	callq	printf
	movl	$1, %edi
	callq	exit
	jmp	.LBB1_6
.LBB1_4:                                # %if.else
	incl	%eax
	movb	$1, %cl
	jmp	.LBB1_5
.LBB1_3:                                # %cont_BB2
	movb	$1, param_taint(%rip)
	movl	%eax, %edi
	callq	doStuff
	movb	return_taint1(%rip), %cl
.LBB1_5:                                # %if.end
	andb	$1, %cl
	movb	%cl, return_taint(%rip)
	popq	%rdx
	ret
.Ltmp3:
	.size	main, .Ltmp3-main
	.cfi_endproc

	.type	return_taint,@object    # @return_taint
	.bss
	.globl	return_taint
return_taint:
	.byte	0                       # 0x0
	.size	return_taint, 1

	.type	return_taint1,@object   # @return_taint1
	.globl	return_taint1
return_taint1:
	.byte	0                       # 0x0
	.size	return_taint1, 1

	.type	param_taint,@object     # @param_taint
	.globl	param_taint
param_taint:
	.byte	0                       # 0x0
	.size	param_taint, 1

	.type	.L.str,@object          # @.str
	.section	.rodata,"a",@progbits
.L.str:
	.asciz	 "Warning: tainted data in use!\n"
	.size	.L.str, 31

	.type	.L.str2,@object         # @.str2
.L.str2:
	.asciz	 "Warning: tainted data in use!\n"
	.size	.L.str2, 31


	.section	".note.GNU-stack","",@progbits
