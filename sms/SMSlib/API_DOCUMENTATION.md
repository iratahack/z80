# SMSlib API Documentation

**SMSlib** is a comprehensive C programming library for developing games and applications for the Sega Master System (SMS) and Game Gear (GG). This library provides high-level abstractions over the hardware while allowing low-level access when needed.

> Part of [devkitSMS](https://github.com/sverx/devkitSMS)

## Table of Contents

1. [Initialization](#initialization)
2. [VDP (Video Display Processor) Features](#vdp-video-display-processor-features)
3. [Tiles & Background Handling](#tiles--background-handling)
4. [Sprite Handling](#sprite-handling)
5. [Color & Palette Functions](#color--palette-functions)
6. [Input/Joypad Handling](#inputjoypad-handling)
7. [ROM Banking & Cartridge Mapping](#rom-banking--cartridge-mapping)
8. [VRAM Memory Functions](#vram-memory-functions)
9. [Text Rendering](#text-rendering)
10. [Data Decompression](#data-decompression)
11. [Interrupt Handling](#interrupt-handling)
12. [ROM Headers](#rom-headers)
13. [Advanced Features](#advanced-features)

---

## Initialization

### `void SMS_init(void)`

Initializes the SMSlib library and VDP hardware.

**Description:**
- Waits for VDP to be ready
- Sets sprite palette color 0 to black
- Initializes VDP registers to default values
- Resets sprite system
- Detects PAL/NTSC region (SMS only, if `VDPTYPE_DETECTION` is enabled)

**Usage:**
```c
void main(void) {
    SMS_init();
    // Now ready to use SMSlib functions
}
```

**Notes:**
- This should be called once at startup
- Not required if using devkitSMS crt0.rel

---

## VDP (Video Display Processor) Features

### VDP Feature Constants

```c
// Group 0 - Display modes and options
#define VDPFEATURE_EXTRAHEIGHT      0x0002    // Enables 224-240 lines modes
#define VDPFEATURE_SHIFTSPRITES     0x0008    // Shifts sprites by 8 pixels
#define VDPFEATURE_HIDEFIRSTCOL     0x0020    // Hides leftmost column (alias: VDPFEATURE_LEFTCOLBLANK)
#define VDPFEATURE_LOCKHSCROLL      0x0040    // Locks horizontal scrolling
#define VDPFEATURE_LOCKVSCROLL      0x0080    // Locks vertical scrolling

// Group 1 - Display modes and resolution
#define VDPFEATURE_ZOOMSPRITES      0x0101    // (Use SMS_setSpriteMode instead)
#define VDPFEATURE_USETALLSPRITES   0x0102    // (Use SMS_setSpriteMode instead)
#define VDPFEATURE_240LINES         0x0108    // SMS II only, PAL only
#define VDPFEATURE_224LINES         0x0110    // SMS II only
#define VDPFEATURE_FRAMEIRQ         0x0120    // Frame interrupt (VBlank)
#define VDPFEATURE_SHOWDISPLAY      0x0140    // Display ON
```

### `void SMS_VDPturnOnFeature(unsigned int feature)`

Enables a VDP feature.

**Parameters:**
- `feature`: One of the VDP feature constants above

**Usage:**
```c
SMS_VDPturnOnFeature(VDPFEATURE_SHOWDISPLAY);  // Turn on display
SMS_VDPturnOnFeature(VDPFEATURE_224LINES);     // Enable 224-line mode
```

### `void SMS_VDPturnOffFeature(unsigned int feature)`

Disables a VDP feature.

**Parameters:**
- `feature`: One of the VDP feature constants

**Usage:**
```c
SMS_VDPturnOffFeature(VDPFEATURE_SHOWDISPLAY); // Turn off display (blanks screen)
```

### Display On/Off Convenience Macros

```c
#define SMS_displayOn()     SMS_VDPturnOnFeature(VDPFEATURE_SHOWDISPLAY)
#define SMS_displayOff()    SMS_VDPturnOffFeature(VDPFEATURE_SHOWDISPLAY)
```

### `void SMS_setBGScrollX(unsigned char scrollX)`

Sets horizontal background scroll position.

**Parameters:**
- `scrollX`: Scroll offset (0-255)

**Usage:**
```c
SMS_setBGScrollX(128);  // Scroll background 128 pixels right
```

### `void SMS_setBGScrollY(unsigned char scrollY)`

Sets vertical background scroll position.

**Parameters:**
- `scrollY`: Scroll offset (0-255)

**Usage:**
```c
SMS_setBGScrollY(64);  // Scroll background 64 pixels down
```

### `void SMS_setBackdropColor(unsigned char entry)`

Sets the backdrop color (fills screen behind tilemap).

**Parameters:**
- `entry`: Palette index (0-15 for SMS, 0-31 for GG)

**Usage:**
```c
SMS_setBackdropColor(0);  // Use first color in palette
```

### `void SMS_setSpriteMode(unsigned char mode)`

Sets sprite display mode.

**Parameters:**
- `mode`: One of:
  - `SPRITEMODE_NORMAL` (0x00) - 8x8 sprites
  - `SPRITEMODE_TALL` (0x01) - 8x16 sprites
  - `SPRITEMODE_ZOOMED` (0x02) - 16x16 sprites (doubled size)
  - `SPRITEMODE_TALL_ZOOMED` (0x03) - 16x16 sprites, tall

**Usage:**
```c
SMS_setSpriteMode(SPRITEMODE_TALL);       // 8x16 sprites
SMS_setSpriteMode(SPRITEMODE_TALL_ZOOMED);// 16x16 sprites
```

### `void SMS_useFirstHalfTilesforSprites(_Bool usefirsthalf)`

Switches which tile set sprites use.

**Parameters:**
- `usefirsthalf`: `true` to use first half of tile set, `false` for second half

**Usage:**
```c
SMS_useFirstHalfTilesforSprites(true);  // Sprites use tiles 0-255
```

### `void SMS_waitForVBlank(void)`

Blocks until VBlank occurs (vertical blanking interval).

**Description:**
- Used for frame synchronization
- Call once per frame to maintain consistent game speed
- Essential for flicker-free sprite updates

**Usage:**
```c
while (1) {
    // Update game logic
    SMS_waitForVBlank();  // Wait for next frame
    // Update display
}
```

### `unsigned char SMS_getVCount(void)`

Returns current vertical counter (scanline).

**Returns:**
- Current scanline number (0-224/240 depending on mode)

**Usage:**
```c
unsigned char line = SMS_getVCount();
if (line == 100) {
    // Scanline 100 raster effect
}
```

---

## Tiles & Background Handling

### Tile Constants and Macros

```c
// PNT (Pattern Name Table) address for writing
#define SMS_PNTAddress           0x7800

// Convert tile coordinates to VRAM address (for writing)
#define XYtoADDR(x,y)            (SMS_PNTAddress|((((unsigned int)(y)<<5)+((unsigned char)(x)))<<1))
#define SMS_setNextTileatXY(x,y) SMS_setAddr(XYtoADDR((x),(y)))

// PNT address for reading
#define SMS_PNTAddress_READ      0x3800
#define XYtoREADADDR(x,y)        (SMS_PNTAddress_READ|((((unsigned int)(y)<<5)+((unsigned char)(x)))<<1))

// VRAM write address for tiles
#define SMS_VDPVRAMWrite         0x4000
#define TILEtoADDR(tile)         (SMS_VDPVRAMWrite|((tile)*32))

// Tile attributes
#define TILE_FLIPPED_X           0x0200    // Horizontal flip
#define TILE_FLIPPED_Y           0x0400    // Vertical flip
#define TILE_USE_SPRITE_PALETTE  0x0800    // Use sprite palette instead of BG palette
#define TILE_PRIORITY            0x1000    // Draw behind sprites
```

### `void SMS_loadTiles(src, tilefrom, size)`

Loads raw tile data into VRAM.

**Parameters:**
- `src`: Pointer to tile data
- `tilefrom`: Starting tile number
- `size`: Number of bytes to copy

**Usage:**
```c
extern const unsigned char my_tiles[];
SMS_loadTiles(my_tiles, 0, 512);  // Load 16 tiles into VRAM
```

### `void SMS_load1bppTiles(const void *src, unsigned int tilefrom, unsigned int size, unsigned char color0, unsigned char color1)`

Loads 1-bit per pixel tile data (monochrome).

**Parameters:**
- `src`: Pointer to 1bpp tile data
- `tilefrom`: Starting tile number
- `size`: Number of bytes
- `color0`: Palette index for 0 pixels
- `color1`: Palette index for 1 pixels

**Usage:**
```c
SMS_load1bppTiles(my_1bpp_tiles, 0, 256, 0, 15);  // Black (0) and white (15)
```

### `void SMS_load2bppTiles(src, tilefrom, size)`

Loads 2-bits per pixel tile data.

**Parameters:**
- `src`: Pointer to 2bpp tile data
- `tilefrom`: Starting tile number
- `size`: Number of bytes

**Usage:**
```c
SMS_load2bppTiles(my_2bpp_tiles, 16, 512);
```

### Compressed Tile Loading Functions

#### `void SMS_loadSTC0compressedTiles(src, tilefrom)`

Loads STC0 compressed tiles.

```c
SMS_loadSTC0compressedTiles(compressed_data, 0);
```

#### `void SMS_loadSTC4compressedTiles(src, tilefrom)`

Loads STC4 compressed tiles.

```c
SMS_loadSTC4compressedTiles(compressed_data, 16);
```

#### `void SMS_loadPSGaidencompressedTiles(src, tilefrom)`

Loads PSGaiden compressed tiles.

```c
SMS_loadPSGaidencompressedTiles(compressed_data, 32);
```

#### `void SMS_loadZX7compressedTiles(src, tilefrom)`

Loads ZX7 compressed tiles.

```c
SMS_loadZX7compressedTiles(compressed_data, 0);
```

#### `void UNSAFE_SMS_loadaPLibcompressedTiles(src, tilefrom)`

Loads aPLib compressed tiles (unsafe, no bounds checking).

```c
UNSAFE_SMS_loadaPLibcompressedTiles(compressed_data, 0);
```

### Tilemap Loading Functions

#### `void SMS_loadTileMap(x, y, src, size)`

Loads raw tilemap data.

**Parameters:**
- `x`, `y`: Starting tile coordinates
- `src`: Pointer to tilemap data
- `size`: Number of bytes to load

```c
SMS_loadTileMap(0, 0, my_tilemap, 1024);  // Load 512 tiles
```

#### `void SMS_loadTileMapArea(x, y, src, width, height)`

Loads a rectangular area of tilemap data.

**Parameters:**
- `x`, `y`: Top-left corner
- `src`: Pointer to tilemap data
- `width`: Width in tiles
- `height`: Height in tiles

```c
SMS_loadTileMapArea(0, 0, level_data, 32, 28);  // Load 32x28 tile area
```

#### `void SMS_loadTileMapColumn(x, y, src, height)`

Loads a single column of tiles.

**Parameters:**
- `x`, `y`: Starting position
- `src`: Pointer to column data
- `height`: Column height in tiles

```c
SMS_loadTileMapColumn(31, 0, scroll_column, 28);  // Load rightmost column
```

#### `void SMS_loadSTMcompressedTileMap(x, y, src)`

Loads STM compressed tilemap.

```c
SMS_loadSTMcompressedTileMap(0, 0, compressed_map);
```

### Tile Reading Functions

#### `unsigned int SMS_getTile(void)`

Reads a tile value from tilemap.

**Returns:**
- Tile number and attributes at current address

**Usage:**
```c
SMS_setAddr(XYtoREADADDR(5, 5));
unsigned int tile = SMS_getTile();  // Read tile at (5,5)
```

#### `void SMS_saveTileMapArea(unsigned char x, unsigned char y, void *dst, unsigned char width, unsigned char height)`

Reads a rectangular area of tilemap to RAM.

```c
unsigned int tilemap_backup[32*28];
SMS_saveTileMapArea(0, 0, tilemap_backup, 32, 28);
```

#### `void SMS_saveTileMapColumn(x, y, dst, height)`

Saves a tilemap column to RAM.

```c
unsigned int column[28];
SMS_saveTileMapColumn(0, 0, column, 28);
```

#### `void SMS_readVRAM(void *dst, unsigned int src, unsigned int size)`

Reads arbitrary VRAM data to RAM.

```c
unsigned char vram_data[1024];
SMS_readVRAM(vram_data, TILEtoADDR(0), 1024);  // Read first 32 tiles
```

---

## Sprite Handling

### Sprite Constants

```c
#define MAXSPRITES              64      // Maximum sprites (usually)
#define METASPRITE_END          0x80    // Marks end of metasprite data
```

### `void SMS_initSprites(void)`

Initializes sprite system.

**Description:**
- Resets sprite table
- Marks all sprites as unused
- Must call before adding any sprites

**Usage:**
```c
SMS_initSprites();
```

### Single Sprite Functions

#### `signed char SMS_addSprite(int x, int y, unsigned char tile)`

Adds a sprite to the display.

**Parameters:**
- `x`: X coordinate
- `y`: Y coordinate
- `tile`: Tile number to display

**Returns:**
- Sprite handle (for later updates) or -1/2 if failed (with NO_SPRITE_CHECKS disabled)
- No return with NO_SPRITE_CHECKS enabled

**Usage:**
```c
signed char my_sprite = SMS_addSprite(100, 80, 5);
if (my_sprite >= 0) {
    // Sprite was added successfully
}
```

### Multiple Adjacent Sprites

#### `signed char SMS_addTwoAdjoiningSprites(int x, int y, unsigned char tile)`

Adds two horizontally adjacent 8x8 sprites.

```c
SMS_addTwoAdjoiningSprites(100, 80, 5);  // Tiles 5 and 6 displayed side-by-side
```

#### `signed char SMS_addThreeAdjoiningSprites(int x, int y, unsigned char tile)`

Adds three horizontally adjacent sprites.

```c
SMS_addThreeAdjoiningSprites(100, 80, 0);  // Tiles 0, 1, 2
```

#### `signed char SMS_addFourAdjoiningSprites(int x, int y, unsigned char tile)`

Adds four horizontally adjacent sprites (2x2 grid).

```c
SMS_addFourAdjoiningSprites(100, 80, 0);  // Tiles 0-3 in 2x2 arrangement
```

### Sprite Manipulation

#### `signed char SMS_reserveSprite(void)`

Reserves a sprite slot without rendering.

**Returns:**
- Sprite handle or -1 if none available

```c
signed char sprite = SMS_reserveSprite();
```

#### `void SMS_updateSpritePosition(signed char sprite, unsigned char x, unsigned char y)`

Updates sprite position.

**Parameters:**
- `sprite`: Sprite handle
- `x`, `y`: New coordinates

**Usage:**
```c
SMS_updateSpritePosition(my_sprite, 120, 100);
```

#### `void SMS_updateSpriteImage(signed char sprite, unsigned char tile)`

Changes sprite graphic.

**Parameters:**
- `sprite`: Sprite handle
- `tile`: New tile number

**Usage:**
```c
SMS_updateSpriteImage(my_sprite, 10);  // Change animation frame
```

#### `void SMS_hideSprite(signed char sprite)`

Hides a sprite without removing it.

**Usage:**
```c
SMS_hideSprite(my_sprite);  // Sprite becomes invisible
```

### Sprite Clipping

#### `void SMS_setClippingWindow(unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1)`

Defines a rectangular region where sprites are visible.

**Parameters:**
- `x0`, `y0`: Top-left corner
- `x1`, `y1`: Bottom-right corner

**Usage:**
```c
SMS_setClippingWindow(16, 16, 240, 224);  // Clip to center area
```

#### `signed char SMS_addSpriteClipping(int x, int y, unsigned char tile)`

Adds sprite with automatic clipping.

**Returns:**
- Sprite handle or -1 if clipped or no sprites available

**Usage:**
```c
if (SMS_addSpriteClipping(x, y, tile) >= 0) {
    // Sprite was visible and added
}
```

### Metasprites

Metasprites are groups of sprites arranged as a single unit.

#### `void SMS_addMetaSprite(int x, int y, void *metasprite)`

Displays a metasprite at given position.

**Parameters:**
- `x`, `y`: Base coordinates
- `metasprite`: Pointer to metasprite data

**Metasprite Format:**
```
Each entry: byte offset_x, byte offset_y, byte tile_number
End with: 0x80
```

**Example:**
```c
const unsigned char player_metasprite[] = {
    0, 0, 0,      // Tile 0 at (0,0)
    8, 0, 1,      // Tile 1 at (8,0)
    0, 8, 2,      // Tile 2 at (0,8)
    8, 8, 3,      // Tile 3 at (8,8)
    0x80          // End marker
};

SMS_addMetaSprite(100, 80, player_metasprite);
```

### Sprite Buffer Management

#### `void SMS_copySpritestoSAT(void)`

Writes sprite table from RAM to hardware (SAT - Sprite Attribute Table).

**Description:**
- Must be called after all sprite operations to display changes
- Typically called once per frame

**Usage:**
```c
SMS_initSprites();
SMS_addSprite(100, 50, 0);
SMS_addSprite(150, 50, 1);
SMS_copySpritestoSAT();  // Display sprites
```

#### `void UNSAFE_SMS_copySpritestoSAT(void)`

Fast sprite buffer update (no safety checks).

---

## Color & Palette Functions

### Palette Constants

```c
// SMS color format: RRGGBB (2 bits each, stored in byte)
#define RGB(r,g,b)        ((r)|((g)<<2)|((b)<<4))
#define RGB8(r,g,b)       (((r)>>6)|(((g)>>6)<<2)|(((b)>>6)<<4))
#define RGBHTML(RGB24bit) (((RGB24bit)>>22)|((((RGB24bit)&0xFFFF)>>14)<<2)|((((RGB24bit)&0xFF)>>6)<<4))

// Game Gear color format: RRRRGGGGBBBB (4 bits each)
#define RGB(r,g,b)        ((r)|((g)<<4)|((b)<<8))
#define RGB8(r,g,b)       (((r)>>4)|(((g)>>4)<<4)|(((b)>>4)<<8))
#define RGBHTML(RGB24bit) (((RGB24bit)>>20)|((((RGB24bit)&0xFFFF)>>12)<<4)|((((RGB24bit)&0xFF)>>4)<<8))
```

### Setting Individual Colors

#### `void SMS_setBGPaletteColor(unsigned char entry, unsigned char color)` (SMS)

Sets a background palette color.

**Parameters:**
- `entry`: Palette index (0-15)
- `color`: Color value (SMS format)

**Usage:**
```c
SMS_setBGPaletteColor(0, RGB(3, 3, 3));  // White
SMS_setBGPaletteColor(1, RGB(0, 0, 0));  // Black
```

#### `void GG_setBGPaletteColor(unsigned char entry, unsigned int color)` (Game Gear)

Sets background palette color (Game Gear).

**Parameters:**
- `entry`: Palette index (0-31)
- `color`: Color value (GG format)

#### `void SMS_setSpritePaletteColor(unsigned char entry, unsigned char color)` (SMS)

Sets sprite palette color.

**Parameters:**
- `entry`: Palette index (0-15)
- `color`: Color value

#### `void GG_setSpritePaletteColor(unsigned char entry, unsigned int color)` (Game Gear)

Sets sprite palette color (Game Gear).

### Loading Full Palettes

#### `void SMS_loadBGPalette(const void *palette)`

Loads complete background palette.

**Parameters:**
- `palette`: Pointer to 16-byte palette data

**Usage:**
```c
extern const unsigned char bg_palette[16];
SMS_loadBGPalette(bg_palette);
```

#### `void SMS_loadSpritePalette(const void *palette)`

Loads complete sprite palette.

```c
extern const unsigned char spr_palette[16];
SMS_loadSpritePalette(spr_palette);
```

#### `void GG_loadBGPalette(const void *palette)` (Game Gear)

Loads Game Gear background palette (32 bytes).

#### `void GG_loadSpritePalette(const void *palette)` (Game Gear)

Loads Game Gear sprite palette (32 bytes).

### Advanced Palette Effects

#### `void SMS_zeroBGPalette(void)`

Fills background palette with black (color 0).

```c
SMS_zeroBGPalette();  // Black out screen
```

#### `void SMS_zeroSpritePalette(void)`

Fills sprite palette with black.

#### `void SMS_loadBGPaletteHalfBrightness(const void *palette)`

Loads palette with half brightness (fade effect).

```c
SMS_loadBGPaletteHalfBrightness(my_palette);
```

#### `void SMS_loadSpritePaletteHalfBrightness(const void *palette)`

Loads sprite palette at half brightness.

#### `void SMS_loadBGPaletteafterColorAddition(const void *palette, const unsigned char addition_color)`

Adds a color to palette entries.

**Usage:**
```c
unsigned char brightness = RGB(1, 1, 1);
SMS_loadBGPaletteafterColorAddition(my_palette, brightness);
```

#### `void SMS_loadSpritePaletteafterColorAddition(const void *palette, const unsigned char addition_color)`

Adds color to sprite palette.

#### `void SMS_loadBGPaletteafterColorSubtraction(const void *palette, const unsigned char subtraction_color)`

Subtracts color from palette.

#### `void SMS_loadSpritePaletteafterColorSubtraction(const void *palette, const unsigned char subtraction_color)`

Subtracts color from sprite palette.

### Color Setting Macros

```c
#define SMS_setNextBGColoratIndex(i)      SMS_setAddr(SMS_CRAMAddress|(i))
#define SMS_setNextSpriteColoratIndex(i)  SMS_setAddr(SMS_CRAMAddress|0x10|(i))

#define GG_setNextBGColoratIndex(i)       SMS_setAddr(SMS_CRAMAddress|((i)<<1))
#define GG_setNextSpriteColoratIndex(i)   SMS_setAddr(SMS_CRAMAddress|0x20|((i)<<1))
```

---

## Input/Joypad Handling

### Input Constants

```c
// Port A (Player 1)
#define PORT_A_KEY_UP           0x0001
#define PORT_A_KEY_DOWN         0x0002
#define PORT_A_KEY_LEFT         0x0004
#define PORT_A_KEY_RIGHT        0x0008
#define PORT_A_KEY_1            0x0010    // Button 1
#define PORT_A_KEY_2            0x0020    // Button 2
#define PORT_A_KEY_START        0x0010    // Alias for button 1

// Port B (Player 2)
#define PORT_B_KEY_UP           0x0040
#define PORT_B_KEY_DOWN         0x0080
#define PORT_B_KEY_LEFT         0x0100
#define PORT_B_KEY_RIGHT        0x0200
#define PORT_B_KEY_1            0x0400
#define PORT_B_KEY_2            0x0800
#define PORT_B_KEY_START        0x0400

// Other inputs
#define RESET_KEY               0x1000    // Reset (SMS I only)
#define PORT_A_TH               0x4000    // Light gun
#define PORT_B_TH               0x8000    // Light gun

// Game Gear
#define GG_KEY_START            0x8000    // START key

// Sega Genesis/MegaDrive pad (SMS only, if MD_PAD_SUPPORT enabled)
#define PORT_A_MD_KEY_Z         0x0001
#define PORT_A_MD_KEY_Y         0x0002
#define PORT_A_MD_KEY_X         0x0004
#define PORT_A_MD_KEY_MODE      0x0008
#define PORT_A_MD_KEY_A         0x0010
#define PORT_A_MD_KEY_START     0x0020
```

### Input Functions

#### `unsigned int SMS_getKeysStatus(void)`

Returns current button state.

**Returns:**
- Bitfield indicating which buttons are pressed

**Usage:**
```c
unsigned int keys = SMS_getKeysStatus();
if (keys & PORT_A_KEY_UP) {
    // Player 1 is pressing up
}
```

#### `unsigned int SMS_getKeysPressed(void)`

Returns buttons pressed this frame (not held from previous frame).

**Usage:**
```c
if (SMS_getKeysPressed() & PORT_A_KEY_1) {
    // Button 1 was just pressed
    jump();
}
```

#### `unsigned int SMS_getKeysHeld(void)`

Returns buttons held continuously since previous frame.

**Usage:**
```c
if (SMS_getKeysHeld() & PORT_A_KEY_1) {
    // Button held down
}
```

#### `unsigned int SMS_getKeysReleased(void)`

Returns buttons released this frame.

**Usage:**
```c
if (SMS_getKeysReleased() & PORT_A_KEY_1) {
    // Button was just released
}
```

### Sega Genesis/MegaDrive Pad (SMS only)

#### `unsigned int SMS_getMDKeysStatus(void)`

Returns Sega Genesis pad buttons (if MD_PAD_SUPPORT enabled).

#### `unsigned int SMS_getMDKeysPressed(void)`

Returns newly pressed Genesis buttons.

#### `unsigned int SMS_getMDKeysHeld(void)`

Returns held Genesis buttons.

#### `unsigned int SMS_getMDKeysReleased(void)`

Returns released Genesis buttons.

### Paddle Controller (SMS only)

#### `_Bool SMS_detectPaddle(unsigned char port)`

Detects if paddle controller is connected.

**Parameters:**
- `port`: PORT_A or PORT_B

**Returns:**
- `true` if paddle detected, `false` otherwise

```c
if (SMS_detectPaddle(PORT_A)) {
    // Use paddle input
}
```

#### `unsigned char SMS_readPaddle(unsigned char port)`

Reads paddle position.

**Parameters:**
- `port`: PORT_A or PORT_B

**Returns:**
- Paddle position (0-255)

```c
unsigned char paddle_x = SMS_readPaddle(PORT_A);
```

### Pause Handling (SMS only)

#### `_Bool SMS_queryPauseRequested(void)`

Checks if pause button was pressed.

**Returns:**
- `true` if pause was requested

```c
if (SMS_queryPauseRequested()) {
    show_pause_menu();
}
```

#### `void SMS_resetPauseRequest(void)`

Clears pause request flag.

```c
SMS_resetPauseRequest();
```

### VDP Type Detection (SMS only)

#### `unsigned char SMS_VDPType(void)` (if VDPTYPE_DETECTION enabled)

Detects PAL/NTSC region.

**Returns:**
- `VDP_PAL` (0x80) for PAL
- `VDP_NTSC` (0x40) for NTSC

**Usage:**
```c
if (SMS_VDPType() == VDP_PAL) {
    // Running on PAL system
}
```

---

## ROM Banking & Cartridge Mapping

### ROM Bank Switching Macros

#### `SMS_mapROMBank(n)`

Selects which ROM bank is visible in slot 2 (0x8000-0xBFFF).

```c
SMS_mapROMBank(0);  // Map bank 0
SMS_mapROMBank(5);  // Map bank 5
```

#### `SMS_getROMBank()`

Returns currently mapped ROM bank.

```c
unsigned char current = SMS_getROMBank();
```

### Bank Preservation Macros

Used to save and restore ROM bank when calling functions that might change it.

```c
void my_function(void) {
    SMS_saveROMBank();      // Save current bank

    SMS_mapROMBank(3);      // Switch to bank 3
    // Access data in bank 3

    SMS_restoreROMBank();   // Restore original bank
}
```

### SRAM (Save RAM) Access

#### `SMS_enableSRAM()`

Enables access to SRAM.

```c
SMS_enableSRAM();
```

#### `SMS_enableSRAMBank(n)`

Enables specific SRAM bank.

```c
SMS_enableSRAMBank(0);  // Enable SRAM bank 0
```

#### `SMS_disableSRAM()`

Disables SRAM access.

```c
SMS_disableSRAM();
```

#### `SMS_SRAM` Array

Direct access to SRAM as byte array.

```c
SMS_enableSRAM();
SMS_SRAM[0] = 42;     // Write to SRAM
unsigned char val = SMS_SRAM[0];  // Read from SRAM
SMS_disableSRAM();
```

### Low-Level Slot Access

For advanced ROM mapping scenarios:

```c
static volatile __at (0xfffd) unsigned char ROM_bank_to_be_mapped_on_slot0;
static volatile __at (0xfffe) unsigned char ROM_bank_to_be_mapped_on_slot1;
static volatile __at (0xffff) unsigned char ROM_bank_to_be_mapped_on_slot2;

static volatile __at (0xfffc) unsigned char SRAM_bank_to_be_mapped_on_slot2;
```

---

## VRAM Memory Functions

### Basic Memory Operations

#### `void SMS_VRAMmemcpy(unsigned int dst, const void *src, unsigned int size)`

Copies data from RAM to VRAM.

**Parameters:**
- `dst`: VRAM destination address (with VDP flags)
- `src`: RAM source pointer
- `size`: Number of bytes

**Usage:**
```c
SMS_VRAMmemcpy(TILEtoADDR(0), tile_data, 256);
```

#### `void SMS_VRAMmemcpy_brief(unsigned int dst, const void *src, unsigned char size)`

Copies small amounts of data to VRAM (faster, limited to 255 bytes).

```c
SMS_VRAMmemcpy_brief(TILEtoADDR(0), tile_data, 32);  // One tile
```

#### `void SMS_VRAMmemset(unsigned int dst, unsigned char value, unsigned int size)`

Fills VRAM with a value.

**Usage:**
```c
SMS_VRAMmemset(TILEtoADDR(0), 0, 256);  // Clear tiles
```

#### `void SMS_VRAMmemsetW(unsigned int dst, unsigned int value, unsigned int size)`

Fills VRAM with 16-bit value.

```c
SMS_VRAMmemsetW(SMS_PNTAddress, 0, 1024);  // Clear tilemap
```

### Fast (Unsafe) VRAM Operations

These functions don't check bounds but are faster:

#### `void UNSAFE_SMS_VRAMmemcpy32(unsigned int dst, const void *src)`

Copies exactly 32 bytes.

```c
UNSAFE_SMS_VRAMmemcpy32(TILEtoADDR(0), tile_data);  // One tile
```

#### `void UNSAFE_SMS_VRAMmemcpy64(unsigned int dst, const void *src)`

Copies exactly 64 bytes (2 tiles).

#### `void UNSAFE_SMS_VRAMmemcpy96(unsigned int dst, const void *src)`

Copies exactly 96 bytes (3 tiles).

#### `void UNSAFE_SMS_VRAMmemcpy128(unsigned int dst, const void *src)`

Copies exactly 128 bytes (4 tiles).

#### `void UNSAFE_SMS_VRAMmemcpy(unsigned int dst, const void *src, unsigned int size)`

Unsafe variable-size copy.

### Unsafe Tile Loading Macros

```c
#define UNSAFE_SMS_load1Tile(src, theTile)               // Copy 1 tile
#define UNSAFE_SMS_load2Tiles(src, tilefrom)             // Copy 2 tiles
#define UNSAFE_SMS_load3Tiles(src, tilefrom)             // Copy 3 tiles
#define UNSAFE_SMS_load4Tiles(src, tilefrom)             // Copy 4 tiles
#define UNSAFE_SMS_loadNTiles(src, tilefrom, tilecount)  // Copy N tiles
#define UNSAFE_SMS_loadTiles(src, tilefrom, size)        // Copy size bytes
```

---

## Text Rendering

### Text Renderer Setup

#### `void SMS_configureTextRenderer(signed int ascii_to_tile_offset)`

Configures text rendering.

**Parameters:**
- `ascii_to_tile_offset`: Offset from ASCII value to tile number

**Usage:**
```c
// ASCII 32 (' ') maps to tile 0
SMS_configureTextRenderer(-32);
```

#### `void SMS_autoSetUpTextRenderer(void)`

Auto-configures text renderer based on loaded font.

```c
SMS_autoSetUpTextRenderer();  // Auto-detect font
```

### Text Output

#### `void SMS_putchar(unsigned char c)`

Outputs single character at current cursor position.

**Parameters:**
- `c`: Character to print

**Usage:**
```c
SMS_putchar('A');
```

#### `void SMS_print(const unsigned char *str)`

Outputs string.

**Parameters:**
- `str`: Null-terminated string

**Usage:**
```c
SMS_print("Hello World");
```

#### `SMS_printatXY(x, y, s)` Macro

Prints string at tile coordinates.

**Usage:**
```c
SMS_printatXY(5, 10, "Score: 1000");
```

---

## Data Decompression

### RAM Decompression

#### `void SMS_decompressZX7(const void *src, void *dst)`

Decompresses ZX7 compressed data to RAM.

**Parameters:**
- `src`: Compressed data pointer
- `dst`: Destination buffer in RAM

**Usage:**
```c
extern const unsigned char level_compressed[];
unsigned char level_data[2048];
SMS_decompressZX7(level_compressed, level_data);
```

#### `void SMS_decompressaPLib(const void *src, void *dst)`

Decompresses aPLib compressed data to RAM.

```c
unsigned char sprite_data[1024];
SMS_decompressaPLib(sprite_compressed, sprite_data);
```

### VRAM Decompression

#### `void SMS_decompressZX7toVRAM(const void *src, unsigned int dst)`

Decompresses ZX7 data directly to VRAM.

```c
SMS_decompressZX7toVRAM(tiles_compressed, TILEtoADDR(0));
```

---

## Interrupt Handling

### Frame Interrupt

#### `void SMS_setFrameInterruptHandler(void (*theHandlerFunction)(void))`

Sets function to call during VBlank.

**Description:**
- Handler is called after VBlank is acknowledged
- Controller status is read before handler
- Disabled with NO_FRAME_INT_HOOK compile flag

**Usage:**
```c
void my_vblank_handler(void) {
    // Update game state
    frame_counter++;
}

SMS_setFrameInterruptHandler(my_vblank_handler);
```

### Line Interrupt

#### `void SMS_setLineInterruptHandler(void (*theHandlerFunction)(void))`

Sets function to call at specific scanline.

**Usage:**
```c
void scanline_effect(void) {
    // Raster effect at scanline
    SMS_setBGScrollX(effect_data[current_line]);
}

SMS_setLineInterruptHandler(scanline_effect);
```

#### `void SMS_setLineCounter(unsigned char count)`

Sets scanline where line interrupt occurs.

**Parameters:**
- `count`: Scanline number

**Usage:**
```c
SMS_setLineCounter(100);  // Interrupt at scanline 100
SMS_enableLineInterrupt();
```

#### Enabling/Disabling Line Interrupt

```c
#define SMS_enableLineInterrupt()   SMS_VDPturnOnFeature(0x0010)
#define SMS_disableLineInterrupt()  SMS_VDPturnOffFeature(0x0010)
```

### Inline Raster Effects

#### `INLINE_SMS_setBGScrollX(scrollX)` Macro

Sets scroll X directly in line interrupt (no interrupt disabling overhead).

**Usage:**
```c
void raster_handler(void) {
    INLINE_SMS_setBGScrollX(raster_scroll[SMS_getVCount()]);
}
```

### VDP Flags

#### `SMS_VDPFlags` Variable

Holds sprite collision and overflow flags.

```c
extern volatile unsigned char SMS_VDPFlags;

#define VDPFLAG_SPRITEOVERFLOW  0x40    // More than 8 sprites per line
#define VDPFLAG_SPRITECOLLISION 0x20    // Sprite collision detected
```

**Usage:**
```c
if (SMS_VDPFlags & VDPFLAG_SPRITECOLLISION) {
    handle_collision();
}
```

---

## ROM Headers

### SEGA ROM Header

#### `SMS_EMBED_SEGA_ROM_HEADER(productCode, revision)` Macro

Embeds SEGA header for 32KB ROM.

**Parameters:**
- `productCode`: Product code
- `revision`: Revision number

**Usage:**
```c
SMS_EMBED_SEGA_ROM_HEADER(123, 0);  // Product 123, revision 0
```

#### `SMS_EMBED_SEGA_ROM_HEADER_16KB(productCode, revision)` Macro

Embeds SEGA header for 16KB ROM.

### SDSC Header

#### `SMS_EMBED_SDSC_HEADER(verMaj, verMin, dateYear, dateMonth, dateDay, author, name, descr)` Macro

Embeds SDSC header with manual date.

**Usage:**
```c
SMS_EMBED_SDSC_HEADER(1, 0, 2024, 3, 5, "My Company", "Game Title", "A cool game");
```

#### `SMS_EMBED_SDSC_HEADER_AUTO_DATE(verMaj, verMin, author, name, descr)` Macro

Embeds SDSC header with auto-updated date.

```c
SMS_EMBED_SDSC_HEADER_AUTO_DATE(1, 0, "Me", "My Game", "My description");
```

---

## Advanced Features

### VDP Register Shadow

```c
extern unsigned char VDPReg[];  // Shadow of VDP registers 0 and 1
```

Used internally to track VDP register state.

### Sprite Attribute Constants

```c
extern unsigned char spritesHeight;      // Current sprite height (8 or 16)
extern unsigned char spritesWidth;       // Current sprite width (8 or 16)
extern unsigned char spritesTileOffset;  // Tile increment per sprite
```

### BIOS Port Value

```c
extern unsigned char SMS_Port3EBIOSvalue;  // Value from BIOS at startup
```

### Debug Output

#### `void SMS_debugPrintf(const unsigned char *format, ...)`

Prints to emulator debug console.

**Parameters:**
- `format`: Printf-style format string
- `...`: Arguments

**Usage:**
```c
SMS_debugPrintf("Sprite %d at (%d,%d)\n", sprite_id, x, y);
```

### Helper Macros

#### `SMS_BYTE_TO_BCD(n)` Macro

Converts byte to Binary Coded Decimal.

```c
unsigned char bcd_value = SMS_BYTE_TO_BCD(42);  // 0x42
```

---

## Compilation Constants

Configure library behavior with compiler flags:

```c
#define TARGET_GG                  // Compile for Game Gear (SMS by default)
#define GG_SECOND_PAD_SUPPORT      // Support second controller on GG
#define MD_PAD_SUPPORT             // Support Sega Genesis pad on SMS
#define NO_SPRITE_CHECKS           // Faster sprites, no error checking
#define NO_FRAME_INT_HOOK          // Disable frame interrupt handler
#define NO_SPRITE_ZOOM             // Disable sprite zoom feature
#define VDPTYPE_DETECTION          // Enable PAL/NTSC detection
```

---

## Common Patterns

### Game Loop

```c
void main(void) {
    SMS_init();

    // Load assets
    SMS_loadTiles(my_tiles, 0, 1024);
    SMS_loadTileMap(0, 0, my_tilemap, 1024);
    SMS_loadBGPalette(my_palette);
    SMS_displayOn();

    while (1) {
        SMS_waitForVBlank();

        // Update game logic
        update_sprites();

        // Update display
        SMS_initSprites();
        SMS_addSprite(player_x, player_y, player_tile);
        SMS_copySpritestoSAT();
    }
}
```

### Scrolling Background

```c
void update_scroll(void) {
    camera_x += scroll_speed;
    SMS_setBGScrollX(camera_x & 0xFF);
}
```

### Sprite Animation

```c
void animate_sprite(signed char sprite) {
    animation_frame = (animation_frame + 1) % FRAME_COUNT;
    SMS_updateSpriteImage(sprite, base_tile + animation_frame);
}
```

### Palette Effects

```c
void fade_in(const unsigned char *palette) {
    unsigned char i;
    for (i = 0; i < 4; i++) {
        SMS_loadBGPaletteHalfBrightness(palette);
        SMS_waitForVBlank();
    }
    SMS_loadBGPalette(palette);
}
```

---

## Notes

- All functions are optimized for Z80 CPU (8-bit processor)
- Some functions use `__z88dk_fastcall` and `__sdcccall` calling conventions
- `__naked` functions are assembly-only with no C prologue/epilogue
- Game Gear and SMS have different color bit depths and capabilities
- VRAM access is atomic with VDP flags - disable interrupts for multi-operation sequences
- Sprite limits: 64 sprites total, 8 per scanline (hardware limitation)

---

## License

Part of [devkitSMS](https://github.com/sverx/devkitSMS)

---

**Last Updated:** 2024
