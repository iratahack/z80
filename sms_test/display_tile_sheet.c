#include "vdp.h"

void displayTilesheet(void)
{
    unsigned char tile = 0;
    // Display the 256 entry tilesheet
    __asm__("di");
    for (int y = 2; y < 18; y++)
    {
        setVRAMAddr(TILEMAP_BASE + (y << 6) + 2);
        for (int x = 0; x < 16; x++)
        {
            putTile(tile++);
        }
    }
    __asm__("ei");
}
