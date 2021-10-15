        public  border
        section CODE_0
border:
        push    bc
        ld      bc, 0x7F10
        out     (c), c
        out     (c), a
        pop     bc
        ret
