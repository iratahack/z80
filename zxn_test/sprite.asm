        public  _main
        section code_user
_main:
        di
        nextreg 0x43, 0x10              ; Layer 2 of 1st palette

        nextreg 0x40, 0x00              ; Palette index 0

        ld      b, 4
        ld      hl, palette
ploop:
        ld      a, (hl)
        inc     hl
        nextreg 0x41, a                 ; Send color
        djnz    ploop

        nextreg 0x16, 0x00              ; Set X scroll to 0
        nextreg 0x17, 0x00              ; Set Y scroll to 0

        nextreg 0x18, 0x00              ; X1 - 0
        nextreg 0x18, 0xff              ; X2 - 255
        nextreg 0x18, 0x00              ; Y1 - 0 
        nextreg 0x18, 0xbf              ; Y2 - 191

        ld      a, 0x03                 ; BB--P-VW
        ld      bc, 0x123b
        out     (c), a

        nextreg 0x07, 0x02              ; CPU speed (0=3.5Mhz, 1=7Mhz, 2=14 Mhz )

        ld      hl, 0x0000
        ld      bc, 0x4000
colorsAgain:
        dec     bc
        ld      (hl), c
        inc     hl
        ld      a, b
        or      c
        jr      nz, colorsAgain

        halt

        section rodata_user
palette:
        db      %00000001
        db      %11111100
        db      %00011111
        db      %11100000
