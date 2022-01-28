        defc    TILEMAP_BASE=0x3800
        defc    PATTERN_BASE=0x0000
        defc    SPRITE_INFO_TABLE=0x3f00

        defc    UP=0x01
        defc    DOWN=0x02
        defc    LEFT=0x04
        defc    RIGHT=0x08

        defc    IO_JOYPAD1=0xdc
        defc    IO_JOYPAD2=0xdd

        public  _setVRAMAddr
        public  _writeVRAM
        public  _font
        public  _tiles
        public  _tileMap
        public  _tilesEnd
        public  _titlePal
        public  _tilesheet
        public  _tilesheetPal
        public  _fillScreen
        public  _putTile
        public  _loadFullMap
        public  _loadTileset

        public  _setSpriteXY
        public  _readJoypad
        public  _setSpritePattern

        section code_user

_setSpritePattern:
        ld      ix, 2
        add     ix, sp

        ld      h, l                    ; Pattern ID
        ld      l, (ix+0)               ; Sprite ID

        ;
        ; Input:
        ;   h - Sprite pattern ID
        ;   l - Sprite ID
        ;
setSpritePattern:
        push    af

        ; Set VRAM address for sprite pattern
        ld      a, l
        add     a
        add     0x81
        out     ($bf), a
        ld      a, SPRITE_INFO_TABLE>>8
        or      $40
        out     ($bf), a

        ld      a, h                    ; Pattern ID
        out     (0xbe), a

        pop     af
        ret

_setSpriteXY:
        ld      ix, 2                   ; Return address
        add     ix, sp

        ld      a, (ix+2)               ; Sprite ID
        ld      b, (ix+0)               ; Sprite Y pos
        ld      c, l                    ; Sprite X pos

setSpriteXY:

        push    af
        ; Set VRAM address for Y location
        out     ($bf), a
        ld      a, SPRITE_INFO_TABLE>>8
        or      $40
        out     ($bf), a

        ; Set the Y location
        ld      a, b
        dec     a
        out     (0xbe), a

        ; Set VRAM address for X location
        pop     af
        add     a
        or      0x80
        out     ($bf), a
        ld      a, SPRITE_INFO_TABLE>>8
        or      $40
        out     ($bf), a

        ; Set the X location
        ld      a, c
        out     (0xbe), a

        ret


_loadTileset:
        ld      ix, 2                   ; Return address & pushed regs
        add     ix, sp

        ; Set VRAM address to start of pattern memory
        xor     a
        out     ($bf), a
        or      $40
        out     ($bf), a

        ld      bc, hl                  ; Length in bytes

        ; Get the address of the pattern data
        ld      l, (ix+0)
        ld      h, (ix+1)

        ld      a, b
        or      a
        jr      z, noBlock


writeTileData:
        push    bc

        ; Send 256 bytes to port 0xbe
        ld      bc, 0x00be
        otir

        pop     bc
        djnz    writeTileData

noBlock:
        ld      a, c
        or      a
        ret     z

        ; Send remaining bytes to port 0xbe
        ld      b, a
        ld      c, 0xbe
        otir

        ret

_loadFullMap:
        push    af
        push    bc

        xor     a
        out     ($bf), a
        ld      a, TILEMAP_BASE>>8
        or      $40
        out     ($bf), a

        ; Send 6 blocks of 256 bytes to VRAM
        ; Total of 1536 bytes
        ld      b, 6
writeBlock:
        push    bc

        ; Send 256 bytes to port 0xbe
        ld      bc, 0x00be
        otir

        pop     bc
        djnz    writeBlock

        pop     bc
        pop     af
        ret

_readVRAM:
        push    af
        in      a, ($be)
        ld      l, a
        ld      h, 0
        pop     af
        ret

_writeVRAM:
        push    af
        ld      a, l                    ; Data
        out     ($be), a
        pop     af
        ret

_putTile:
        push    af
        ld      a, l                    ; Tile ID
        out     ($be), a
        ld      a, h                    ; Attribute
        out     ($be), a
        pop     af
        ret

_setVRAMAddr:
        push    af
        ld      a, l
        out     ($bf), a
        ld      a, h
        or      $40
        out     ($bf), a
        pop     af
        ret

_setCRAMAddr:
        push    af
        ld      a, l
        out     ($bf), a
        ld      a, h
        or      $c0
        out     ($bf), a
        pop     af
        ret

_fillScreen:
        push    af
        push    bc

        xor     a
        out     ($bf), a
        ld      a, TILEMAP_BASE>>8
        or      $40
        out     ($bf), a

        ld      bc, 0x0003
l1:
        ld      a, l                    ; Tile ID
        out     ($be), a
        ld      a, h                    ; Attribute
        out     ($be), a
        djnz    l1

        dec     c
        jr      nz, l1

        pop     bc
        pop     af
        ret

_readJoypad:
        in      a, (IO_JOYPAD1)
        ld      l, a
        in      a, (IO_JOYPAD2)
        ld      h, a
        ret

        section rodata_user
_tilesheetPal:
        binary  "tilesheet.nxp"
_tilesheet:
        binary  "tilesheet.nxt"
_titlePal:
        binary  "title2.nxp"
_tiles:
        binary  "title2.nxt"
_tilesEnd:
_tileMap:
        binary  "title2.nxm"
_font:
        binary  "Torment.ch8"
