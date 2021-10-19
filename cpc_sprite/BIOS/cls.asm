        public  cls

        extern  vsync

        section CODE_0

        ;
        ; Clear the screen.
        ;
        ; The screen is cleared by writing 0 to screen memory.
        ;
        ; Exit:
        ;   AF, BC, HL are corrupted.
cls:
        call    vsync

        di

        ld      (clsSP+1), sp
        ld      sp, 0
        ld      bc, 0x4000/8
        ld      hl, 0x0000
clsLoop:
        push    hl
        push    hl
        push    hl
        push    hl
        dec     bc
        ld      a, b
        or      c
        jr      nz, clsLoop
clsSP:
        ld      sp, -1

        ei
        ret
