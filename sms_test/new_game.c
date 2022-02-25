#include <sms.h>
#include "vdp.h"
#include "test.h"

extern int x;
extern int y;
extern int xSpeed;
extern int ySpeed;
extern int sprite;
extern int tilemapX;
extern int tilemapY;
extern int scrollX;
extern int scrollY;
extern char knightFrame;
extern char falling;
extern char jumping;

void newGame(void)
{
    // Screen off
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_VINT);
    // Set border
    set_vdp_reg(0x87, 0x0f);
    // Disable column 0 ready for horizontal scrolling
    set_vdp_reg(VDP_REG_FLAGS0, 0x26 | 0x40);

    bank(3);
    load_palette(tilesheetPal, 0, 16);
    load_palette(knightPalette, 16, 16);
    load_tiles(tilesheet, 0, 256, 4);
    load_tiles(font, FONT_TILE_OFFSET, 192, 1);
    load_tiles(knightTiles, RIGHT_SPRITE, 40, 4);
    fillScreen(0x0b);

    knightFrame = 0;
    displayLevel();
    print("Castle Escape!", 9, 2);

    x = FIX_POINT((256 / 2) - 8, 0);
    y = FIX_POINT((192 / 2) - 8, 0);

    xSpeed = 0;
    ySpeed = 0;
    falling = FALSE;
    jumping = FALSE;

    sprite = RIGHT_SPRITE;
    tilemapX = 0;
    tilemapY = 0;
    scrollX = 0;
    scrollY = 16;

    // Reset screen scroll
    scroll_bkg(0, scrollY);

    // Screen on
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16);
}
