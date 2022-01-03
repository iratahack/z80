        public  _main

        extern  levels
        extern  sprite0

        include "defines.inc"
sprite_count    EQU 5

        section BANK_2
        org     0x8000
        section CODE_2
vectors:
        ds      0x101, 0x81             ; 257 byte vector table
        ds      0x80, 0x55              ; Stack area
stack:

isr:                                    ; ISR do nothing for now (0x8181)
        ei
        reti

        ; Program entry point (0x8184)
_main:
        nextreg IO_TurboMode, 0x00      ; CPU speed (0=3.5Mhz, 1=7Mhz, 2=14 Mhz )

        ld      sp, stack               ; Set stack pointer

        ; Setup interrupt mode 2
        ld      a, vectors>>8           ; Vector table bits 15:8
        ld      i, a
        im      2
        ei

        include "setPorts.inc"

	; Clear ULA bitmap and attribute area
        ld      hl, screen
        ld      (hl), 0
        ld      de, screen+1
        ld      bc, 6912-1
        ldir

        ; Clear the tilemap area
        ld      hl, tilemap
        ld      (hl), 0x0b              ; Blank tile
        ld      de, tilemap+1
        ld      bc, 40*32-1
        ldir

        ; Display a tile map
        ld      hl, levels+32
        ld      de, tilemap+4+40*7
        ld      b, 24
yloop:
        push    bc

        ld      bc, 32
        ldir

        add     de, 8
        add     hl, 128-32

        pop     bc
        djnz    yloop

sprite:
        ; turn on all sprites
        nextreg IO_SpriteAndLayers, 0x01

        call    setupSprites

        nextreg IO_SpriteNumber, 0x00   ; Select sprite index 0

        ; Write sprite pattern data
        ld      hl, sprite0
        ld      b, sprite_count
nextPattern:
        push    bc
        ld      c, IO_SpritePattern     ; copy sprite data to through register 0x5B
        ld      b, 0                    ; do a 256 bytes which is 0 this and the prevous like could be bc,0x005b
        otir                            ; send that
        pop     bc
        djnz    nextPattern

        ; tell the machine we will copy the palette one element at a time
        ; bit 7 = ‘1’ to disable palette write auto-increment.
        ; bits 6-4 = Select palette for reading or writing:
        ; 000 = ULA first palette
        ; 100 = ULA second palette
        ; 001 = Layer 2 first palette
        ; 101 = Layer 2 second palette
        ; 010 = Sprites first palette
        ; 110 = Sprites second palette
        ; 011 = Tilemap first palette
        ; 111 = Tilemap second palette
        ; bit 3 = Select Sprites palette (0 = first palette, 1 = second palette)
        ; bit 2 = Select Layer 2 palette (0 = first palette, 1 = second palette)
        ; bit 1 = Select ULA palette (0 = first palette, 1 = second palette)
        ; bit 0 = Enabe ULANext mode if 1. (0 after a reset)
        ; Select sprites first palette
        nextreg IO_TileMapPaletteContr, %00100000
        xor     a                       ; Palette start index
        ; Number of colors
        ld      b, sprite_palette_count&0xff
        ld      hl, sprite_palette      ; Pointer to palette
        call    setPalette              ; Do it!

mainLoop:
        halt
        call    animateSprites

        ; Check for collision
        ld      bc, IO_SpriteFlags
        in      a, (c)
        and     0x01
        rlca
        or      MIC_DISABLE
        out     (IO_Border), a

        ; Move sprite 0 to the right so we can see how it animates
        ld      ix, spriteList
        inc     (ix+attrib0)
        ld      a, (ix+attrib0)
        nextreg IO_SpriteNumber, 0
        nextreg IO_SpriteAttrib0, a

        jp      mainLoop


        ; Input:
        ;       None
        ;
animateSprites:
        ld      ix, spriteList
        ld      de, SIZEOF_sprite

animateSprite:
        ld      a, (ix+spriteIndex)
        cp      0x80
        ret     z

        dec     (ix+currentFrameCount)
        jr      nz, noAnimate

        ; Select the sprite
        nextreg IO_SpriteNumber, a

        ; Reload the frame count
        ld      a, (ix+frameCount)
        ld      (ix+currentFrameCount), a

        ; Compare current pattern with max pattern
        ld      a, (ix+attrib3)
        ld      c, a                    ; Save attrib3
        and     %00011111               ; Get pattern

        cp      (ix+endPtn)             ; Compare with end pattern
        jr      z, patternReset         ; If it's the last pattern reset to first

        ld      a, c
        inc     a                       ; Increment pattern index
patternResetDone:
        nextreg IO_SpriteAttrib3, a
        ld      (ix+attrib3), a

noAnimate:
        ; Move to the next sprite
        add     ix, de
        jr      animateSprite

