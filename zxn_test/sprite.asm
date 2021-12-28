        public  _main
        org     0x8000
_main:
        di
        ld      sp, _main               ; Set stack pointer
        ei

        nextreg 0x07, 0x00              ; CPU speed (0=3.5Mhz, 1=7Mhz, 2=14 Mhz )

	; Clear ULA bitmap area
        ld      hl, 0x4000
        ld      (hl), 0
        ld      de, 0x4001
        ld      bc, 6144-1
        ldir

        nextreg 0x43, 0x10              ; Layer 2 of 1st palette

        nextreg 0x40, 0x00              ; Palette index 0
        xor     a
paletteLoop:
        nextreg 0x41, a
        inc     a
        jr      nz, paletteLoop

        nextreg 0x16, 0x00              ; Set X scroll to 0
        nextreg 0x17, 0x00              ; Set Y scroll to 0

        nextreg 0x18, 0x00              ; X1 - 0
        nextreg 0x18, 0xff              ; X2 - 255
        nextreg 0x18, 0x00              ; Y1 - 0
        nextreg 0x18, 0xbf              ; Y2 - 191

        ld      b, 3
        ld      a, 0x03                 ; BB--P-VW
next3rd:
        push    bc

        ld      bc, 0x123b
        out     (c), a

        push    af
        call    fill
        pop     af

        add     0x40

        pop     bc
        djnz    next3rd

        call    sprite

        di
        halt

fill:
        ld      hl, 0x0000
        ld      bc, 0x4000
nxt:
        ld      (hl), l
        inc     hl
        dec     bc
        ld      a, b
        or      c
        jr      nz, nxt
        ret

sprite:
; The following code was copied from https://luckyredfish.com/getting-a-sprite-up-on-a-spectrum-next/
; no copyright patricia dot curtis at luckyredfish.com

        xor     a                       ; select sprite 0
        ld      bc, 0x303b              ; get the port in the b,c register
        out     (c), a                  ; send the zero to port 0x303b to select the sprite
        ; Auto incrementing pointer so we dont have to keep setting 0x303b
        ; Sprite Attribute 0
        ; bits 7-0 = LSB of X coordinate
        ld      a, 50                   ; x position
        out     (0x57), a               ; send the x position to attribute 0 via port 0x57
        ; Sprite Attribute 1
        ; bits 7-0 = LSB of Y coordinate
        ld      a, 100                  ; y position
        out     (0x57), a               ; send the y position to attribute 1 via port 0x57
        ; Sprite Attribute 2
        ; bits 7-4 = Palette offset added to top 4 bits of sprite colour index
        ; bit 3 = X mirror
        ; bit 2 = Y mirror
        ; bit 1 = Rotate
        ; bit 0 = MSB of X coordinate
        ld      a, 0                    ; no rotation and mirroring , no palette offset
        out     (0x57), a               ; send the y position to attribute 2 via port 0x57
        ; Sprite Attribute 3
        ; bit 7 = Visible flag (1 = displayed)
        ; bit 6 = Extended attribute (1 = Sprite Attribute 4 is active)
        ; bits 5-0 = Pattern used by sprite (0-63)
        ld      a, 192                  ; sprite pattern zero and visible (128) and activate Attribute 4 (64)
        out     (0x57), a               ; attribute 3 via port 0x57
        ; Sprite Attribute 4
        ; bit 7 = H (1 = sprite uses 4-bit patterns)
        ; bit 6 = N6 (0 = use the first 128 bytes of the pattern else use the last 128 bytes)
        ; bit 5 = 1 if relative sprites are composite, 0 if relative sprites are unified
        ; Scaling
        ; bits 4-3 = X scaling (00 = 1x, 01 = 2x, 10 = 4x, 11 = 8x)
        ; bits 2-1 = Y scaling (00 = 1x, 01 = 2x, 10 = 4x, 11 = 8x)
        ; bit 0 = MSB of Y coordinate
        ld      a, 0                    ; sprite pattern zero and visible (0)
        out     (0x57), a               ; send the y position to attribute 3 via port 0x57

        ; turn on all sprites
        nextreg 0x15, 0x01

        ;tell the machine we will be sending sprite data
        ld      bc, 0x303b              ; get the port in the b,c register
        ld      a, 0                    ; select sprite zero we are writing too
        out     (c), a                  ; send the zero to port 0x303b to select the sprite

        ; copy the sprite data
        ld      hl, mario0              ; get the sprite data
        ld      c, 0x5b                 ; copy sprite data to through register 0x5B
        ld      b, 0                    ; do a 256 bytes which is 0 this and the prevous like could be bc,0x005b
        otir                            ; send that

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
        nextreg 0x43, 0x20

        ; we are starting with palette element 0
        nextreg 0x40, 0x00

        ld      de, marioPalette        ; get the a pointer to the palette data
        ld      b, marioColours         ; do the number of colours times
