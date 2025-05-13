  .global gadget_start
gadget_start:
# NOTE: DESIGNED FOR ARM64
  .balign 64

  .global gadget_patch1
gadget_patch1:
  b gadget_patch1

  adr x0, =gadget_patch2 # load addr
  ldr x1, 0xd503201f # load nop
  str x1, [x0] # write nop to addr
  
  dc cvau, x0   # force the data cache to update Physical Memory with new contents
  dsb ish       #  force all loads and stores to be seen
  ic ivau, x0   # if hit in icache, force icache to use what's in Physical Memory
  dsb ish       #  broadcasts the ic ivau instruction to the other cores
  isb           # force pipeline flush

  b gadget_end

  .global gadget_entry
gadget_entry:

  adr x3, =gadget_patch1 # load addr
  ldr x2, 0xd503201f # load nop
  str x2, [x3] # write nop to addr
  
  dc cvau, x3   # force the data cache to update Physical Memory with new contents
  dsb ish       #  force all loads and stores to be seen
  ic ivau, x3   # if hit in icache, force icache to use what's in Physical Memory
  dsb ish       #  broadcasts the ic ivau instruction to the other cores
  isb           # force pipeline flush

  .balign 64
  .global gadget_patch2
gadget_patch2:
  b gadget_patch2

  .global gadget_end
gadget_end:
  ret # TODO: check this line
