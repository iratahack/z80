/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"

#pragma save
#pragma disable_warning 85
void SMS_debugPrintf(const unsigned char *format, ...) __naked __preserves_regs(a,b,c,iyh,iyl) {
// basic debug_printf code kindly provided by toxa - thank you!
  __asm
    ld hl,#2
    add hl,sp
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ex de,hl
    ld d,d
    ret
    nop
    .dw 0x6464
    .dw 0x0200
  __endasm;
}
#pragma restore
