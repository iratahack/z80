#include <sms.h>
#include "test.h"
#include "vdp.h"

extern int ySpeed;
extern int xSpeed;
extern int x;
extern int y;
extern char falling;
extern int scrollX;
extern char knightFrame;
extern char jumping;

#define ID_SOFT_TILE    (10*16)
#define ID_SOLID_TILE   (12*16)

void setFalling(void)
{
    // Set falling flag
    falling = TRUE;

    // Set sprite to standing
    knightFrame = 0;
    // Clear any accumulated x-speed
    x &= 0xfff0;
    // Set speed to 0
    xSpeed = 0;
}

void clearFalling(void)
{
    // Clear falling flag
    falling = FALSE;

    // Set speed to 0
    ySpeed = 0;
    // Clear any accumulated y-speed
    y &= 0xfff0;
}

void doGravity(void)
{
    unsigned int tileX;
    unsigned int tileY;

    tileX = (INT(x) + INT(scrollX * -1) - 4) >> 3;

    if (ySpeed < 0)
    {
        tileY = (INT(y + ySpeed) - 16) >> 3;

        // Check the tile above the left side of
        // the player.
        if (levels[tileY][tileX] >= ID_SOLID_TILE)
        {
            clearFalling();
        }
        // If the left side of the players is not tile aligned,
        // check the tile to the right.
        else if ((INT(x) + INT(scrollX * -1) - 4) & 0x07)
        {
            if (levels[tileY][tileX + 1] >= ID_SOLID_TILE)
            {
                clearFalling();
            }
        }
    }
    else
    {
        ySpeed = Y_SPEED;

        // TODO: Check for collisions when moving up.

        // Convert player relative screen position to
        // absolute level map. Screen is offset by 8
        // so subtract that but player left foot is
        // 4 pixels from the edge of the tile so add
        // that. The result is we subtract 4, which
        // can be seen below.
//        tileX = (INT(x) + INT(scrollX * -1) - 4) >> 3;
        tileY = INT(y) >> 3;

#ifdef DEBUG
    {
        char str[33];
        sprintf(str, "pix=%3d", (INT(x) + INT(scrollX * -1) - 4));
        print(str, 1, 23);
    }
#endif

        // Check if the tile under the left side of
        // the players left foot is solid
        if (levels[tileY][tileX] >= ID_SOFT_TILE)
        {
            clearFalling();
        }
        // If the left side of the players left foot is not
        // tile aligned we need to check the tile to the
        // right also.
        else if ((INT(x) + INT(scrollX * -1) - 4) & 0x07)
        {
            if (levels[tileY][tileX + 1] >= ID_SOFT_TILE)
            {
                clearFalling();
            }
            else
            {
                setFalling();
            }
        }
        else
        {
            setFalling();
        }
    }
}
