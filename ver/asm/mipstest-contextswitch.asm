ISR0:   addi $t0, $0, 100
	addi $t1, $0, 101
	addi $t2, $0, 102
	nop
	nop
	nop
	nop
	nop
ISR1:	addi $t3, $t3, 200
	addi $t4, $t4, 201
	addi $t5, $t5, 202
	nop
	nop
	nop
	nop
	nop
ISR2:	addi $t6, $t6, 300
	addi $t7, $t7, 301
	addi $t8, $t8, 302
	nop
	nop
	nop
	nop
	nop
ISR3:	addi $t9, $0, 400
	nop
	nop
	j ISR3
	nop
	nop
	nop
	nop
	 	