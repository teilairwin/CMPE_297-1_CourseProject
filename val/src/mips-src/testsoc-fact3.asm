start:
	addi	$t0, $0, 0x0	#ISR0 @ 0x0
	sw	$t0, 0x2000($0)
	addi	$t0, $0, 0x20	#ISR1 @ 0x20
	sw	$t0, 0x2004($0)
	addi	$t0, $0, 0x40	#ISR1 @ 0x40
	sw	$t0, 0x2008($0)
	addi	$t0, $0, 0x60	#ISR1 @ 0x60
	sw	$t0, 0x200C($0)
	addi	$t0, $0, 8	#N=5
	addi	$t1, $0, 1	#Go
	addi	$t2, $0, 0	#t2=0
	#request the factorial
	sw	$t0, 0x6000($0)  #N
	sw	$t1, 0x6004($0)  #GO
	#do something else
	addi	$t3, $0, 20
wait:	beq	$t3, $t2, end
	addi	$t2, $t2, 1
	j wait
end:	lw	$t4, 0x6008($0)
	lw	$t5, 0x600C($0)
loop:	nop
	nop
	j loop
	

	
