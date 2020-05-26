#eyIwIjogODcyNjc3NjMwLCAiMSI6IDI2ODc2MzEzNCwgIjIiOiA4NzI2Nzc1OTAsICIzIjogMjY4NTAwOTkwfQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[4] == 214)

.text

main:
    ori $a0, $zero, 254
    beq $zero, $a0, main

exit:
    ori $a0, $zero, 214
    beq $zero, $zero, exit
