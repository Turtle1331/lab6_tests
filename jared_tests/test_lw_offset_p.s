#eyIwIjogODcyOTM5NjI4LCAiMSI6IDg3MzAwNTE2MCwgIjIiOiA1Mzc5MTk1MDUsICIzIjogMjkwMzUwNjk0NCwgIjQiOiAyMzY3ODE1Njg0fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == 17)

.text

main:
    ori $t0, $zero, 108
    ori $t1, $zero, 104
    addi $s0, $zero, 17
    sw $s0, 0($t0)
    lw $v0, 4($t1)
