        include "BIOS/macros.inc"

        public  setMode
        public  screenMode
        public  screenWidth

        section CODE_0

        ; Set the video mode.
        ;
        ; Entry:
        ;   A = Video mode 0-3
        ;
        ; Exit:
        ;   B, A are corrupted
setMode:
        ld      (screenMode), a
        ld      b, a
        push    hl
        ld      hl, widths
        addhl
        ld      a, (hl)
        ld      (screenWidth), a
        pop     hl
        ld      a, b

        ld      b, 0x7f
        or      0x8c                    ; Select register #2, disable Hi and Lo ROM's
        out     (c), a
        ret

        section RODATA_0
widths:                                 ; Screen width in characters for modes 0-2
        db      20, 40, 80

        section BSS_0
screenMode:
        ds      1
screenWidth:
        ds      1
