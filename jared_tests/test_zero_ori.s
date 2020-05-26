#eyIwIjogODcyNDE1NDg2LCAiMSI6IDQxMjh9

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == 0)

.text

main:
    ori $zero, $zero, 254
    add $v0, $zero, $zero
