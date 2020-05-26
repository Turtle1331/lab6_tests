#eyIwIjogNTM4MzAyMjg1fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(rf)[21] == -10419 & 0xFFFFFFFF)

.text

main:
    addi $s5, $zero, -10419 
