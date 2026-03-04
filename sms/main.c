#include <sms.h>
#include <stdio.h>
#include "SMSlib/SMSlib.h"

unsigned char pal1[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char pal2[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
                        0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

#define VDP_REG_OVERSCAN 0x87

void main(void)
{
    int x = 124;
    int y = -8;
    char sprite;

    sms_vdp_set_write_address(0x0000);
    sms_copy_font_8x8_to_vram(standard_font, 255, 0, 15);

    SMS_loadBGPalette(pal1);
    SMS_loadSpritePalette(pal2);

    // Set overscan color from the sprite palette
    set_vdp_reg(VDP_REG_OVERSCAN, 0x00);
    // Select graphics mode 4 (256x192, 16 colors)
    set_vdp_reg(VDP_REG_FLAGS0, VDP_REG_FLAGS0_CHANGE);
    // Enable screen and frame interrupt
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_BIT7 | VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    printf("Hello, stdio!\rIs it working?\rI hope so.");
    gotoxy(5, 5);
    printf("Hello, gotoxy(%d, %d)!", 5, 5);

    // Initialize the sprite system
    SMS_initSprites();

    // Add a sprite at position (x, y) with tile index 0x40
    sprite = SMS_addSprite(x, y, 0x40);

    for (;;)
    {
        __asm__("halt");
        SMS_updateSpritePosition(sprite, x, y);
        SMS_copySpritestoSAT();
        if (++y >= 0xc0)
            y = -8;
    }
}
