#eyIwIjogODcyNjc3NDgwLCAiMSI6IDI2ODUwMDk5MCwgIjIiOiA4NzI2Nzc2MzB9

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[4] == 104)

.text

main:
    ori $a0, $zero, 104
    beq $zero, $zero, main
    ori $a0, $zero, 254
