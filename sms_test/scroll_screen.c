#include <sms.h>
#include "vdp.h"
#include "test.h"

extern unsigned int scrollX;
extern unsigned int tilemapY;

char scrollLeft(void)
{
    char rv = FALSE;
    int offset = INT(scrollX * -1);

    if (offset < 0x308)
    {
        if ((offset & 0x07) == 0)
        {
            unsigned int VRAMAddr = TILEMAP_BASE + 256 + ((offset >> 2) & 0x3f);
            unsigned char *tile = &levels[tilemapY][((offset >> 3) & 0x7f) + 31];
            unsigned char y;
            // Load the next column to the right to the tilemap
            __asm__("di");
            for (y = 0; y < 22; y++)
            {
                setVRAMAddr(VRAMAddr);
                VRAMAddr += 64;
                putTile(*tile);
                tile += LEVEL_MAP_WIDTH;
            }
            __asm__("ei");
        }
        scrollX -= X_SPEED;
        rv = TRUE;
    }
    return (rv);
}

char scrollRight(void)
{
    char rv = FALSE;
    int offset = INT(scrollX * -1);

    if (offset > 0)
    {
        if ((offset & 0x07) == 0)
        {
            unsigned int VRAMAddr = TILEMAP_BASE + 256 + ((offset >> 2) & 0x3f);
            unsigned char *tile = &levels[tilemapY][((offset >> 3) & 0x7f) - 1];
            unsigned char y;
            // Load the next column to the right to the tilemap
            __asm__("di");
            for (y = 0; y < 22; y++)
            {
                setVRAMAddr(VRAMAddr);
                VRAMAddr += 64;
                putTile(*tile);
                tile += LEVEL_MAP_WIDTH;
            }
            __asm__("ei");
        }
        scrollX += X_SPEED;
        rv = TRUE;
    }
    return (rv);
}