Docolours:
        ld      a, (de)                 ; get the colour from the palette array
        inc     de                      ; next element in the array
        nextreg 0x41, a
        djnz    Docolours

        ; now set the Transparency index for sprites
        ; setting the transparency index to palette element 0
        nextreg 0x4b, 0x00

        ;-------------------------------------
        ; end of sprite and palette test code
        ;-------------------------------------

        ld      de, 0x0120
        ld      bc, 0x303b              ; get the port in the b,c register
resetXPos:
        ld      hl, 0x0010
MainLoop:
        halt

        xor     a                       ; select sprite 0
        out     (c), a                  ; send the zero to port 0x303b to select the sprite
        ; Auto incrementing pointer so we dont have to keep setting 0x303b
        ; Sprite Attribute 0
        ; bits 7-0 = LSB of X coordinate
        inc     hl
        ld      a, l                    ; x position
        out     (0x57), a               ; send the x position to attribute 0 via port 0x57
        ; Sprite Attribute 1
        ; bits 7-0 = LSB of Y coordinate
        ld      a, 32                   ; y position
        out     (0x57), a               ; send the y position to attribute 1 via port 0x57

        ld      a, h                    ; Bit 8 of x position
        and     0x01
        out     (0x57), a               ; send the y position to attribute 2 via port 0x57


        push    hl
        xor     a                       ; clear carry flag
        sbc     hl, de
        pop     hl
        jr      c, MainLoop
        jp      resetXPos

; Created by NextGraphics.exe on Friday, 25 September 2020 @ 14:10:22
        defc    marioColours=marioPaletteEnd-marioPalette

        section rodata_user

