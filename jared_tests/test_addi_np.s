#eyIwIjogMTAwNjk2MDYzOSwgIjEiOiA4ODExMzE1MDUsICIyIjogNTQ1MzkwNjA5fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == 2)

.text

main:
    lui $a0, -1
    ori $a0, $a0, -15
    addi $v0, $a0, 17
