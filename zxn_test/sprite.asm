        public  _main
        org     0x8000
_main:
        di
        nextreg 0x07, 0x00              ; CPU speed (0=3.5Mhz, 1=7Mhz, 2=14 Mhz )

        ld      sp, 0x8000              ; Set stack pointer

		; Clear regular screen bitmap area
        ld      hl, 0x4000
        ld      (hl), 0
        ld      de, 0x4001
        ld      bc, 6144
        ldir

        nextreg 0x43, 0x10              ; Layer 2 of 1st palette

        nextreg 0x40, 0x00              ; Palette index 0
        ld      b, 0x00
        xor     a
paletteLoop:
        nextreg 0x41, a
        inc     a
        djnz    paletteLoop

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

        halt

fill:
        ld      hl, 0x0000
        ld      bc, 0x4000
nxt:
        dec     bc
        ld      (hl), c
        inc     hl
        ld      a, b
        or      c
        jr      nz, nxt
        ret
