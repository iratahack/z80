#include <sms.h>
#include "vdp.h"

extern unsigned char titlePal[];
extern unsigned char tiles[];
extern unsigned char tilesEnd[];
extern unsigned int tileMap[];

void displayTitleScreen(char seconds)
{
    // Disable screen
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_VINT);
    // Set border color
    set_vdp_reg(0x87, 0x00);
    // Enable column 0
    set_vdp_reg(VDP_REG_FLAGS0, 0x06);

    // Title screen is in bank 4
    bank(4);
    // Reset screen scroll
    scroll_bkg(0, 0);
    // Load the palette
    load_palette(titlePal, 0, 16);
    // Load the tiles
    load_tiles(tiles, 0, (&tilesEnd - &tiles) / 32, 4);
    // Display the title screen
    set_bkg_map(tileMap, 0, 0, 32, 24);

    // Enable screen
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    // Wait
    for (int n = 0; n < 60 * seconds; n++)
    {
        __asm__("halt");
    }
}

