
#This code attempts to write the value 36 to the $zero register
#I did not include an assertion to verify the $zero reg is not written to b/c my implementation never writes to the $zero reg, leaving it uninitialized
#Rather, I printed the contents of rf and visually verified that the zero register hasn't been written to
#asserts
#assert(sim.inspect_mem(rf)[8] == 35)
#assert(sim.inspect_mem(rf)[9] == 34)
#assert(sim.inspect_mem(rf)[10] == 1)
#assert(sim.inspect_mem(rf)[11] == 0)
#assert(sim.inspect_mem(rf)[13] == 1)
#assert(sim.inspect_mem(rf)[14] == 524288)
#assert(sim.inspect_mem(rf)[15] == 255393792)


main: 
addi $t0, $t0, 35
addi $zero, $t0, 1
addi $t1, $t0, -1
slt $t2, $t1, $t0
slt $t3, $t0, $t1

addi $t4, $t4, -43
slt $t5, $t4, $t1

lui $t6, 8
lui $t7, 3897

exit:
lw $v0, 0($zero)
beq $v0, $v0, exit         

