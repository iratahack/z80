        public  border

        section CODE_0

        ; Set the border color
        ;
        ; Exit:
        ;   BC corrupted.
border:
        ld      bc, 0x7F10
        out     (c), c
        out     (c), a
        ret
