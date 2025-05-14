  .global gadget_start
gadget_start:

  // NOTE: DESIGNED FOR ARM64
  .balign 64

  .global gadget_patch1
gadget_patch1:
  b gadget_patch1
gadget1:

  adr x0, gadget_patch2 // load addr
  adr x1, .g2
  ldr w1, [x1]
  //ldr x1,  // load nop
  str w1, [x0] // write nop to addr
  
  dc cvau, x0   // force the data cache to update Physical Memory with new contents
  dsb ish       //  force all loads and stores to be seen
  ic ivau, x0   // if hit in icache, force icache to use what's in Physical Memory
  dsb ish       //  broadcasts the ic ivau instruction to the other cores
  isb           // force pipeline flush

  b gadget2

  .global gadget_entry
gadget_entry:

  adr x0, gadget_patch1 // load addr
  adr x1, .g1
  ldr w1, [x1]
  //ldr x1,  // load nop
  str w1, [x0] // write nop to addr
  
  dc cvau, x0   // force the data cache to update Physical Memory with new contents
  dsb ish       //  force all loads and stores to be seen
  ic ivau, x0   // if hit in icache, force icache to use what's in Physical Memory
  dsb ish       //  broadcasts the ic ivau instruction to the other cores
  isb           // force pipeline flush

  .balign 64
  .global gadget_patch2
gadget_patch2:
  b gadget_patch2
gadget2:

  ret
.g1:
  .word 0xeaffffff
  //.word nop 
.g2:
  .word 0xeaffffff


  .global gadget_end
gadget_end:


