#eyIwIjogODcyOTM5NjI0LCAiMSI6IDUzNzk4NTAxNSwgIjIiOiAyOTAzNTcyNDc4fQ==

# DO NOT DELETE THE ABOVE BASE64 LINE. IT IS USED TO LOAD INSTRUCTIONS

#assert(sim.inspect_mem(d_mem)[0x66] == -9 & 0xFFFFFFFF)

.text

main:
    ori $t0, $zero, 104
    addi $s0, $zero, -9
    sw $s0, -2($t0)
