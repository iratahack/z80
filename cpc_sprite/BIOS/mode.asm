        public  setMode
        public  screenMode

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
        ld      b, 0x7f
        or      0x8c                    ; Select register #2, disable Hi and Lo ROM's
        out     (c), a
        ret

        section BSS_0
screenMode:
        ds      1
