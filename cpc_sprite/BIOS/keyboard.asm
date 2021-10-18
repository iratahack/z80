
        public  scanKeyboard

        extern  keyTab
        extern  lastKeyPoll
        ;
        ; Scan the keyboard and return the ASCII code for the
        ; first key detected as pressed.
        ;
        ; Exit:
        ;   A = ASCII code for key pressed. Zero if no key pressed and ZF set.
        ;
scanKeyboard:
        ; Interrupts must be disabled since we are accessing the PPI
        ; and don't want anyone to clobber us.
        di

        ; Set PPI:
        ; Port A = Output
        ; Port B = Input
        ; Port C = Output
        ld      bc, 0xf782
        out     (c), c

        ; Select PSG register 0x0e by writing to port A
        ld      bc, 0xf40e
        out     (c), c

        ; Latch the PSG register by toggling
        ; bits 7 & 6 of port C (select PSG register)
        ld      bc, 0xf6c0
        out     (c), c
        ld      c, 0x00
        out     (c), c

        ; Set PPI:
        ; Port A = Input
        ; Port B = Input
        ; Port C = Output
        ld      bc, 0xf792
        out     (c), c

        ld      c, 0x40
        ld      de, keyTab
        ld      hl, lastKeyPoll
nextRow:
        ; Select keyboard row by writing to port C
        ld      b, 0xf6                 ; Keyboard rows are 0x40 - 0x49
        out     (c), c

        ; Read value from port A
        ld      b, 0xf4
        in      a, (c)

        cpl                             ; Invert input, so a 1 is a key press
        ld      b, a                    ; Save the row scan
        xor     (hl)                    ; xor with the last value read for this row
        and     b                       ; and with row scan. We are only interested in
                                        ; keys being pressed.
        ld      (hl), b                 ; Save the row scan for next time

        ld      b, 8
nextKey:
        rrca
        jr      c, keyDetected
        inc     de
        djnz    nextKey

        inc     hl

        inc     c
        ld      a, c
        cp      0x4a
        jr      nz, nextRow

keyDetected:
        ld      a, (de)
        or      a
        ei
        ret
