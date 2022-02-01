        defc    TILEMAP_BASE=0x3800
        defc    PATTERN_BASE=0x0000
        defc    SPRITE_INFO_TABLE=0x3f00
        defc    VDP_Data=0xbe
        defc    VDP_Command=0xbf
        defc    VDP_VCount=0x7e
        defc    VDP_VRAM_Access=0x40
        defc    VDP_CRAM_Access=0xc0

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
        public  _knightTiles
        public  _knightPalette
        public  _readVCount

        public  _setSpriteXY
        public  _readJoypad
        public  _setSpritePattern

        public  _bank

        section code_user

        ;
        ; Map the specified ROM back to slot 2 (0x8000-0xBFFF).
        ;
        ; Input:
        ;   L - ROM bank to be paged in
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   A
        ;
_bank:
        ld      a, l
        ld      (0xffff), a
        ret

        ;
        ; Read the VDP V-count value.
        ;
        ; Input:
        ;   N/A
        ;
        ; Output:
        ;   L - Current V-count value
        ;   H - Always 0
        ;
        ; Corrupts:
        ;   A
        ;
_readVCount:
        in      a, (VDP_VCount)
        ld      l, a
        ld      h, 0
        ret

        ;
        ; Set the pattern for the specified sprite.
        ; C-Callable.
        ;
        ; Input:
        ;   (sp+2) - Sprite ID
        ;   L - Sprite pattern ID
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   HL, IY
        ;
_setSpritePattern:
        ld      iy, 0x0000
        add     iy, sp
        ld      h, (iy+2)               ; Sprite ID
        ;
        ; Set the pattern for the specified sprite.
        ;
        ; Input:
        ;   L - Sprite pattern ID
        ;   H - Sprite ID
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   None.
        ;
setSpritePattern:
        push    af

        ; Set VRAM address for sprite pattern
        ld      a, h
        add     a
        add     0x81
        di
        out     (VDP_Command), a
        ld      a, +(SPRITE_INFO_TABLE>>8)|VDP_VRAM_Access
        out     (VDP_Command), a
        ei
        ld      a, l                    ; Pattern ID
        out     (VDP_Data), a

        pop     af
        ret

        ;
        ; Set the X & Y position of the specified sprite.
        ; C-Callable.
        ;
        ; Input:
        ;   (sp+4) - Sprite ID
        ;   (sp+2) - Sprite Y position
        ;   L - Sprite X position
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   BC, A, L, IY
        ;
_setSpriteXY:
        ld      iy, 0x0000              ; Return address
        add     iy, sp

        ld      a, (iy+4)               ; Sprite ID
        ld      b, (iy+2)               ; Sprite Y pos
        ld      c, l                    ; Sprite X pos
        ;
        ; Set the X & Y position of the specified sprite.
        ;
        ; Input:
        ;   A - Sprite ID
        ;   B - Sprite Y position
        ;   C - Sprite X position
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   L
        ;
setSpriteXY:
        push    af

        ld      l, a
        ; Set VRAM address for Y location
        di
        out     (VDP_Command), a
        ld      a, +(SPRITE_INFO_TABLE>>8)|VDP_VRAM_Access
        out     (VDP_Command), a
        ei

        ; Set the Y location
        ld      a, b
        dec     a
        out     (VDP_Data), a

        ; Set VRAM address for X location
        ld      a, l
        add     a
        or      0x80
        di
        out     (VDP_Command), a
        ld      a, +(SPRITE_INFO_TABLE>>8)|VDP_VRAM_Access
        out     (VDP_Command), a
        ei

        ; Set the X location
        ld      a, c
        out     (VDP_Data), a

        pop     af
        ret

        ;
        ; Load a tileset to offset 0x0000 in VRAM
        ;
        ; Input:
        ;   HL - Length, in bytes, of tileset data
        ;   (sp+2) - Tileset data
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   AF, BC, HL, IY
        ;
_loadTileset:
        ld      iy, 0x0000              ; Return address & pushed regs
        add     iy, sp

        ; Set VRAM address to start of pattern memory
        xor     a
        di
        out     (VDP_Command), a
        or      VDP_VRAM_Access
        out     (VDP_Command), a
        ei

        ld      bc, hl                  ; Length in bytes

        ; Get the address of the pattern data
        ld      l, (iy+2)
        ld      h, (iy+3)

        ld      a, b
        or      a
        jr      z, noBlock


writeTileData:
        push    bc

        ; Send 256 bytes to port 0xbe
        ld      bc, VDP_Data
        otir

        pop     bc
        djnz    writeTileData

