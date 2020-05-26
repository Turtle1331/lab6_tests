#eyIwIjogMTAwNzgwMTE4MywgIjEiOiA5MDkxOTEzNDd9

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[17] == 3546228915)

.text

main:
    lui $s1, 54111
    ori $s1, $s1, 10419
