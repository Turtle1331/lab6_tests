#eyIwIjogNTM3MTk3OTYyLCAiMSI6IDg3MjQxNTIzMiwgIjIiOiA4NzIwNDIwfQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == 0)

.text

main:
    addi $a0, $zero, -630
    ori $a1, $zero, $zero
    and $v0, $a0, $a1
