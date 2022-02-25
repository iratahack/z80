#include <sms.h>
#include "test.h"
#include "vdp.h"

#define ID_SOLID_TILE   (12*16)

extern int xSpeed;
extern int x;
extern int y;
extern int scrollX;
extern char knightFrame;

char xCollision(void)
{
    unsigned int tileX;
    unsigned int tileY;

    // Convert player relative screen position to
    // absolute level map.
    tileY = (INT(y) - 8) >> 3;

    if (xSpeed < 0)
    {
        // Moving left, check left side of sprite
        tileX = (INT(x + xSpeed) + INT(scrollX * -1) - 4) >> 3;
    }
    else if (xSpeed > 0)
    {
        // Moving right, check right side of sprite
        tileX = (INT(x + xSpeed) + INT(scrollX * -1) + 3) >> 3;
    }

    if (levels[tileY][tileX] >= ID_SOLID_TILE)
    {
        // Set sprite to standing
        knightFrame = 0;
        // Clear any accumulated x-speed
        x &= 0xfff0;
        // Set speed to 0
        xSpeed = 0;
        return (TRUE);
    }
    return (FALSE);
}
