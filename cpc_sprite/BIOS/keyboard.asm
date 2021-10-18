        public  scanKeyboard

        section CODE_0
        ;
        ; Scan the keyboard and return the ASCII code for the
        ; first key detected as pressed.
        ;
        ; Exit:
        ;   A = ASCII code for key pressed. Zero if no key pressed and ZF set.
        ;   All other registers corrupted.
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

        ; TODO:
        ; There is a bug in the scanning algorithm.
        ; If multiple keys are pressed in the same row,
        ; only the first one detected will be returned.
        ; The other keys which were not returned will be
        ; stored in the lastPoll table and so will not
        ; get processed on the next poll since it is assumed
        ; they have already been processed.
        ;
        ; One solution is to have a key buffer of 8
        ; keys. The scanning code would process a row
        ; at a time storing the keys pressend in a
        ; key buffer, returning the first key detected
        ; from the key buffer. On subsiquent calls to
        ; this function keys will be returned from the
        ; buffer until it is empty, then the keyboard
        ; is scanned again. Key presses will not get
        ; lost but they may not be returned in the
        ; correct order. Not sure which is the better
        ; option.

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

        section RODATA_0
keyTab:
        ; 0x40 - Line 0
        db      "u", "r", "d", "9", "6", "3", 13, "."
        ; 0x41 - Line 1
        db      "l", "c", "7", "8", "5", "1", "2", "F"
        ; 0x42 - Line 2
        db      "c", "[", 13, "]", "4", "s", "\","c"
        ; 0x43 - Line 3
        db      "^", "-", "@", "P", ";", ":", "/", "."
        ; 0x44 - Line 4
        db      "0", "9", "O", "I", "L", "K", "M", ","
        ; 0x45 - Line 5
        db      "8", "7", "U", "Y", "H", "J", "N", " "
        ; 0x46 - Line 6
        db      "6", "5", "R", "T", "G", "F", "B", "V"
        ; 0x47 - Line 7
        db      "4", "3", "E", "W", "S", "D", "C", "X"
        ; 0x48 - Line 8
        db      "1", "2", "e", "Q", "t", "A", "c", "Z"
        ; 0x49 - Line 9
        db      "u", "d", "l", "r", "f", "g", "h", 8
        ; End of table
        db      0x00

        section BSS_0
lastKeyPoll:
        ds      10
