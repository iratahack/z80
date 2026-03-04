/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"

extern unsigned char SpriteTableY[MAXSPRITES];
extern unsigned char SpriteTableXN[MAXSPRITES*2];
extern unsigned char SpriteNextFree;

// VRAM unsafe functions. Fast, but dangerous!
void UNSAFE_SMS_copySpritestoSAT (void) {
  unsigned char count;

  count=SpriteNextFree;

  SMS_setAddr(SMS_SATAddress);
  if (count==0) {
    SMS_byte_to_VDP_data(0xD0);
    return;
  }

  SMS_byte_brief_array_to_VDP_data(SpriteTableY, count);
  if (count<64)
    SMS_byte_to_VDP_data(0xD0);

  SMS_setAddr(SMS_SATAddress+128);
  SMS_byte_brief_array_to_VDP_data(SpriteTableXN, count*2);
}
