#eyIwIjogODcyOTM5NjI0LCAiMSI6IDg3MzQ2MzgxNywgIjIiOiAyOTAzNTA2OTQ2fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(d_mem)[0x6A] == 9)

.text

main:
    ori $t0, $zero, 104
    ori $s0, $zero, 9
    sw $s0, 2($t0)
