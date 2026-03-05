#include <sms.h>
#include <stdio.h>
#include "SMSlib/SMSlib.h"

unsigned char pal1[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char pal2[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

void main(void)
{
    int x = 124;
    int y = -8;
    char sprite = 0;

    SMS_init();
    SMS_autoSetUpTextRenderer();

    SMS_loadBGPalette(pal1);
    SMS_loadSpritePalette(pal2);
    SMS_useFirstHalfTilesforSprites(1);

    SMS_setNextTileatXY(0,0);
    SMS_print("Is it working?");

    SMS_printatXY(0, 1, "I hope so.");

    // Add a sprite at position (x, y) with tile index 'A'-32 (assuming the font starts at tile 0 for ASCII 32)
//    sprite = SMS_addSprite(x, y, 'A'-32);
    SMS_addTwoAdjoiningSprites(x, y, 'A' - 32);

    for (;;)
    {
        SMS_updateSpritePosition(sprite, x, y);
        SMS_updateSpritePosition(sprite+1, x+8, y);
        if (++y >= 0xc0)
            y = -8;
        __asm__("halt");
        SMS_copySpritestoSAT();
    }
}
