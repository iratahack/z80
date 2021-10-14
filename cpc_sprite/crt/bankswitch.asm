        ; 0xC4 : bank 0, bank 4, bank 2, bank 3
        ; 0xC5 : bank 0, bank 5, bank 2, bank 3
        ; 0xC6 : bank 0, bank 6, bank 2, bank 3
        ; 0xC7 : bank 0, bank 7, bank 2, bank 3
        ; 0xC0 : bank 0, bank 1, bank 2, bank 3 (the default mode at startup)
        ld      b, 0x7f
        out     (c), a
