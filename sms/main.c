#include <sms.h>
#include <stdio.h>
#include "SMSlib/SMSlib.h"

unsigned char pal1[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char pal2[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

extern unsigned char SpriteNextFree;
__sfr __at 0xDC IOPortL;

void main(void)
{
    int x = 124;
    int y = 92;
    unsigned char sprite;
    unsigned char ntsc = SMS_VDPType() != VDP_PAL;
    unsigned char ntsc_frame = 0;

    SMS_init();
    SMS_autoSetUpTextRenderer();

    SMS_loadBGPalette(pal1);
    SMS_loadSpritePalette(pal2);
    SMS_useFirstHalfTilesforSprites(1);

    SMS_setNextTileatXY(0, 0);
    printf("Hello world!");

    SMS_setNextTileatXY(0, 1);
    SMS_print("Is it working?");

    SMS_printatXY(0, 2, "I hope so.");

    SMS_printatXY(0, 3, "Use control pad to move sprite.");

    SMS_setNextTileatXY(0, 4);
    printf("VDP type: %s", ntsc ? "NTSC" : "PAL");

    // Add a sprite at position (x, y) with tile index 'A'-32 (assuming the font starts at tile 0 for ASCII 32)
    //    sprite = SMS_addSprite(x, y, 'A'-32);

    // Add a double wide sprite (two adjoining sprites) at position (x, y) with tile index 'A'-32
    // No sprite ID is returned, assume we should use SpriteNextFree
    sprite = SpriteNextFree;
    SMS_addTwoAdjoiningSprites(x, y, 'A' - 32);

    for (;;)
    {
        SMS_updateSpritePosition(sprite, x, y);
        SMS_updateSpritePosition(sprite + 1, x + 8, y);
        char status = IOPortL;
        if ((status & PORT_A_KEY_UP) == 0 && y > 0)
            y -= 2;
        else
        if ((status & PORT_A_KEY_DOWN) == 0 && y < 192 - 16)
            y += 2;
        if ((status & PORT_A_KEY_LEFT) == 0 && x > 0)
            x -= 2;
        else
        if ((status & PORT_A_KEY_RIGHT) == 0 && x < 256 - 16)
            x += 2;
        // Wait for the next frame
        __asm__("halt");
#if 0
        if (ntsc)
        {
            // Insert an extra wait every 5 frames to run at PAL speed on NTSC
            ntsc_frame++;
            if (ntsc_frame == 5)
            {
                __asm__("halt");
                ntsc_frame = 0;
            }
        }
#endif
        // Update the sprites
        SMS_copySpritestoSAT();
    }
}
