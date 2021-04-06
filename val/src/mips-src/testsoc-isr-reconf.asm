start:	addi	$t0, $0, 0x0	#ISR0 @ 0x0
	sw	$t0, 0x2000($0)
	addi	$t0, $0, 0x20	#ISR1 @ 0x20
	sw	$t0, 0x2004($0)
	addi	$t0, $0, 5	#N=5
	addi	$t1, $0, 1	#Go
	addi	$t2, $0, 0	#t2=0
	#request the factorial
	sw	$t0, 0x3000($0)  #N
	sw	$t1, 0x3004($0)  #GO
	#do something else
	addi	$t3, $0, 20
wait:	beq	$t3, $t2, end
	addi	$t2, $t2, 1
	j wait
end:	lw	$a0, 0x3008($0)
	lw	$a1, 0x300C($0)
	#Reconfigure ISR0 to 0x40
	addi	$t0, $0, 0x40
	sw	$t0, 0x2000($0)
	addi	$t0, $0, 4
	#request another factorial
	sw	$t0, 0x3000($0)  #N
	sw	$t1, 0x3004($0)  #GO
	#do something else
	addi	$t2, $0, 5
wait2:	beq	$t3, $t2, end2
	addi $t2, $t2, 1
	j wait2
end2:	lw	$a2, 0x3008($0)
	lw	$a3, 0x300C($0)
loop:	nop
	j loop
	

	