;       RRRGGGBB
marioPalette:
        db      %11100011               ; Colour 00 is 0xe3 = 255,0,255
        db      %10000001               ; Colour 01 is 0x81 = 157,13,21
        db      %01100000               ; Colour 02 is 0x60 = 140,0,0
        db      %01100000               ; Colour 03 is 0x60 = 143,0,0
        db      %01100000               ; Colour 04 is 0x60 = 135,0,0
        db      %10000001               ; Colour 05 is 0x81 = 152,0,8
        db      %10000101               ; Colour 06 is 0x85 = 150,37,36
        db      %10000000               ; Colour 07 is 0x80 = 167,5,0
        db      %10000001               ; Colour 08 is 0x81 = 177,7,6
        db      %10100001               ; Colour 09 is 0xa1 = 182,7,4
        db      %10100001               ; Colour 0a is 0xa1 = 182,8,4
        db      %10100001               ; Colour 0b is 0xa1 = 186,10,3
        db      %10100001               ; Colour 0c is 0xa1 = 187,21,17
        db      %10000001               ; Colour 0d is 0x81 = 151,32,42
        db      %10000101               ; Colour 0e is 0x85 = 152,39,50
        db      %01101001               ; Colour 0f is 0x69 = 138,106,18
        db      %01101001               ; Colour 10 is 0x69 = 125,103,3
        db      %10001101               ; Colour 11 is 0x8d = 156,118,19
        db      %11001101               ; Colour 12 is 0xcd = 218,123,4
        db      %11001101               ; Colour 13 is 0xcd = 216,121,4
        db      %01101001               ; Colour 14 is 0x69 = 136,101,4
        db      %10101000               ; Colour 15 is 0xa8 = 203,107,0
        db      %10001101               ; Colour 16 is 0x8d = 159,138,50
        db      %11010001               ; Colour 17 is 0xd1 = 223,144,4
        db      %01101101               ; Colour 18 is 0x6d = 138,128,19
        db      %10110001               ; Colour 19 is 0xb1 = 209,149,8
        db      %11110000               ; Colour 1a is 0xf0 = 254,166,0
        db      %11010001               ; Colour 1b is 0xd1 = 242,155,2
        db      %01101101               ; Colour 1c is 0x6d = 123,108,13
        db      %11010001               ; Colour 1d is 0xd1 = 228,152,5
        db      %11110001               ; Colour 1e is 0xf1 = 255,179,35
        db      %11110101               ; Colour 1f is 0xf5 = 255,181,42
        db      %01001000               ; Colour 20 is 0x48 = 102,83,0
        db      %10101000               ; Colour 21 is 0xa8 = 183,98,0
        db      %01101001               ; Colour 22 is 0x69 = 114,94,16
        db      %01101001               ; Colour 23 is 0x69 = 116,96,15
        db      %11110000               ; Colour 24 is 0xf0 = 253,154,0
        db      %11110000               ; Colour 25 is 0xf0 = 255,159,0
        db      %10101101               ; Colour 26 is 0xad = 191,121,8
        db      %01101101               ; Colour 27 is 0x6d = 133,116,20
        db      %10101100               ; Colour 28 is 0xac = 190,114,0
        db      %10101000               ; Colour 29 is 0xa8 = 207,102,0
        db      %11001101               ; Colour 2a is 0xcd = 217,139,31
        db      %01101101               ; Colour 2b is 0x6d = 112,109,58
        db      %01001001               ; Colour 2c is 0x49 = 107,90,25
        db      %10101101               ; Colour 2d is 0xad = 198,120,7
        db      %10101101               ; Colour 2e is 0xad = 204,129,5
        db      %11110000               ; Colour 2f is 0xf0 = 255,154,0
        db      %11110000               ; Colour 30 is 0xf0 = 255,153,0
        db      %01101001               ; Colour 31 is 0x69 = 135,102,14
        db      %01001001               ; Colour 32 is 0x49 = 88,90,18
        db      %01001000               ; Colour 33 is 0x48 = 93,74,0
        db      %01101001               ; Colour 34 is 0x69 = 110,94,25
        db      %11001101               ; Colour 35 is 0xcd = 223,137,22
        db      %11001100               ; Colour 36 is 0xcc = 224,119,0
        db      %10101101               ; Colour 37 is 0xad = 213,135,5
        db      %11001101               ; Colour 38 is 0xcd = 216,133,5
        db      %10101101               ; Colour 39 is 0xad = 198,121,5
        db      %10101001               ; Colour 3a is 0xa9 = 198,107,1
        db      %10101101               ; Colour 3b is 0xad = 205,139,33
        db      %01101101               ; Colour 3c is 0x6d = 138,134,54
        db      %01101101               ; Colour 3d is 0x6d = 132,122,32
        db      %10010001               ; Colour 3e is 0x91 = 148,150,62
        db      %10001101               ; Colour 3f is 0x8d = 149,115,25
        db      %10100001               ; Colour 40 is 0xa1 = 205,23,3
        db      %10001001               ; Colour 41 is 0x89 = 148,98,18
        db      %01101101               ; Colour 42 is 0x6d = 120,137,25
        db      %01101101               ; Colour 43 is 0x6d = 130,111,5
        db      %10000101               ; Colour 44 is 0x85 = 151,39,9
        db      %11110001               ; Colour 45 is 0xf1 = 255,167,23
        db      %11010001               ; Colour 46 is 0xd1 = 246,155,20
        db      %01001000               ; Colour 47 is 0x48 = 100,77,0
        db      %01001000               ; Colour 48 is 0x48 = 76,72,0
        db      %01001001               ; Colour 49 is 0x49 = 79,95,3
        db      %01101101               ; Colour 4a is 0x6d = 116,115,21
        db      %10100001               ; Colour 4b is 0xa1 = 191,1,5
        db      %10000001               ; Colour 4c is 0x81 = 178,0,5
        db      %01001001               ; Colour 4d is 0x49 = 100,84,18
        db      %01001001               ; Colour 4e is 0x49 = 86,96,17
        db      %01000101               ; Colour 4f is 0x45 = 102,63,16
        db      %01100001               ; Colour 50 is 0x61 = 141,29,42
        db      %01101001               ; Colour 51 is 0x69 = 134,101,23
        db      %10101101               ; Colour 52 is 0xad = 193,133,12
        db      %11001101               ; Colour 53 is 0xcd = 228,137,21
        db      %11010001               ; Colour 54 is 0xd1 = 250,150,8
        db      %11001100               ; Colour 55 is 0xcc = 249,133,0
        db      %10101000               ; Colour 56 is 0xa8 = 213,105,0
        db      %10101101               ; Colour 57 is 0xad = 213,139,38
        db      %01001101               ; Colour 58 is 0x4d = 104,111,52
        db      %01001001               ; Colour 59 is 0x49 = 91,74,2
        db      %10100001               ; Colour 5a is 0xa1 = 180,12,5
        db      %10100001               ; Colour 5b is 0xa1 = 200,2,2
        db      %10100001               ; Colour 5c is 0xa1 = 180,8,4
        db      %10100001               ; Colour 5d is 0xa1 = 201,9,3
        db      %10100001               ; Colour 5e is 0xa1 = 202,12,1
        db      %01001001               ; Colour 5f is 0x49 = 92,88,18
        db      %01101001               ; Colour 60 is 0x69 = 112,104,18
        db      %10101100               ; Colour 61 is 0xac = 201,113,0
        db      %11001100               ; Colour 62 is 0xcc = 226,125,0
        db      %10101101               ; Colour 63 is 0xad = 215,123,7
        db      %10101101               ; Colour 64 is 0xad = 214,132,22
        db      %10100001               ; Colour 65 is 0xa1 = 185,33,29
        db      %10000000               ; Colour 66 is 0x80 = 169,2,0
        db      %10100001               ; Colour 67 is 0xa1 = 190,17,4
        db      %10101001               ; Colour 68 is 0xa9 = 208,104,4
        db      %10100001               ; Colour 69 is 0xa1 = 200,17,3
        db      %10100001               ; Colour 6a is 0xa1 = 200,0,2
        db      %10100000               ; Colour 6b is 0xa0 = 200,0,0
        db      %10101001               ; Colour 6c is 0xa9 = 207,107,10
        db      %10001101               ; Colour 6d is 0x8d = 147,133,45
        db      %10100101               ; Colour 6e is 0xa5 = 195,44,45
        db      %10100000               ; Colour 6f is 0xa0 = 192,0,0
        db      %10100001               ; Colour 70 is 0xa1 = 195,0,3
        db      %10000000               ; Colour 71 is 0x80 = 175,0,0
        db      %10000000               ; Colour 72 is 0x80 = 146,4,0
        db      %10000000               ; Colour 73 is 0x80 = 172,0,0
        db      %10100000               ; Colour 74 is 0xa0 = 180,0,0
        db      %10000001               ; Colour 75 is 0x81 = 178,2,2
        db      %10000001               ; Colour 76 is 0x81 = 164,21,2
        db      %10100101               ; Colour 77 is 0xa5 = 202,46,48
        db      %10001101               ; Colour 78 is 0x8d = 159,131,52
        db      %01101101               ; Colour 79 is 0x6d = 124,134,33
        db      %10000101               ; Colour 7a is 0x85 = 158,42,38
        db      %01100000               ; Colour 7b is 0x60 = 138,0,0
        db      %10000000               ; Colour 7c is 0x80 = 148,0,0
        db      %01100001               ; Colour 7d is 0x61 = 143,4,5
        db      %01100001               ; Colour 7e is 0x61 = 139,0,6
        db      %10000001               ; Colour 7f is 0x81 = 147,4,6
        db      %10000001               ; Colour 80 is 0x81 = 150,6,6
        db      %01100000               ; Colour 81 is 0x60 = 137,0,0
        db      %10000000               ; Colour 82 is 0x80 = 165,0,0
        db      %01101000               ; Colour 83 is 0x68 = 110,74,0
        db      %01101101               ; Colour 84 is 0x6d = 114,120,10
        db      %01101101               ; Colour 85 is 0x6d = 137,133,41
        db      %01101000               ; Colour 86 is 0x68 = 111,72,0
        db      %01100001               ; Colour 87 is 0x61 = 141,11,2
        db      %10000001               ; Colour 88 is 0x81 = 151,14,18
        db      %10000001               ; Colour 89 is 0x81 = 146,14,15
        db      %10000001               ; Colour 8a is 0x81 = 149,26,26
        db      %01100001               ; Colour 8b is 0x61 = 138,4,4
        db      %10000001               ; Colour 8c is 0x81 = 148,7,6
        db      %01001001               ; Colour 8d is 0x49 = 98,76,6
        db      %01001001               ; Colour 8e is 0x49 = 100,103,25
        db      %01001001               ; Colour 8f is 0x49 = 97,90,13
        db      %01001000               ; Colour 90 is 0x48 = 79,78,0
        db      %01101101               ; Colour 91 is 0x6d = 133,111,29
        db      %01001001               ; Colour 92 is 0x49 = 99,91,28
        db      %01001001               ; Colour 93 is 0x49 = 78,80,6
        db      %01101101               ; Colour 94 is 0x6d = 127,132,70
