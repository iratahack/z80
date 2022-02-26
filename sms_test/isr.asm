
        defc    TILEMAP_BASE=0x3800
        defc    PATTERN_BASE=0x0000
        defc    SPRITE_INFO_TABLE=0x3f00
        defc    VDP_Data=0xbe
        defc    VDP_Command=0xbf
        defc    VDP_VCount=0x7e
        defc    VDP_VRAM_Access=0x40
        defc    VDP_CRAM_Access=0xc0

        #define     VDP_CMD_SET_PALETTE0_BIT 0
        #define     VDP_CMD_SET_PALETTE1_BIT 1
        #define     VDP_CMD_FILL_SCREEN_BIT 2
        #define     VDP_CMD_LOAD_TILES_BIT 3
        #define     VDP_CMD_SPRITE_BIT 4
        #define     VDP_CMD_LOAD_FONT 5

        public  _isr
        public  _VDPFunc
        public  _palette0
        public  _palette1
        public  _blankTile
        public  _tileData
        public  _tileLength
        public  _tileOffset

        extern  _PSGFrame
        extern  _VDPReg1
        extern  _setSprite
        extern  asm_load_palette
        extern  asm_load_tiles
_isr:
IF  0
        ; Disable screen
        ld      a, (_VDPReg1)
        and     0xbf
        out     (0xbf), a
        ld      a, 0x81
        out     (0xbf), a

        ld      a, (_VDPFunc)

        bit     VDP_CMD_SET_PALETTE0_BIT, a
        call    nz, setPalette0
        bit     VDP_CMD_SET_PALETTE1_BIT, a
        call    nz, setPalette1
        bit     VDP_CMD_FILL_SCREEN_BIT, a
        call    nz, fillScreen
        bit     VDP_CMD_LOAD_TILES_BIT, a
        call    nz, loadTiles
        bit     VDP_CMD_SPRITE_BIT, a
        call    nz, _setSprite
        bit     VDP_CMD_LOAD_FONT, a
        call    nz, _loadFont

        ld      (_VDPFunc), a

        ; Enable screen
        ld      a, (_VDPReg1)
        out     (0xbf), a
        ld      a, 0x81
        out     (0xbf), a
ENDIF
        call    _PSGFrame

        ret

_loadFont:
        xor     1<<VDP_CMD_LOAD_FONT
        push    af

        ld      hl, (_tileOffset)
        ld      a, l
        out     (VDP_Command), a
        ld      a, h
        or      VDP_VRAM_Access
        out     (VDP_Command), a

        ld      bc, (_tileLength)
        REPT    2
        srl     b
        rr      c
        ENDR
        ld      hl, (_tileData)

writeFontData:
        ld      a, (hl)
        inc     hl
        out     (VDP_Data), a
        xor     a
        out     (VDP_Data), a
        out     (VDP_Data), a
        out     (VDP_Data), a
        dec     bc
        ld      a, b
        or      c
        jr      nz, writeFontData

        pop     af
        ret

IF  1
loadTiles:
        xor     0x08
        push    af

        ld      hl, (_tileOffset)
        ld      a, l
        out     (VDP_Command), a
        ld      a, h
        or      VDP_VRAM_Access
        out     (VDP_Command), a

        ld      bc, (_tileLength)
        ld      hl, (_tileData)

        ld      a, b
        or      a
        jr      z, noBlock

writeTileData:
        push    bc

        ; Send 256 bytes to VRAM
        ld      bc, VDP_Data
        otir

        pop     bc
        djnz    writeTileData

noBlock:
        ld      a, c
        or      a
        jr      z, done

        ; Send remaining bytes to VRAM
        ld      b, a
        ld      c, VDP_Data
        otir
done:
        pop     af
        ret
ELSE
loadTiles:
        xor     0x08
        push    af
        push    ix

        ld      hl, (_tileOffset)
        REPT    5
        srl     h
        rr      l
        ENDR

        ld      ix, (_tileData)
        ld      bc, (_tileLength)
        REPT    5
        srl     b
        rr      c
        ENDR

        ld      d, 4
        ; Parameters:
        ; hl = tile number to start at
        ; ix = location of tile data
        ; bc = No. of tiles to load
        ; d  = bits per pixel
        call    asm_load_tiles

        pop     ix
        pop     af
        ret
ENDIF

fillScreen:
        xor     0x04
        push    af

        ld      hl, (_blankTile)        ;

        ; Reset the VRAM address
        ld      b, 0
        ld      a, 128
        out     (VDP_Command), a
        ld      a, +(TILEMAP_BASE>>8)|VDP_VRAM_Access
        out     (VDP_Command), a

        ; C - block count, where each block is 256 bytes
        ; B - Byte count for each block 0 = 256 bytes
        ld      c, 0x03
fsLoop:
        ld      a, l                    ; 4 Tile ID
        out     (VDP_Data), a

        ; 12
        REPT    3
        nop
        ENDR

        ld      a, h                    ; 4 Attribute
        out     (VDP_Data), a
        djnz    fsLoop

        dec     c
        jr      nz, fsLoop

        pop     af
        ret

IF  1
setPalette0:
        xor     0x01
        push    af
        xor     a                       ; Start palette index
        ld      hl, (_palette0)         ; Palette data
        jr      setPalette

setPalette1:
        xor     0x02
        push    af
        ld      a, 0x10                 ; Start palette index
        ld      hl, (_palette1)         ; Palette data

setPalette:
        out     (0xbf), a
        ld      a, 0xc0
        out     (0xbf), a

        ld      c, 0xbe
        REPT    16
        outi
        ENDR

        pop     af
        ret
ELSE
setPalette0:
        xor     0x01
        push    af
        ld      bc, 0x1000
        ld      hl, (_palette0)         ; Palette data
        jr      setPalette
setPalette1:
        xor     0x02
        push    af
        ld      bc, 0x1010
        ld      hl, (_palette1)         ; Palette data
setPalette:
        ; Parameters:
        ; hl = location
        ; b  = number of values to write
        ; c  = palette index to start at (<32)
        call    asm_load_palette
        pop     af
        ret
ENDIF

        section bss_user
_VDPFunc:
        ds      1
_palette0:
        ds      2
_palette1:
        ds      2
_blankTile:
        ds      2
_tileData:
        ds      2
_tileLength:
        ds      2
_tileOffset:
        ds      2
