#eyIwIjogODgxMDY1OTk5LCAiMSI6IDU0NTQ1NjExMX0=

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[2] == -2 & 0xFFFFFFFF)

.text

main:
    ori $a0, $a0, 15
    addi $v0, $a0, -17