noBlock:
        ld      a, c
        or      a
        ret     z

        ; Send remaining bytes to port 0xbe
        ld      b, a
        ld      c, VDP_Data
        otir

        ret

        ;
        ; Transfer a complete tilemap to VRAM.
        ;
        ; Input:
        ;   HL - Pointer to tilemap.
        ;
        ; Output:
        ;   HL points to the memory location after the tilemap.
        ;
        ; Corrupts:
        ;   N/A
        ;
_loadFullMap:
        push    af
        push    bc

        xor     a
        di
        out     (VDP_Command), a
        ld      a, +(TILEMAP_BASE>>8)|VDP_VRAM_Access
        out     (VDP_Command), a
        ei

        ; Send 6 blocks of 256 bytes to VRAM
        ; Total of 1536 bytes
        ld      b, 6
writeBlock:
        push    bc

        ; Send 256 bytes to port 0xbe
        ld      bc, VDP_Data
        otir

        pop     bc
        djnz    writeBlock

        pop     bc
        pop     af
        ret

        ;
        ; Read a byte from the current VRAM location.
        ;
        ; Input:
        ;   N/A
        ;
        ; Output:
        ;   L - Byte read from VRAM
        ;   H - Always zero
        ;
        ; Corrupts:
        ;   N/A
        ;
_readVRAM:
        push    af
        in      a, (VDP_Data)
        ld      l, a
        ld      h, 0
        pop     af
        ret

        ;
        ; Write a byte to the current VRAM location.
        ;
        ; Input:
        ;   L - Byte to write
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   N/A
        ;
_writeVRAM:
        push    af
        ld      a, l                    ; Data
        out     (VDP_Data), a
        pop     af
        ret

        ;
        ; Write a tile ID and attribute to the current VRAM location.
        ;
        ; Input:
        ;   L - Tile ID
        ;   H - Tile attribute
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   N/A
        ;
_putTile:
        push    af
        ld      a, l                    ; Tile ID
        out     (VDP_Data), a

        ; 12
        REPT    3
        nop
        ENDR

        ld      a, h                    ; 4 Attribute
        out     (VDP_Data), a
        pop     af
        ret

        ;
        ; Set the VRAM pointer address.
        ;
        ; Input:
        ;   HL - Offset into VRAM
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   N/A
        ;
_setVRAMAddr:
        push    af

        ld      a, l
        di
        out     (VDP_Command), a
        ld      a, h
        or      VDP_VRAM_Access
        out     (VDP_Command), a
        ei

        pop     af
        ret

        ;
        ; Set the CRAM pointer address.
        ;
        ; Input:
        ;   L - Offset into CRAM (0-31)
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   N/A
        ;
_setCRAMAddr:
        push    af

        ld      a, l
        di
        out     (VDP_Command), a
        ld      a, VDP_CRAM_Access
        out     (VDP_Command), a
        ei

        pop     af
        ret

        ;
        ; Fill the entire screen with the specified tile and attribute.
        ; C-Callable.
        ;
        ; Input:
        ;   L - Tile ID
        ;   H - Tile attribute
        ;
        ; Output:
        ;   N/A
        ;
        ; Corrupts:
        ;   N/A
        ;
_fillScreen:
        push    af
        push    bc

        ; Reset the VRAM address
        xor     a
        ld      b, a
        di
        out     (VDP_Command), a
        ld      a, +(TILEMAP_BASE>>8)|VDP_VRAM_Access
        out     (VDP_Command), a
        ei

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

        pop     bc
        pop     af
        ret

        ;
        ; Ready joypad 1 & 2 inputs.
        ;
        ; Input:
        ;   N/A
        ;
        ; Output:
        ;   HL - Values read from joypad 1 & 2 I/O ports..
        ;
        ; Corrupts:
        ;   A
        ;
_readJoypad:
        in      a, (IO_JOYPAD1)
        ld      l, a
        in      a, (IO_JOYPAD2)
        ld      h, a
        ret

        section RODATA_3
_tilesheetPal:
        binary  "tilesheet.nxp"
_tilesheet:
        binary  "tilesheet.nxt"
_font:
        binary  "Torment.ch8"
_knightTiles:
        binary  "SMS_Sprites.nxt"
_knightPalette:
        binary  "SMS_Sprites.nxp"

        section RODATA_4
_titlePal:
        binary  "title2.nxp"
_tiles:
        binary  "title2.nxt"
_tilesEnd:
_tileMap:
        binary  "title2.nxm"
