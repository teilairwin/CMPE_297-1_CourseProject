isr0:	lw	$t7, 0x3008($0)
	addi	$t8, $0, 1
	and	$t8, $t7, $t8
	beq	$t8, $0, exit0
	addi	$s0, $t7, 0
	lw	$s1, 0x300C($0)
exit0:	nop
	nop
isr1:	lw	$t7, 0x4008($0)
	addi	$t8, $0, 1
	and	$t8, $t7, $t8
	beq	$t8, $0, exit1
	addi	$s2, $t7, 0
	lw	$s3, 0x400C($0)
exit1:	nop
	nop
isr2:	lw	$t7, 0x3008($0)
	addi	$t8, $0, 1
	and	$t8, $t7, $t8
	beq	$t8, $0, exit2
	addi	$s4, $t7, 0
	lw	$s5, 0x300C($0)
exit2:	nop
	nop	
isr3:	lw	$t7, 0x6008($0)
	addi	$t8, $0, 1
	and	$t8, $t7, $t8
	beq	$t8, $0, exit3
	addi	$s6, $t7, 0
	lw	$s7, 0x600C($0)
exit3:	nop
	nop
