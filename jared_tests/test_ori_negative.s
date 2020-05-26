#eyIwIjogODczODQ2NjA1fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[21] == 55117)

.text

main:
    ori $s5, $zero, -10419 
    # equivalent to: ori $s5, $zero, 55117
