#ifndef _vdp_h_
#define _vdp_h_
#include <stdio.h>

#define LEVEL_MAP_WIDTH 128
#define LEVEL_MAP_HEIGHT 126
#define PATTERN_BASE 0x0000
#define TILEMAP_BASE 0x3800
#define SPRITE_INFO_TABLE 0x3f00
#define VDP_Data 0xbe
#define VDP_Command 0xbf
#define VDP_VRAM_Access 0x40
#define VDP_CRAM_Access 0xc0
#define FONT_TILE_OFFSET 0x100

extern unsigned char levels[LEVEL_MAP_HEIGHT][LEVEL_MAP_WIDTH];
extern unsigned char tilesheetPal[];
extern unsigned char tilesheet[];
extern unsigned char font[];
extern unsigned char knightTiles[];
extern unsigned char knightPalette[];

extern void setVRAMAddr(uint16_t addr)
__z88dk_fastcall;
extern void writeVRAM(uint8_t data)
__z88dk_fastcall;
extern void fillScreen(uint16_t tileID)
__z88dk_fastcall;
extern void putTile(uint16_t tileID)
__z88dk_fastcall;
extern void loadFullMap(uint16_t *addr)
__z88dk_fastcall;
extern void bank(uint8_t bank)
__z88dk_fastcall;
extern void scrollx(uint8_t x)
__z88dk_fastcall;
extern void loadTileset(uint8_t *addr, uint16_t count);
extern void setSpriteXY(uint8_t spriteID, uint8_t xPos, uint8_t yPos);
extern void setSpritePattern(uint8_t spriteID, uint8_t patternID);
extern uint16_t readJoypad(void);
extern uint16_t readVCount(void);

#endif
