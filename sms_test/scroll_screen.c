#include <sms.h>
#include "vdp.h"
#include "test.h"

extern int scrollX;
extern int xSpeed;
extern int tilemapY;

static unsigned int VRAMAddr;
static unsigned char *tile;
char updateColumn;

void drawColumn(void)
{
    unsigned char y;
    if (updateColumn == TRUE)
    {
        // Load the next column to the tilemap
        __asm__("di");
        for (y = 0; y < 22; y++)
        {
            setVRAMAddr(VRAMAddr);
            VRAMAddr += 64;
            putTile(*tile);
            tile += LEVEL_MAP_WIDTH;
        }
        __asm__("ei");
        updateColumn = FALSE;
    }
}

char scrollLeft(void)
{
    int offset = INT(scrollX * -1);

    updateColumn = FALSE;

    if (offset < 0x308)
    {
        if ((offset & 0x07) == 0)
        {
            VRAMAddr = TILEMAP_BASE + 256 + ((offset >> 2) & 0x3f);
            tile = &levels[tilemapY][((offset >> 3) & 0x7f) + 31];

            updateColumn = TRUE;
        }
        scrollX -= xSpeed;
        return (TRUE);
    }
    return (FALSE);
}

char scrollRight(void)
{
    int offset = INT(scrollX * -1);

    updateColumn = FALSE;

    if (offset > 0)
    {
        if ((offset & 0x07) == 0)
        {
            VRAMAddr = TILEMAP_BASE + 256 + ((offset >> 2) & 0x3f);
            tile = &levels[tilemapY][((offset >> 3) & 0x7f) - 1];

            updateColumn = TRUE;
        }
        scrollX -= xSpeed;
        return (TRUE);
    }
    return (FALSE);
}
