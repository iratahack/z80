#include <sms.h>
#include <stdio.h>

static unsigned char textPal[] = {0x00, 0x3f};

#asm
section rodata_user
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

extern unsigned char titlePal;
extern unsigned char titlePalEnd;
extern unsigned char tiles;
extern unsigned char tilesEnd;
extern unsigned int tileMap;

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

void __FASTCALL__ clearScreen(void)
{
#asm
    push    af
    push    bc
    push    hl

    ld      hl, 0x3800
    ld      a,l
    out     ($bf),a
    ld      a,h
    or      $40
    out     ($bf),a

    ld      bc, 0x0003
l1:
    ld      a, ' '          ; SPACE
    out     ($be), a        ; Character number
    xor     a
    out     ($be), a        ; Attribute number

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
    load_palette(textPal, 0, 2);
    load_tiles(standard_font, 0, 256, 1);
    clearScreen();
    gotoxy(13, 11);
    printf("Done!\n");
    set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_SCREEN | VDP_REG_FLAGS1_VINT);
}
