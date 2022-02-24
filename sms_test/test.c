#include <font/font.h>
#include <sms.h>
#include <stdio.h>
#include <stdlib.h>
#include <psg.h>
#include <psg/PSGlib.h>
#include "vdp.h"
#include "test.h"

#define VDP_REG_SPRITE_PATTERN_BASE 0x86

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

unsigned int x;
unsigned int y;
int xSpeed;
int ySpeed;
unsigned int sprite;
unsigned int tilemapX;
unsigned int tilemapY;
unsigned int scrollX;
unsigned int scrollY;
char knightFrame;

void init(void)
{
    // Clear VRAM and CRAM
    clear_vram();
    // Sprites use tiles >= 256.
    set_vdp_reg(VDP_REG_SPRITE_PATTERN_BASE, 0xff);

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

void main(void)
{
    int dir;

    init();

    displayTitleScreen(3);

    newGame();

    while (1)
    {
        // Read joypad
        dir = read_joypad1();

        ySpeed = 0;
        xSpeed = 0;

        // Update sprite position
        if (dir & JOY_UP)
        {
            if (INT(y) > 16)
                ySpeed = -Y_SPEED;
        }
        else if (dir & JOY_DOWN)
        {
            if (INT(y) < (192 - 16))
                ySpeed = Y_SPEED;
        }
        else
        {
            // Clear any accumulated x-speed
            y &= 0xfff0;
        }

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
