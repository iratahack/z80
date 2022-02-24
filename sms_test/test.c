#include <font/font.h>
#include <sms.h>
#include <stdio.h>
#include <stdlib.h>
#include <psg.h>
#include <psg/PSGlib.h>
#include "vdp.h"

#define VDP_REG_SPRITE_PATTERN_BASE 0x86

#define FONT_TILE_OFFSET 0x100

#define RIGHT_SPRITE (FONT_TILE_OFFSET + 96)
#define LEFT_SPRITE (RIGHT_SPRITE + 20)

#define LEVEL_MAP_WIDTH 128
#define LEVEL_MAP_HEIGHT 126

#define FIX_POINT(a, b)     ((a<<4) | b)
#define X_SPEED FIX_POINT(0, 4)
#define INT(a)  (a>>4)

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
extern unsigned int timer;
extern void isr(void);

#define VDP_CMD_SET_PALETTE0 0x01
#define VDP_CMD_SET_PALETTE1 0x02
#define VDP_CMD_FILL_SCREEN 0x04
#define VDP_CMD_LOAD_TILES 0x08
#define VDP_CMD_SPRITE 0x10
#define VDP_CMD_LOAD_FONT 0x20
volatile unsigned char VDPReg1;

unsigned int x = FIX_POINT((256 / 2) - 8, 0);
unsigned int y = FIX_POINT((192 / 2) - 8, 0);
int xSpeed = 0;
int ySpeed = 0;
unsigned int sprite = RIGHT_SPRITE;
unsigned int tilemapX = 0;
unsigned int tilemapY = 0;
unsigned int scrollX = 0;
unsigned int scrollY = 16;
char knightFrame;
extern unsigned char levels[LEVEL_MAP_HEIGHT][LEVEL_MAP_WIDTH];

void print(char *string, uint8_t x, uint8_t y)
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

void init(void)
{
    // Clear VRAM and CRAM
    clear_vram();

    // Disable sprites by writing 0xd0 to their Y location
    __asm__("di");
    for (char n = 0; n < 64; n++)
        setSpriteXY(n, 0, 0xd1);
    __asm__("ei");

    // Setup the PSG
    psg_init();
    add_raster_int(isr);
    PSGPlay(music);
}

void displayTitleScreen(char seconds)
{
    // Disable screen
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_VINT);
    // Set border color
    set_vdp_reg(0x87, 0x00);
    // Enable column 0
    set_vdp_reg(VDP_REG_FLAGS0, 0x06);

    bank(4);
    scroll_bkg(0, scrollY);
    load_palette(titlePal, 0, 16);
    load_tiles(tiles, 0, (&tilesEnd - &tiles) / 32, 4);
    set_bkg_map(tileMap, 0, 2, 32, 24);

    // Enable screen
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    // Wait
    for (int n = 0; n < 60 * seconds; n++)
    {
        __asm__("halt");
    }
}

void updateVRAM(void)
{
    static unsigned char frame = 0;
    static unsigned char rotate = 0;
    unsigned char flicker;

    // Update VRAM in refresh
    __asm__("halt");

    // Update screen scrolling
    scrollx(INT(scrollX) & 0xff);

    // Update player sprite
    set_sprite(0, INT(x), INT(y) - 1, sprite + (INT(knightFrame) << 2));
    set_sprite(1, INT(x) + 8, INT(y) - 1, sprite + 2 + (INT(knightFrame) << 2));

    // Rotate coins
    if (rotate++ == 8)
    {
        rotate = 0;
        load_tiles(&tilesheet[96 + (frame++ & 0x03) << 5], 96, 1, 4);
    }

    // Flicker lanterns
    if (timer & 1)
    {
        flicker = (char) rand();
        load_tiles(&tilesheet[12 + (flicker & 0x03) << 5], 3, 1, 4);
    }
}

void newGame(void)
{
    knightFrame = 0;
    displayLevel();
    print("Castle Escape!", 9, 2);
}

void main(void)
{
    int dir;

    init();

    displayTitleScreen(3);

    // Screen off
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_VINT);
    // Set border
    set_vdp_reg(0x87, 0x0f);
    // Disable column 0 ready for horizontal scrolling
    set_vdp_reg(VDP_REG_FLAGS0, 0x26 | 0x40);
    // Sprites use tiles >= 256.
    set_vdp_reg(VDP_REG_SPRITE_PATTERN_BASE, 0xff);

    bank(3);
    load_palette(tilesheetPal, 0, 16);
    load_palette(knightPalette, 16, 16);
    load_tiles(tilesheet, 0, 256, 4);
    load_tiles(font, FONT_TILE_OFFSET, 192, 1);
    load_tiles(knightTiles, RIGHT_SPRITE, 40, 4);
    fillScreen(0x0b);

    // Screen on
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16);

    newGame();

    while (1)
    {
        // Read joypad
        dir = read_joypad1();

        // Update sprite position
        if (dir & JOY_UP)
        {
            if (INT(y) > 16)
                y--;
        }
        if (dir & JOY_DOWN)
        {
            if (INT(y) < (192 - 16))
                y++;
        }

        xSpeed = 0;
        if (dir & JOY_LEFT)
        {
            if (INT(x) > 8 + 64)
            {
                xSpeed = -X_SPEED;
            }
            else
            {
                if (scrollRight() == FALSE)
                {
                    if (INT(x) > 8)
                    {
                        xSpeed = -X_SPEED;
                    }
                }
                else
                {
                    if (knightFrame <= 0)
                    {
                        knightFrame = FIX_POINT(5, 0);
                    }
                    knightFrame -= X_SPEED;
                }
            }
            sprite = LEFT_SPRITE;
        }
        else if (dir & JOY_RIGHT)
        {
            if (INT(x) < (256 - 16 - 64))
            {
                xSpeed = X_SPEED;
            }
            else
            {
                if (scrollLeft() == FALSE)
                {
                    if (INT(x) < (256 - 16))
                    {
                        xSpeed = X_SPEED;
                    }
                }
                else
                {
                    knightFrame += X_SPEED;
                    if (knightFrame >= FIX_POINT(5, 0))
                    {
                        knightFrame = 0;
                    }
                }
            }
            sprite = RIGHT_SPRITE;
        }
        else
        {
            // Set sprite to standing
            knightFrame = 0;
            // Clear any accumulated x-speed
            x &= 0xfff0;
        }

        x += xSpeed;
        y += ySpeed;

        if (xSpeed < 0) // Moving left
        {
            if (knightFrame <= 0)
            {
                knightFrame = FIX_POINT(5, 0);
            }
            knightFrame -= X_SPEED;
        }
        else if (xSpeed > 0) // Moving right
        {
            knightFrame += X_SPEED;
            if (knightFrame >= FIX_POINT(5, 0))
            {
                knightFrame = 0;
            }
        }

        updateVRAM();
    }
}
