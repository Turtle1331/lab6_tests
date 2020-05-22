#asserts
#assert(sim.inspect_mem(d_mem)[330] == 5)
#assert(sim.inspect_mem(d_mem)[365] == 355)
#assert(sim.inspect_mem(d_mem)[15] == 28)
#assert(sim.inspect_mem(rf)[16] == 350)
#assert(sim.inspect_mem(rf)[17] == 5)
#assert(sim.inspect_mem(rf)[18] == 355)
#assert(sim.inspect_mem(rf)[8] == 28)
#assert(sim.inspect_mem(rf)[10] == 28)
#assert(sim.inspect_mem(rf)[12] == 355)
#assert(sim.inspect_mem(rf)[13] == 5)

main: 

addi $s0, $s0, 350
addi $s1, $s1, 5
sw $s1, -20($s0)

add $s2, $s1, $s0
sw $s2, 10($s2)

addi $t0, $s0, -322
sw $t0, 10($s1)

addi $t1, $t1, 4
lw $t2, 11($t1)

addi $t3, $t3, 365
lw $t4, 0($t3)

lw $t5, -20($s0)

exit:
lw $v0, 0($zero)
beq $v0, $v0, exit         
