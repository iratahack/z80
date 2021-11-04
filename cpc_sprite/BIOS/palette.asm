        include "BIOS/macros.inc"
        public  initPalette
        public  flashInk
        extern  palettes

        defc    NUM_PENS=0x11

        section CODE_0
initPalette:
        ld      (palettes), hl
        ld      (palettes+2), de
        call    setPalette
        ret

        ; Alternate between the two palettes
        ;
        ; Exit:
        ;   A, B, C, HL are corrupted.
flashInk:
        ld      a, (index)
        xor     1
        ld      (index), a
        ld      hl, (palettes)
        jr      z, setPalette
        ld      hl, (palettes+2)
        ; Set all 16 colors of the palette
        ;
        ; Entry:
        ;   HL = Pointer to 16 bytes of palette data
        ;
        ; Exit:
        ;   A, B, C, HL are corrupted.
setPalette:
        xor     a
nextPen:
        ld      c, (hl)
        call    setInk
        inc     hl
        inc     a
        cp      NUM_PENS
        jr      c, nextPen

        ret

        ; Set the ink color for the given pen
        ;
        ; Entry:
        ;   A = Pen number
        ;   C = Hardware color number
        ;
        ; Exit:
        ;   B is corrupted.
setInk:
        ld      b, 0x7F
        out     (c), a
        out     (c), c
        ret

        section BSS_0
index:
        ds      1
palettes:
        ds      2
        ds      2
