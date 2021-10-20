        public  setMode

        section CODE_0

        ; Set the video mode.
        ;
        ; Entry:
        ;   A = Video mode 0-3
        ;
        ; Exit:
        ;   B, A are corrupted
setMode:
        ld      b, 0x7f
        or      0x8c                    ; Select register #2, disable Hi and Lo ROM's
        out     (c), a
        ret
