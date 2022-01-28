#include <sms.h>
#include <stdio.h>

extern void setVRAMAddr(uint16_t addr) __z88dk_fastcall;
extern void writeVRAM(uint8_t) __z88dk_fastcall;
extern void fillScreen(uint16_t tile) __z88dk_fastcall;
extern void putTile(uint16_t tile) __z88dk_fastcall;
extern void loadFullMap(uint16_t *addr) __z88dk_fastcall;
extern void loadTileset(uint8_t *addr, uint16_t count) __z88dk_fastcall;

#define TILEMAP_BASE 0x3800
#define SPRITE_INFO_TABLE 0x3f00

static const unsigned char textPal[] =
{ 0x00, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f,
        0x3f, 0x3f, 0x3f };

extern unsigned char tilesheetPal;
extern unsigned char tilesheet;
extern unsigned char titlePal;
extern unsigned char tiles;
extern unsigned char tilesEnd;
extern unsigned int tileMap;

void main()
{
    // Clear 16KB of VRAM
    clear_vram();
    // Disable all sprites by writing 0xd0
    // to the Y location of the first sprite
    setVRAMAddr(SPRITE_INFO_TABLE);
    writeVRAM(0xd0);

    loadTileset(&tiles, (&tilesEnd - &tiles));
    load_palette(&titlePal, 0, 16);
    loadFullMap(&tileMap);
    // Enable screen and frame interrupts
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    // Wait for 5 seconds
    for (int n = 0; n < 60 * 5; n++)
    {
        __asm__("halt");
    }

    set_vdp_reg(VDP_REG_FLAGS1, 0);
    load_palette(textPal, 0, 16);
    load_tiles(standard_font, 0, 256, 1);
    fillScreen(' ');
    // Enable screen and frame interrupts
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    gotoxy(13, 11);
    printf("Done!\n");

    // Wait for 5 seconds
    for (int n = 0; n < 60 * 5; n++)
    {
        __asm__("halt");
    }

    set_vdp_reg(VDP_REG_FLAGS1, 0);
    load_palette(&tilesheetPal, 0, 16);
    load_tiles(&tilesheet, 0, 256, 4);
    fillScreen(0x0b);
    // Enable screen and frame interrupts
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    for (int y = 0; y < 16; y++)
    {
        setVRAMAddr(TILEMAP_BASE + (y << 6));
        for (int x = 0; x < 16; x++)
        {
            putTile((y * 16) + x);
        }
    }

    while (1)
        __asm__("halt");
}
