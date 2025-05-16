  .global gadget_start
gadget_start:
  .align 64
  .global gadget_patch1
gadget_patch1:
maine:
  jmp .
 

  MOVW $0x00eb,gadget_patch2(%rip) # 0x0(%rax)
newyork:
  jmp .

  MOVW $0x00eb,gadget_patch2(%rip) # 0x0(%rax)
  
  jmp maine
  
  jmp done

  .global gadget_entry
gadget_entry:
# entrypoint for stopclock

  MOVW $0x00eb,gadget_patch1(%rip) # 0x0(%rax)

loop2:
  .align 64
  .global gadget_patch2
gadget_patch2:
  jmp .
  jmp done

done:

  ret
  .global gadget_end
gadget_end:
