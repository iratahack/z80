#include <sms.h>
#include <stdio.h>

extern void setVRAMAddr(uint16_t addr)
__z88dk_fastcall;
extern void writeVRAM( uint8_t)
__z88dk_fastcall;
extern void fillScreen(uint16_t tile)
__z88dk_fastcall;
extern void putTile(uint16_t tile)
__z88dk_fastcall;
extern void loadFullMap(uint16_t *addr)
__z88dk_fastcall;
extern void loadTileset(uint8_t *addr, uint16_t count)
__z88dk_fastcall;
extern void setSpriteXY(uint8_t spriteID, uint8_t xPos, uint8_t yPos)
__z88dk_fastcall;
extern void setSpritePattern(uint8_t spriteID, uint8_t patternID)
__z88dk_fastcall;
extern uint16_t readJoypad(void)
__z88dk_fastcall;
extern uint16_t readVCount(void)
__z88dk_fastcall;
extern uint16_t PSGInit(void)
__z88dk_fastcall;
extern uint16_t PSGFrame(void)
__z88dk_fastcall;
extern uint16_t PSGPlay(uint8_t *psg)
__z88dk_fastcall;
extern void bank(uint8_t bank)
__z88dk_fastcall;

#define TILEMAP_BASE 0x3800
#define SPRITE_INFO_TABLE 0x3f00
#define VDP_REG_SPRITE_PATTERN_BASE 0x86
#define FONT_TILE_OFFSET 0x100
#define RIGHT_SPRITE    (FONT_TILE_OFFSET + 96)
#define LEFT_SPRITE     (RIGHT_SPRITE + 20)
#define UP  0x01
#define DOWN  0x02
#define LEFT  0x04
#define RIGHT  0x08

static const unsigned char blackPal[] =
{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00 };

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

void print(uint8_t *string, uint8_t y, uint8_t x)
{
    uint16_t tile;

    setVRAMAddr(TILEMAP_BASE + (y << 6) + (x << 1));

    while ((tile = *string++))
    {
        putTile((tile - 32) + FONT_TILE_OFFSET);
    }
}

void main()
{
    uint8_t x = (256 / 2) - 4;
    uint8_t y = (192 / 2) - 4;
    uint16_t startCount = 0;
    uint16_t endCount = 0;
    uint8_t str[33];
    uint16_t sprite = RIGHT_SPRITE + ((x % 5) << 2);
    uint16_t dir;

    add_raster_int(PSGFrame);
    PSGInit();
    PSGPlay(music);

    // Clear VRAM and CRAM
    clear_vram();
    load_palette(blackPal, 0, 16);
    load_palette(blackPal, 16, 16);
    // Disable all sprites by writing 0xd0
    // to the Y location of the first sprite
    setVRAMAddr(SPRITE_INFO_TABLE);
    for (int n = 0; n < 64; n++)
        writeVRAM(0xd0);

    bank(4);
    load_tiles(tiles, 0, (&tilesEnd - &tiles) / 32, 4);
    set_bkg_map(tileMap, 0, 0, 32, 24);
    load_palette(titlePal, 0, 16);
    // Enable screen, frame interrupt & 8x16 sprites
    set_vdp_reg(VDP_REG_FLAGS1,
            VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT | VDP_REG_FLAGS1_8x16);
    // Sprites use tiles >= 256
    set_vdp_reg(VDP_REG_SPRITE_PATTERN_BASE, 0x04);

    // Wait for 5 seconds
    for (int n = 0; n < 60 * 5; n++)
    {
        __asm__("halt");
    }

    load_palette(blackPal, 0, 16);
    load_palette(blackPal, 16, 16);

    bank(3);
    fillScreen(0x0b);
    load_tiles(tilesheet, 0, 256, 4);
    load_tiles(font, FONT_TILE_OFFSET, 96, 1);
    load_tiles(knightTiles, RIGHT_SPRITE, 40, 4);
    load_palette(tilesheetPal, 0, 16);
    load_palette(knightPalette, 16, 16);
    bank(2);

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
        startCount = readVCount();

        // Read joypad 1&2 inputs
        dir = readJoypad();

        // Update sprite position
        if (!(dir & UP))
        {
            if (y > 0)
                y--;
        }
        if (!(dir & DOWN))
        {
            if (y < (192 - 16))
                y++;
        }
        if (!(dir & LEFT))
        {
            if (x > 0)
                x--;
            sprite = LEFT_SPRITE + ((x % 5) << 2);
        }
        if (!(dir & RIGHT))
        {
            if (x < (256 - 16))
                x++;
            sprite = RIGHT_SPRITE + ((x % 5) << 2);
        }

        // Update sprite pattern for animation
        set_sprite(0, x, y, sprite);
        set_sprite(1, x + 8, y, sprite + 2);
        endCount = readVCount();

        // Display the co-ords for sprite top-left
        sprintf(str, "X=%3d, Y=%3d, V-Count=%3d", x, y, endCount - startCount);
        print(str, 23, 0);
    }
}
