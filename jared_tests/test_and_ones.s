#eyIwIjogNTM3MTk4Mzc4LCAiMSI6IDUzNzI2NDEyNywgIjIiOiA4NzIwNDIwfQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == -214 & 0xFFFFFFFF)

.text

main:
    addi $a0, $zero, -214
    addi $a1, $zero, -1
    and $v0, $a0, $a1
