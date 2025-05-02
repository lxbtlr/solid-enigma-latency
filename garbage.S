  .global gadget_start
gadget_start:
  .align 64
  .global gadget_patch1
gadget_patch1:
1:
  jmp .
  nop
  nop
  nop
  nop
  nop
  nop
  nop

  #lea loop2(%rip), %rax
  #MOVL $0x90909090,loop2(%rip) # 0x0(%rax)
  #MOVABS $0x
  
  MOVW $0x00eb,gadget_patch2(%rip) # 0x0(%rax)


  # MOVABS $0x9090909090909090, %rdi 
  # MOVQ %rdi,gadget_patch2(%rip) # 0x0(%rax)


  #MOVW $0x9090,gadget_patch2 # 0x0(%rax)
  jmp done

  .global gadget_entry
gadget_entry:
# entrypoint for stopclock
  #lea loop1(%rip), %rax
  #MOVL $0x90909090,1b(%rip) # 0x0(%rax)
  # MOVABS $0x9090909090909090, %rdi 
  # MOVQ %rdi,gadget_patch1(%rip) # 0x0(%rax)
  
  #MOVW $0x9090,gadget_patch1(%rip) # 0x0(%rax)
  #MOVW $0x9090, %rdi
  # lock XCHG %rdi,gadget_patch1(%rip) # 0x0(%rax)

  MOVW $0x00eb,gadget_patch1(%rip) # 0x0(%rax)
  #MOVW $0x9090,gadget_patch1 # 0x0(%rax)

loop2:
  .align 64
  .global gadget_patch2
gadget_patch2:
  jmp .
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  jmp done

done:

  ret
  .global gadget_end
gadget_end:
