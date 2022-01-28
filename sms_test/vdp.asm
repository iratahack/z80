        defc    TILEMAP_BASE=0x3800
        defc    PATTERN_BASE=0x0000

        public  _setVRAMAddr
        public  _writeVRAM
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

        section code_user

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
