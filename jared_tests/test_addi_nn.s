#eyIwIjogMTAwNjk2MDYzOSwgIjEiOiA4ODExMzE1MDUsICIyIjogNTQ1NDU2MTExfQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == -32 & 0xFFFFFFFF)

.text

main:
    lui $a0, -1
    ori $a0, $a0, -15
    addi $v0, $a0, -17
