#include <sms.h>
#include <stdio.h>

#define TILEMAP_BASE    	0x3800
#define	SPRITE_INFO_TABLE	0x3f00

static unsigned char textPal[] = {0x00, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f};

#asm
section rodata_user
_tilesheetPal:
    binary  "tilesheet.nxp"
_tilesheet:
    binary  "tilesheet.nxt"
_tilesheetEnd:
_titlePal:
    include "title_pal.inc"
_titlePalEnd:
_tiles:
    include "tiles.inc"
_tilesEnd:
_tileMap:
    include "tilemap.inc"
_tileMapEnd:
section code_compiler
#endasm

extern unsigned char tilesheetPal;
extern unsigned char tilesheetPalEnd;
extern unsigned char tilesheet;
extern unsigned char tilesheetEnd;
extern unsigned char titlePal;
extern unsigned char titlePalEnd;
extern unsigned char tiles;
extern unsigned char tilesEnd;
extern unsigned int tileMap;

unsigned char __FASTCALL__ readVRAM(unsigned char data)
{
#asm
    push    af
    in      a, ($be)
    ld      l, a
    ld      h, 0
    pop     af
#endasm
}

void __FASTCALL__ writeVRAM(unsigned char data)
{
#asm
    push    af
    ld      a, l            ; Data
    out     ($be), a
    pop     af
#endasm
}

void __FASTCALL__ putTile(unsigned char tile)
{
#asm
    push    af
    ld      a, l            ; Tile ID
    out     ($be), a
    ld      a, h            ; Attribute
    out     ($be), a
    pop     af
#endasm
}

void __FASTCALL__ setVRAMAddr(unsigned int addr)
{
#asm
    push    af
    ld      a,l
    out     ($bf),a
    ld      a,h
    or      $40
    out     ($bf),a
    pop     af
#endasm
}

void __FASTCALL__ fillScreen(unsigned int tile)
{
#asm
    push    af
    push    bc
    push    hl

    xor     a
    out     ($bf),a
    ld      a,TILEMAP_BASE>>8
    or      $40
    out     ($bf),a

    ld      bc, 0x0003
l1:
    ld      a, l            ; Tile ID
    out     ($be), a
    ld      a, h            ; Attribute
    out     ($be), a
    djnz    l1

    dec     c
    jr      nz, l1

    pop     hl
    pop     bc
    pop     af
#endasm
}

void main()
{
    int n;

    // Clear 16KB of VRAM
    clear_vram();
    // Disable all sprites by writing 0xd0
    // to the Y location of the first sprite
    setVRAMAddr(SPRITE_INFO_TABLE);
    writeVRAM(0xd0);

    load_tiles(&tiles, 0, (&tilesEnd - &tiles) / 32, 4);
    load_palette(&titlePal, 0, &titlePalEnd - &titlePal);
    set_bkg_map(&tileMap, 0, 0, 32, 24);
    // Enable screen and frame interrupts
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    // Wait for 5 seconds
    for (n=0; n<60*5; n++)
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
    for (n=0; n<60*5; n++)
    {
        __asm__("halt");
    }

    set_vdp_reg(VDP_REG_FLAGS1, 0);
    load_palette(&tilesheetPal, 0, 16);
    load_tiles(&tilesheet, 0, 256, 4);
    fillScreen(0x0b);
    // Enable screen and frame interrupts
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);

    for(int y=0; y<16; y++)
    {
        setVRAMAddr(TILEMAP_BASE + (y<<6));
        for(int x=0; x<16; x++)
        {
            putTile((y*16)+x);
        }
    }

    while(1)
        __asm__("halt");

}
