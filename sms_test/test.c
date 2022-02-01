#include <sms.h>
#include <stdio.h>
#include <psg.h>
#include <psg/PSGlib.h>
#include "vdp.h"

#define VDP_REG_SPRITE_PATTERN_BASE 0x86

#define FONT_TILE_OFFSET 0x100

#define RIGHT_SPRITE    (FONT_TILE_OFFSET + 96)
#define LEFT_SPRITE     (RIGHT_SPRITE + 20)

extern unsigned char tilesheetPal[];
extern unsigned char tilesheet[];
extern unsigned char titlePal[];
extern unsigned char tiles[];
extern unsigned char tilesEnd[];
extern unsigned int tileMap[];
extern unsigned char font[];
extern unsigned char knightTiles[];
extern unsigned char knightPalette[];
extern uint8_t music[];

#ifdef DEBUG
void print(uint8_t *string, uint8_t x, uint8_t y)
{
    uint16_t tile;

    setVRAMAddr(TILEMAP_BASE + (y << 6) + (x << 1));

    while ((tile = *string++))
    {
        putTile((tile - 32) + FONT_TILE_OFFSET);
    }
}
#endif

void main()
{
    uint8_t x = (256 / 2) - 8;
    uint8_t y = (192 / 2) - 8;
    uint16_t startCount = 0;
    uint16_t endCount = 0;
    uint8_t str[33];
    uint16_t sprite = RIGHT_SPRITE + ((x % 5) << 2);
    uint16_t dir;

    // Clear VRAM and CRAM
    clear_vram();
    // Disable sprites by writing 0xd0 to their Y location
    for (int n = 0; n < 64; n++)
        set_sprite(n, 0, 0xd0, 0);

    // Setup the PSG
    psg_init();
    add_raster_int(PSGFrame);
    PSGPlay(music);

    bank(4);
    load_tiles(tiles, 0, (&tilesEnd - &tiles) / 32, 4);
    set_bkg_map(tileMap, 0, 0, 32, 24);
    load_palette(titlePal, 0, 16);
    // Enable screen, frame interrupt & 8x16 sprites
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16);
    // Sprites use tiles >= 256, bits 1-0 need to be set for correct operation.
    set_vdp_reg(VDP_REG_SPRITE_PATTERN_BASE, 0x04 | 0x03);

    // Wait for 5 seconds
    for (int n = 0; n < 60 * 5; n++)
    {
        __asm__("halt");
    }

    // Screen off
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16);

    bank(3);
    fillScreen(0x0b);
    load_tiles(tilesheet, 0, 256, 4);
    load_tiles(font, FONT_TILE_OFFSET, 96, 1);
    load_tiles(knightTiles, RIGHT_SPRITE, 40, 4);
    load_palette(tilesheetPal, 0, 16);
    load_palette(knightPalette, 16, 16);
    bank(2);
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16);

    // Display the 256 entry tilesheet
    for (int y = 0; y < 16; y++)
    {
        setVRAMAddr(TILEMAP_BASE + (y << 6));
        for (int x = 0; x < 16; x++)
        {
            putTile((y * 16) + x);
        }
    }

    while (1)
    {
        __asm__("halt");
        __asm__("halt");
#ifdef DEBUG
        startCount = readVCount();
#endif
        // Read joypad 1&2 inputs
        dir = read_joypad1();

        // Update sprite position
        if (dir & JOY_UP)
        {
            if (y > 0)
                y--;
        }
        if (dir & JOY_DOWN)
        {
            if (y < (192 - 16))
                y++;
        }
        if (dir & JOY_LEFT)
        {
            if (x > 0)
                x--;
            sprite = LEFT_SPRITE + ((x % 5) << 2);
        }
        if (dir & JOY_RIGHT)
        {
            if (x < (256 - 16))
                x++;
            sprite = RIGHT_SPRITE + ((x % 5) << 2);
        }

        // Update sprite pattern for animation
        set_sprite(0, x, y - 1, sprite);
        set_sprite(1, x + 8, y - 1, sprite + 2);
#ifdef DEBUG
        endCount = readVCount();

        // Display the co-ords for sprite top-left
        sprintf(str, "X=%3d, Y=%3d, V-Count=%3d", x, y, endCount - startCount);
        print(str, 0, 23);
#endif
    }
}
