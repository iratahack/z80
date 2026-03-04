/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"

// VRAM unsafe functions. Fast, but dangerous!
/* UNSAFE_SMS_loadNTiles() and UNSAFE_SMS_loadTiles() are macros that call UNSAFE_SMS_VRAMmemcpy() */

#pragma save
#pragma disable_warning 85
void * UNSAFE_SMS_VRAMmemcpy (unsigned int dst, const void *src, unsigned int size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1) {
  // dst in HL
  // src in DE
  // size onto the stack
  // returns a void pointer to src+size in HL
__asm
  set 6, h           ; set VRAM address write flag
  rst #0x08

  ex de,hl           ; move src in hl

  pop bc             ; pop ret address
  pop de             ; pop size in DE
  push bc            ; push ret address back into stack

  ld a,d
  or e
  ret z              ; end here when size equals zero

  ld c,#_VDPDataPort
_unsafe_memcpy_loop:
  ld a,(hl)
  out (c),a
  inc hl
  dec de
  ld a,d
  or e
  jr nz,_unsafe_memcpy_loop
  ret
__endasm;
}
#pragma restore
