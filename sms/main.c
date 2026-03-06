#include <sms.h>
#include <stdio.h>
#include "SMSlib/SMSlib.h"

unsigned char pal1[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char pal2[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

extern unsigned char SpriteNextFree;

void main(void)
{
    static int x = 256/2 - 8;
    static int y = 192/2 - 4;
    static unsigned char sprite;
    static unsigned char lastKey;
    static unsigned char ntsc_frame;
    static unsigned char ntsc;

    ntsc = SMS_VDPType() != VDP_PAL;

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
        static char keyStatus;
        SMS_updateSpritePosition(sprite, x, y);
        SMS_updateSpritePosition(sprite + 1, x + 8, y);
        keyStatus = SMS_getKeysStatus();

        // Up or Down?
        if ((keyStatus & PORT_A_KEY_UP) && y > 0)
            y -= 2;
        else if ((keyStatus & PORT_A_KEY_DOWN) && y < 192 - 16)
            y += 2;

        // Left or Right?
        if ((keyStatus & PORT_A_KEY_LEFT) && x > 0)
            x -= 2;
        else if ((keyStatus & PORT_A_KEY_RIGHT) && x < 256 - 16)
            x += 2;

        lastKey ^= keyStatus; // XOR to find which keys changed since last frame

        if (lastKey & PORT_A_KEY_START)
        {
            // Was it pressed or released?
            if(keyStatus & PORT_A_KEY_START)
                SMS_setSpritePaletteColor(1, 0x3f); // Pressed
            else
                SMS_setSpritePaletteColor(1, 0x03); // Released
        }

        if (lastKey & PORT_A_KEY_2)
        {
            // Was it pressed or released?
            if(keyStatus & PORT_A_KEY_2)
                SMS_setSpritePaletteColor(1, 0x0f); // Pressed
            else
                SMS_setSpritePaletteColor(1, 0x03); // Released
        }

        lastKey = keyStatus;

        // Wait for the next frame
        __asm__("halt");

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

        if(SMS_queryPauseRequested())
        {
            static unsigned char buffer[12];

            SMS_resetPauseRequest();

            SMS_saveTileMapArea(13, 12, buffer, 6, 1);
            SMS_printatXY(13, 12, "PAUSED");

            // Loop until pause is requested again (unpause)
            while(!SMS_queryPauseRequested())
                __asm__("halt");

            SMS_resetPauseRequest();
            SMS_loadTileMapArea(13, 12, buffer, 6, 1);
        }

        // Update the sprites
        SMS_copySpritestoSAT();
    }
}