marioPaletteEnd:
;mario0 is from frame 0 at position x=0  y=0
mario0:
        db      0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x00, 0x00, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x00, 0x00, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x00, 0x00, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x00, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x00, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x00, 0x00
        db      0x00, 0x00, 0x00, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x33, 0x34, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x00, 0x00, 0x00, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x00, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x3c, 0x3d, 0x3e, 0x3f, 0x40, 0x41, 0x42, 0x43, 0x44, 0x00, 0x00, 0x00, 0x00, 0x00
        db      0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x50, 0x51, 0x52, 0x53, 0x54
        db      0x55, 0x56, 0x57, 0x00, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x03, 0x5f, 0x60, 0x61, 0x62
        db      0x63, 0x64, 0x00, 0x00, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x00, 0x00, 0x6d, 0x00
        db      0x00, 0x00, 0x00, 0x6e, 0x6f, 0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x00
        db      0x00, 0x00, 0x7a, 0x7b, 0x73, 0x7c, 0x7d, 0x7e, 0x7f, 0x80, 0x81, 0x04, 0x82, 0x83, 0x84, 0x00
        db      0x00, 0x85, 0x86, 0x87, 0x88, 0x89, 0x00, 0x00, 0x00, 0x00, 0x8a, 0x8b, 0x8c, 0x8d, 0x8e, 0x00
        db      0x00, 0x8f, 0x90, 0x91, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        db      0x00, 0x00, 0x92, 0x93, 0x94, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

