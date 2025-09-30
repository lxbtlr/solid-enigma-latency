  .global gadget_start
gadget_start:
  .align 64
  .global rail_1
  .global rail_2
  
//RAIL 1
rail_1:
rail_1_0:
  jmp . // Jump in place 
  MOVW $0x00eb,rail_2_0(%rip) # Stop rail_2 from jumping in place
rail_1_1:
   jmp . // Jump in place 
   MOVW $0x00eb,rail_2_1(%rip) # Stop rail_2 from jumping in place
rail_1_2:
   jmp . // Jump in place 
   MOVW $0x00eb,rail_2_2(%rip) # Stop rail_2 from jumping in place

rail_1_bottom:
    jmp footer

  .global gadget_entry
gadget_entry:
    MOVW $0x00eb,rail_1_0(%rip) # Stop rail_2 from jumping in place
rail_2:
rail_2_0:
  jmp . // Jump in place 
    MOVW $0x00eb,rail_1_1(%rip) # Stop rail_2 from jumping in place
rail_2_1:
    jmp . // Jump in place 
    MOVW $0x00eb,rail_1_2(%rip) # Stop rail_2 from jumping in place
rail_2_2:
    jmp . // Jump in place 

rail_2_bottom:
    jmp footer

footer:
    ret
  .global gadget_end
gadget_end:

