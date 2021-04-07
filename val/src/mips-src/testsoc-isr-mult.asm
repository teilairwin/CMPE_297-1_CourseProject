start:	addi	$t0, $0, 0x0	#ISR0 @ 0x0
	sw	$t0, 0x2000($0)
	addi	$t0, $0, 0x20	#ISR1 @ 0x20
	sw	$t0, 0x2004($0)
	addi	$t0, $0, 5	#N=5
	addi	$t1, $0, 1	#Go
	addi	$t2, $0, 0	#t2=0
	addi 	$t3, $0, 6      #N=6
	#request the factorial
	sw	$t0, 0x3000($0)  #N-5 fact0
	sw	$t3, 0x4000($0)  #N-6 fact1
	sw	$t1, 0x3004($0)  #GO fact0
	sw	$t1, 0x4004($0)  #GO fact1
	#do something else
	addi	$t3, $0, 20
wait:	beq	$t3, $t2, end
	addi	$t2, $t2, 1
	j wait
end:	lw	$a0, 0x3008($0) #done fact0
	lw	$a1, 0x300C($0) #res  fact0
	lw	$a2, 0x4008($0) #done fact1
	lw	$a3, 0x400C($0) #res  fact1
loop:	nop
	j loop
	

	
