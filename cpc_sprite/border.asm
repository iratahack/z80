        public  border
        section CODE_1
border:
        push    bc
        ld      bc, 0x7F10
        out     (c), c
        out     (c), a
        pop     bc
        ret
