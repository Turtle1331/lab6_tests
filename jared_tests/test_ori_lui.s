#eyIwIjogODczNTM5NzYzLCAiMSI6IDEwMDc4MDExODN9

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

.text

#assert(sim.inspect_mem(rf)[17] == 3546218496)

main:
    ori $s1, $zero, 10419
    lui $s1, 54111
