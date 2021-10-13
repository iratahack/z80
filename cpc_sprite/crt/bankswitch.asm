        ; Switch in the bank specified in a
        ;
        ; 0xC4 : bank 0, bank 4, bank 2, bank 3
        ; 0xC5 : bank 0, bank 5, bank 2, bank 3
        ; 0xC6 : bank 0, bank 6, bank 2, bank 3
        ; 0xC7 : bank 0, bank 7, bank 2, bank 3
        ; 0xC0 : bank 0, bank 1, bank 2, bank 3 (the default mode at startup)
bankSwitch:
        ld      bc, 0x7f00
        out     (c), a
        ret
