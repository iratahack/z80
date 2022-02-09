#include <font/font.h>
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
extern unsigned char VDPFunc;
extern unsigned int palette0;
extern unsigned int palette1;
extern unsigned int blankTile;
extern unsigned int tileData;
extern unsigned int tileLength;
extern unsigned int tileOffset;
extern void isr(void);

#define VDP_CMD_SET_PALETTE0    0x01
#define VDP_CMD_SET_PALETTE1    0x02
#define VDP_CMD_FILL_SCREEN     0x04
#define VDP_CMD_LOAD_TILES      0x08
#define VDP_CMD_SPRITE          0x10
#define VDP_CMD_LOAD_FONT       0x20
volatile unsigned char VDPReg1 = VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT
        | VDP_REG_FLAGS1_8x16 | 0x80;

unsigned char x = (256 / 2) - 8;
unsigned char y = (192 / 2) - 8;
unsigned int sprite = RIGHT_SPRITE;

//#define DEBUG
#define MAX_PIXEL_FRAMES 32

#ifdef DEBUG
void print(uint8_t *string, uint8_t x, uint8_t y)
{
    uint16_t tile;

    __asm__("di");
    setVRAMAddr(TILEMAP_BASE + (y << 6) + (x << 1));
    while ((tile = *string++))
    {
        putTile((tile - 32) + FONT_TILE_OFFSET);
    }
    __asm__("ei");
}
#endif

void displayTilesheet(void)
{
    // Display the 256 entry tilesheet
    __asm__("di");
    for (int y = 0; y < 16; y++)
    {
        setVRAMAddr(TILEMAP_BASE + (y << 6));
        for (int x = 0; x < 16; x++)
        {
            putTile((y * 16) + x);
        }
    }
    __asm__("ei");
}

void main()
{
    uint16_t startCount = 0;
    uint16_t endCount = 0;
    uint8_t str[33];
    uint16_t dir;
    unsigned char accel = MAX_PIXEL_FRAMES;
    unsigned char pixelFrames = MAX_PIXEL_FRAMES >> 3;
    int8_t xSpeed = 0;

    // Clear VRAM and CRAM
    clear_vram();
    // Disable sprites by writing 0xd0 to their Y location
    for (int n = 0; n < 64; n++)
        set_sprite(n, 0, 0xd0, 0);

    // Setup the PSG
    psg_init();
    add_raster_int(isr);
    PSGPlay(music);

    bank(4);
    load_tiles(tiles, 0, (&tilesEnd - &tiles) / 32, 4);
    set_bkg_map(tileMap, 0, 0, 32, 24);
    load_palette(titlePal, 0, 16);
    load_palette(titlePal, 16, 16);
    set_vdp_reg(0x87, 0x00);

    // Sprites use tiles >= 256.
    set_vdp_reg(VDP_REG_SPRITE_PATTERN_BASE, 0xff);
    // Enable screen, frame interrupt & 8x16 sprites
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16
                    | 0x80);

    // Wait for 5 seconds
    for (int n = 0; n < 60 * 5; n++)
    {
        __asm__("halt");
    }

    // Set border
    set_vdp_reg(0x87, 0x0f);
    // Screen off
    VDPReg1 = VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16 | 0x80;
    set_vdp_reg(VDP_REG_FLAGS1, VDPReg1);
    __asm__("halt");

    bank(3);
    palette0 = tilesheetPal;
    palette1 = knightPalette;
    blankTile = 0x0b;
    tileOffset = 0;
    tileData = tilesheet;
    tileLength = 256 << 5;
    VDPFunc = VDP_CMD_SET_PALETTE0 | VDP_CMD_SET_PALETTE1 | VDP_CMD_FILL_SCREEN
            | VDP_CMD_LOAD_TILES;
    while (VDPFunc)
        ;

    tileOffset = FONT_TILE_OFFSET << 5;
    tileData = font;
    tileLength = 192 << 5;
    VDPFunc = VDP_CMD_LOAD_FONT;
    while (VDPFunc)
        ;

    tileOffset = RIGHT_SPRITE << 5;
    tileData = knightTiles;
    tileLength = 40 << 5;
    VDPFunc = VDP_CMD_LOAD_TILES;
    while (VDPFunc)
        ;
    bank(2);

    // Screen on
    VDPReg1 = VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16
            | 0x80;
    set_vdp_reg(VDP_REG_FLAGS1, VDPReg1);

    displayTilesheet();

    while (1)
    {
        __asm__("halt");
//        __asm__("halt");
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
            xSpeed = -1;

            if (accel > 0)
                accel--;
        }
        else if (dir & JOY_RIGHT)
        {

            xSpeed = 1;

            if (accel > 0)
                accel--;
        }
        else
        {
            if (accel < MAX_PIXEL_FRAMES)
                accel++;
            else
                xSpeed = 0;
        }

        if (pixelFrames-- == 0)
        {
            pixelFrames = accel >> 3;

            if ((x < (256 - 16)) && (xSpeed > 0))
            {
                x += xSpeed;
                sprite = RIGHT_SPRITE + ((x % 5) << 2);
            }

            if ((x > 0) && (xSpeed < 0))
            {
                x += xSpeed;
                sprite = LEFT_SPRITE + ((x % 5) << 2);
            }
        }

        VDPFunc = VDP_CMD_SPRITE;
        // Update sprite pattern for animation
#ifdef DEBUG
        endCount = readVCount();

        // Display the co-ords for sprite top-left
        sprintf(str, "X=%3d, Y=%3d, V-Count=%3d", x, y, endCount - startCount);
        print(str, 0, 23);
#endif
    }
}
