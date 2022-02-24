#include "vdp.h"

extern unsigned int tilemapX;
extern unsigned int tilemapY;

void displayLevel(void)
{
    unsigned int VRAMAddr = TILEMAP_BASE + 256 + 2;
    unsigned char *tile = &levels[tilemapY][tilemapX];
    unsigned char x, y;

    __asm__("di");
    for (y = 0; y < 22; y++)
    {
        setVRAMAddr(VRAMAddr);
        for (x = 0; x < 31; x++)
        {
            putTile(*tile++);
        }
        tile += 128 - 31;
        VRAMAddr += 64;
    }
    __asm__("ei");
}
