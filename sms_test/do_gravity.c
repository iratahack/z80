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

#define ID_SOFT_TILE    (10*16)

void doGravity(void)
{
    unsigned int tileX;
    unsigned int tileY;
    ySpeed = Y_SPEED;

    // Convert player relative screen position to
    // absolute level map.
    tileX = (INT(x) + INT(scrollX * -1) - 4) >> 3;
    tileY = INT(y) >> 3;

#ifdef DEBUG
    {
        char str[33];
        sprintf(str, "tileX=%3d", tileX);
        print(str, 1, 23);
    }
#endif

    // If tile below players position is solid
    // zero gravity.
    if (levels[tileY][tileX] >= ID_SOFT_TILE
            || levels[tileY][tileX + 1] >= ID_SOFT_TILE)
    {
        ySpeed = 0;
        y &= 0xfff0;
        falling = FALSE;
    }
    else
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
}
