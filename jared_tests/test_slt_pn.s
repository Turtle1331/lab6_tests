#eyIwIjogMTAwODE0MDI4NywgIjEiOiA5MjAwNDk0ODUsICIyIjogOTIyMTY3NDc1LCAiMyI6IDQ5NzA3MDUwfQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[15] == 0)

.text

main:
    lui $s6, -1
    ori $s6, $s6, -10419
    ori $s7, $s7, 10419
    slt $t7, $s7, $s6
