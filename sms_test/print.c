#include "vdp.h"

void print(char *string, char x, char y)
{
    int tile;

    __asm__("di");
    setVRAMAddr(TILEMAP_BASE + (y << 6) + (x << 1));
    while ((tile = *string++))
    {
        putTile((tile - 32) + FONT_TILE_OFFSET);
    }
    __asm__("ei");
}
