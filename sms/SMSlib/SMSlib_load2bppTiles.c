/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"

#pragma save
#pragma disable_warning 85
void SMS_load2bppTilesatAddr (const void *src, unsigned int dest, unsigned int size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1) {
  // loop performance: 27¼ cycles per output byte, thus 68+ tiles can be written in a single frame (at 60Hz)
  __asm
  ld c,#0xbf            ; VDP_CTRL_PORT
  set 6,d               ; set VRAM address for write
  di
  out (c),e             ; set VRAM destination address
  out (c),d
  ei

  pop bc                ; pop ret address
  pop de                ; pop size
  push bc               ; push ret address

  ld c,#0xbe            ; VDP_DATA_PORT

1$:
  outi                         ; 16 = 28

  sub a,#0              ; (delay) 7
  xor a                 ; 4
  outi                  ; 16 = 27

  dec de                ; 6
  dec de                ; 6
  ld b,a                ; 4
  out (#0xbe),a         ; 11 = 27

  sub a,#0              ; (delay) 7
  ld a,d                ; 4
  or e                  ; 4
  out(c),b              ; 12 = 27

  jr nz,1$                     ; 12
  ret
  __endasm;
}
#pragma restore
