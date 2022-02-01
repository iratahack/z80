#ifndef _vdp_h_
#define _vdp_h_

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
extern void bank(uint8_t bank)
__z88dk_fastcall;

#define PATTERN_BASE 0x0000
#define TILEMAP_BASE 0x3800
#define SPRITE_INFO_TABLE 0x3f00
#define VDP_Data 0xbe
#define VDP_Command 0xbf

#endif
