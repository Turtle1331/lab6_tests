#eyIwIjogNTM3MTk4Mzc4LCAiMSI6IDUzNzI2NDAyNCwgIjIiOiA4NzIwNDE2fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == -318 & 0xFFFFFFFF)

.text

main:
    addi $a0, $zero, -214
    addi $a1, $zero, -104
    add $v0, $a0, $a1
