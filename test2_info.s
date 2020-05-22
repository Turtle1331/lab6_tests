#asserts
#assert(sim.inspect_mem(d_mem)[10] == 100)
#assert(sim.inspect_mem(d_mem)[20] == 101)
#assert(sim.inspect_mem(d_mem)[9] == 101)
#assert(sim.inspect_mem(d_mem)[19] == 102)
#assert(sim.inspect_mem(d_mem)[8] == 102)
#assert(sim.inspect_mem(d_mem)[18] == 103)
#assert(sim.inspect_mem(d_mem)[7] == 103)
#assert(sim.inspect_mem(d_mem)[17] == 104)
#assert(sim.inspect_mem(d_mem)[6] == 104)
#assert(sim.inspect_mem(d_mem)[16] == 105)
#assert(sim.inspect_mem(d_mem)[5] == 105)
#assert(sim.inspect_mem(d_mem)[15] == 106)
#assert(sim.inspect_mem(d_mem)[4] == 106)
#assert(sim.inspect_mem(d_mem)[14] == 107)
#assert(sim.inspect_mem(d_mem)[3] == 107)
#assert(sim.inspect_mem(d_mem)[13] == 108)
#assert(sim.inspect_mem(d_mem)[2] == 108)
#assert(sim.inspect_mem(d_mem)[12] == 109)
#assert(sim.inspect_mem(d_mem)[1] == 109)
#assert(sim.inspect_mem(d_mem)[11] == 110)
#assert(sim.inspect_mem(rf)[9] == 110)
#assert(sim.inspect_mem(rf)[8] == 0)


10: 100
20: 101
9: 101
19: 102
8: 102
18: 103
7: 103
17:104
6:104
16:105
5: 105
15: 106
4 106
14 107
3 107
13 108
2 108
12 109
1 109
11 110

main: 

addi $t0, $t0, 10
addi $t1, $t1, 100

loop:
beq $t0, $zero, exit
sw $t1, 0($t0)
addi $t1, $t1, 1
sw $t1, 10($t0)

addi $t0, $t0, -1
beq $zero, $zero, loop

exit:
lw $v0, 0($zero)
beq $v0, $v0, exit         

