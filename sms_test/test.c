#include <font/font.h>
#include <sms.h>
#include <stdio.h>
#include <psg.h>
#include <psg/PSGlib.h>
#include "vdp.h"

#define VDP_REG_SPRITE_PATTERN_BASE 0x86

#define FONT_TILE_OFFSET 0x100

#define RIGHT_SPRITE (FONT_TILE_OFFSET + 96)
#define LEFT_SPRITE (RIGHT_SPRITE + 20)

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

#define VDP_CMD_SET_PALETTE0 0x01
#define VDP_CMD_SET_PALETTE1 0x02
#define VDP_CMD_FILL_SCREEN 0x04
#define VDP_CMD_LOAD_TILES 0x08
#define VDP_CMD_SPRITE 0x10
#define VDP_CMD_LOAD_FONT 0x20
volatile unsigned char VDPReg1 = VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16 | 0x80;

unsigned char x = (256 / 2) - 8;
unsigned char y = (192 / 2) - 8;
unsigned int sprite = RIGHT_SPRITE;
unsigned int tilemapX = 0;
unsigned int tilemapY = 0;
unsigned int scrollX = 0;
unsigned int scrollY = 16;
extern unsigned char levels[126][128];

//#define DEBUG

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

void displayLevel(void)
{
    __asm__("di");
    for (unsigned char y = 0; y < 24; y++)
    {
        setVRAMAddr(TILEMAP_BASE + ((y + 2) << 6) + 2);
        for (unsigned char x = 0; x < 31; x++)
        {
            putTile(levels[tilemapY + y][tilemapX + x]);
        }
    }
    __asm__("ei");
}

void scrollLeft(void)
{
    int offset = scrollX * -1;
    __asm__("di");
    if (offset < 0x308)
    {
        if ((scrollX & 0x07) == 0)
        {
            unsigned int VRAMAddr = TILEMAP_BASE + 128 + (((256 - (scrollX & 0xff)) >> 2) & 0x3f);
            unsigned char *tile = &levels[tilemapY][(offset >> 3) + 31];
            // Load the next column to the right to the tilemap
            for (unsigned char y = 0; y < 24; y++)
            {
                setVRAMAddr(VRAMAddr);
                VRAMAddr += 64;
                putTile(*tile);
                tile += 128;
            }
        }
        scrollX--;
        scrollx(scrollX & 0xff);
    }
    __asm__("ei");
}

void scrollRight(void)
{
    int offset = scrollX * -1;
    __asm__("di");
    if (offset > 0)
    {
        if ((scrollX & 0x07) == 0)
        {
            unsigned int VRAMAddr = TILEMAP_BASE + 128 + (((256 - (scrollX & 0xff)) >> 2) & 0x3f);
            unsigned char *tile = &levels[tilemapY][(offset >> 3) - 1];
            // Load the next column to the right to the tilemap
            for (unsigned char y = 0; y < 24; y++)
            {
                setVRAMAddr(VRAMAddr);
                VRAMAddr += 64;
                putTile(*tile);
                tile += 128;
            }
        }
        scrollX++;
        scrollx(scrollX & 0xff);
    }
    __asm__("ei");
}

void main()
{
    uint16_t startCount = 0;
    uint16_t endCount = 0;
    uint8_t str[33];
    uint16_t dir;
    unsigned char frame = 0;
    unsigned char rotate = 0;

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
    set_bkg_map(tileMap, 0, 2, 32, 24);
    // Center visible screen vertically ready for scrolling
    scroll_bkg(0, scrollY);
    load_palette(titlePal, 0, 16);
    set_vdp_reg(0x87, 0x00);

    // Sprites use tiles >= 256.
    set_vdp_reg(VDP_REG_SPRITE_PATTERN_BASE, 0xff);
    // Enable screen, frame interrupt & 8x16 sprites
    set_vdp_reg(VDP_REG_FLAGS1,
                VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16 | 0x80);

    // Wait for 5 seconds
    for (int n = 0; n < 60 * 5; n++)
    {
        __asm__("halt");
    }

    // Set border
    set_vdp_reg(0x87, 0x0f);
    // Disable column 0 ready for horizontal scrolling
    set_vdp_reg(VDP_REG_FLAGS0, 0x26);
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
    VDPFunc = VDP_CMD_SET_PALETTE0 | VDP_CMD_SET_PALETTE1 | VDP_CMD_FILL_SCREEN | VDP_CMD_LOAD_TILES;
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
    //    bank(2);

    // Screen on
    VDPReg1 = VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16 | 0x80;
    set_vdp_reg(VDP_REG_FLAGS1, VDPReg1);

    //    displayTilesheet();

    displayLevel();

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
            if (x > 8)
                x--;
            else
            {
                scrollRight();
            }
            sprite = LEFT_SPRITE + ((x % 5) << 2);
        }
        if (dir & JOY_RIGHT)
        {
            if (x < (256 - 16))
                x++;
            else
            {
                scrollLeft();
            }
            sprite = RIGHT_SPRITE + ((x % 5) << 2);
        }

        VDPFunc = VDP_CMD_SPRITE;
        if ((rotate++ % 8) == 0)
        {
            tileOffset = (6 * 16) << 5;
            tileData = &tilesheet[((6 * 16) << 5) + ((frame++ & 0x03) << 5)];
            tileLength = 1 << 5;
            VDPFunc |= VDP_CMD_LOAD_TILES;
        }
#ifdef DEBUG
        endCount = readVCount();

        // Display the co-ords for sprite top-left
        sprintf(str, "X=%3d, Y=%3d, V-Count=%3d", x, y, endCount - startCount);
        print(str, 0, 23);
#endif
    }
}
