#eyIwIjogODcyOTM5NjIwLCAiMSI6IDg3MzAwNTE2MCwgIjIiOiA1Mzc5ODUwMDcsICIzIjogMjkwMzUwNjk0NCwgIjQiOiAyMzY3ODgxMjEyfQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == -17 & 0xFFFFFFFF)

.text

main:
    ori $t0, $zero, 100
    ori $t1, $zero, 104
    addi $s0, $zero, -17
    sw $s0, 0($t0)
    lw $v0, -4($t1)
