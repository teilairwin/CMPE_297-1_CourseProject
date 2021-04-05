start:
	addi	$t1, $0, 6001
	addi	$t2, $0, 7002
	addi	$t3, $0, 8003
	sw	$t1, 0x0($0)	#Write data to dMem (0x000 -)
	sw	$t2, 0xC($0)
	sw	$t3, 0x1C($0)
	lw	$s0, 0x0($0)	#Read data back from dMem
	lw	$s1, 0xC($0)
	lw	$s2, 0x1C($0)
loop:
	nop
	nop
	j loop
	
	