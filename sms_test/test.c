#include <sms.h>
#include <stdio.h>

#define TILEMAP_BASE    	0x3800
#define	SPRITE_INFO_TABLE	0x3f00
#define MAX_TILES           0x1c0

static const unsigned char textPal[] = {0x00, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f};

unsigned char buffer[16];

#asm
section rodata_user
_tilesheetPal:
    binary  "tilesheet.nxp"
_tilesheet:
    binary  "tilesheet.nxt"
_tilesheetEnd:
_titlePal:
    binary "title2.nxp"
_titlePalEnd:
_tiles:
    binary "title2.nxt"
_tilesEnd:
_tileMap:
    binary "title2.nxm"
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

void __FASTCALL__ setCRAMAddr(unsigned int addr)
{
#asm
    push    af
    ld      a,l
    out     ($bf),a
    ld      a,h
    or      $c0
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

void __FASTCALL__ loadCompressedPalette(uint8_t *data)
{
#asm
        push    af
        push    de

; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas
; "Standard" version (69 bytes only)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------
        ld      de, 0xc090

dzx0_standard:
        ld      bc, $ffff               ; preserve default offset 1
        push    bc
        inc     bc
        ld      a, $80

dzx0s_literals:
        call    dzx0s_elias             ; obtain length
;        ldir                            ; copy literals
        call    outBytes
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0s_new_offset
        call    dzx0s_elias             ; obtain length
dzx0s_copy:
        ex      (sp), hl                ; preserve source, restore offset
        push    hl                      ; preserve offset
        add     hl, de                  ; calculate destination - offset
;        ldir                            ; copy from offset
        call    outBytes
        pop     hl                      ; restore offset
        ex      (sp), hl                ; preserve offset, restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0s_literals

dzx0s_new_offset:
        call    dzx0s_elias             ; obtain offset MSB
        ex      af, af'
        pop     af                      ; discard last offset
        xor     a                       ; adjust for negative offset
        sub     c
;        ret     z                       ; check end marker
        jr      z, done
        ld      b, a
        ex      af, af'
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        push    bc                      ; preserve new offset
        ld      bc, 1                   ; obtain length
        call    nc, dzx0s_elias_backtrack
        inc     bc
        jr      dzx0s_copy

dzx0s_elias:
        inc     c                       ; interlaced Elias gamma coding
dzx0s_elias_loop:
        add     a, a
        jr      nz, dzx0s_elias_skip
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
dzx0s_elias_skip:
        ret     c
dzx0s_elias_backtrack:
        add     a, a
        rl      c
        rl      b
        jr      dzx0s_elias_loop

        ;
        ; Input:
        ;   HL - Data source address
        ;   BC - Data length
outBytes:
        push    af

outLoop:
        ld      a, (hl)
        inc     hl
        out     ($be), a
        ld      (de), a
        inc     de
        dec     bc
        ld      a, b
        or      c
        jr      nz, outLoop

        pop     af
        ret

done:
        pop     de
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
//    load_tiles(&tiles, 0, MAX_TILES, 4);
    load_palette(&titlePal, 0, &titlePalEnd - &titlePal);
//    setCRAMAddr(0x0000);
//    loadCompressedPalette(&titlePal);
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