patternReset:
        ld      a, c
        and     %11100000               ; Remove pattern index
        or      (ix+startPtn)           ; OR start pattern
        jr      patternResetDone

        ; Input:
        ;       None
        ;
        ; Output:
        ;       a, hl - Corrupt
setupSprites:
        ld      hl, spriteList
nextSprite:
        ld      a, (hl)
        cp      0x80
        ret     z

        inc     hl

        nextreg IO_SpriteNumber, a

        ld      a, (hl)
        inc     hl
        ; Sprite Attribute 0
        ; bits 7-0 = LSB of X coordinate
        nextreg IO_SpriteAttrib0, a

        ld      a, (hl)
        inc     hl
        ; Sprite Attribute 1
        ; bits 7-0 = LSB of Y coordinate
        nextreg IO_SpriteAttrib1, a

        ld      a, (hl)
        inc     hl
        ; Sprite Attribute 2
        ; bits 7-4 = Palette offset added to top 4 bits of sprite colour index
        ; bit 3 = X mirror
        ; bit 2 = Y mirror
        ; bit 1 = Rotate
        ; bit 0 = MSB of X coordinate
        nextreg IO_SpriteAttrib2, a

        ld      a, (hl)
        inc     hl
        ; Sprite Attribute 3
        ; bit 7 = Visible flag (1 = displayed)
        ; bit 6 = Extended attribute (1 = Sprite Attribute 4 is active)
        ; bits 5-0 = Pattern used by sprite (0-63)
        nextreg IO_SpriteAttrib3, a

        ld      a, (hl)
        ; Sprite Attribute 4
        ; bit 7 = H (1 = sprite uses 4-bit patterns)
        ; bit 6 = N6 (0 = use the first 128 bytes of the pattern else use the last 128 bytes)
        ; bit 5 = 1 if relative sprites are composite, 0 if relative sprites are unified
        ; Scaling
        ; bits 4-3 = X scaling (00 = 1x, 01 = 2x, 10 = 4x, 11 = 8x)
        ; bits 2-1 = Y scaling (00 = 1x, 01 = 2x, 10 = 4x, 11 = 8x)
        ; bit 0 = MSB of Y coordinate
        nextreg IO_SpriteAttrib4, a

        ld      a, SIZEOF_sprite-5
        add     hl, a
        jp      nextSprite

        ; Input:
        ;       hl - Pointer to palette data
        ;       b  - # of palette entries
        ;       a  - Palette start index
        ;
        ; Output:
        ;       hl, b, a - Corrupt
setPalette:
        nextreg IO_PaletteIndex, a      ; Palette index
nextColor:
        ld      a, (hl)                 ; get the colour from the palette array
        inc     hl                      ; next element in the array
        nextreg IO_PaletteValue, a      ; write color to palette
        djnz    nextColor               ; next color
        ret

        section RODATA_2
        defvars 0
        {
            spriteIndex ds.b 1
            attrib0     ds.b 1
            attrib1     ds.b 1
            attrib2     ds.b 1
            attrib3     ds.b 1
            attrib4     ds.b 1
            frameCount  ds.b 1
            currentFrameCount   ds.b 1
            startPtn    ds.b 1
            endPtn      ds.b 1
            currentPtn  ds.b 1
            SIZEOF_sprite
        }

spriteList:
        db      0x00                    ; Sprite index
        db      50                      ; X
        db      24*8                    ; Y
        db      0x00                    ; Attribute 2
        db      0xc0                    ; Attribute 3
        db      0x00                    ; Attribute 4
        db      1                       ; Animation frame count
        db      1                       ; Current frame count
        db      0                       ; Start pattern
        db      4                       ; End pattern
        db      0                       ; Current pattern

        db      0x01                    ; Sprite index
        db      100                     ; X
        db      24*8                    ; Y
        db      0x00                    ; Attribute 2
        db      0xc0                    ; Attribute 3
        db      0x00                    ; Attribute 4
        db      25                      ; Animation frame count
        db      25                      ; Current frame count
        db      0                       ; Start pattern
        db      4                       ; End pattern
        db      0                       ; Current pattern

        db      0x80                    ; End of sprite list

tile_palette_count  EQU 16
tile_palette:
        db      0xe3, 0x03, 0x03, 0x18, 0x1b, 0x1f, 0xc0, 0xd8, 0xdb, 0xe0, 0xe7, 0xfc, 0xff, 0x00, 0x00, 0x00

sprite_palette_count    EQU 16
sprite_palette:
        db      0x00, 0x02, 0xa0, 0xa2, 0x14, 0x16, 0xb4, 0xb6, 0x00, 0x03, 0xe0, 0xe7, 0x1c, 0x1f, 0xfc, 0xff

