#asserts
#assert(sim.inspect_mem(rf)[8] == 15)
#assert(sim.inspect_mem(rf)[9] == -3 & 0xFFFFFFFF)  
#assert(sim.inspect_mem(rf)[10] == 12) 
#assert(sim.inspect_mem(rf)[11] == 15)
#assert(sim.inspect_mem(rf)[13] == 8)

main: 
addi $t0, $t0, 15
addi $t1, $t1, -3

add $t2, $t0, $t1
ori $t3, $t2, 3

addi $t5, $t5, 273864
and $t6, $t5, $t3

exit:
lw $v0, 0($zero)
beq $v0, $v0, exit         