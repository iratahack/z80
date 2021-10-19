        include "BIOS/macros.inc"

        public  puts
        public  putc
        public  setCursor

        extern  screenTab
        extern  font

        section CODE_0

        ;
        ; Update the cursor to the next character position.
        ;
        ; Increment the cursor X position, if the cursor hits the
        ; right edge of the screen is is set to 0 and the Y position
        ; is incremented. If the Y position hits the bottom of the
        ; screen it is reset to 0.
        ;
        ; Entry:
        ;   B = Column
        ;   C = Row
        ;
        ; Exit:
        ;   B = New column position
        ;   C = New row position
        ;   A = Corrupted
updateCursor:
        ld      a, b
        cp      39                      ; Screen character width in mode 1
        jr      nz, nextCol
nl:
        ld      b, 0                    ; Reset to left size of screen
        ld      a, c
        cp      24                      ; screen character height in mode 1
        jr      nz, nextRow
        ld      c, 0
        jr      setCursor
nextRow:
        inc     c                       ; Next row
        jr      setCursor
nextCol:
        inc     b
        ;
        ; Set the text cursor location.
        ;
        ; Entry:
        ;   B = Column
        ;   C = Row
setCursor:
        ld      (cursorPos), bc
        ret

newLine:
        ld      bc, (cursorPos)
        jr      nl

        ;
        ; Display a string.
        ;
        ; Entry:
        ;   HL = Pointer to null terminated string to output
        ;   E = Pen
puts:
        ld      a, (hl)
        inc     hl
        or      a
        ret     z

        push    de
        push    hl

        call    putc

        pop     hl
        pop     de

        jp      puts

        ;
        ; Display a character
        ;
        ; Entry:
        ;   A = Character to display
        ;   E = Pen
putc:
        cp      13                      ; Handle CR/LF
        push    af
        call    z, newLine
        pop     af
        ret     z

        sub     ' '                     ; Characters below 0x20 are not displayed
        ret     c

        ld      IX, penMask
        ld      d, 0x00
        add     IX, de

        ld      l, a
        ld      h, 0
        add     hl, hl
        add     hl, hl
        add     hl, hl
        ld      de, font
        add     hl, de

        push    hl

        ld      bc, (cursorPos)
        ld      de, screenTab
        ld      l, c
        ld      h, 0
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, hl
        add     hl, de
        ld      e, (hl)
        inc     hl
        ld      d, (hl)

        ld      a, b
        add     a                       ; x2 since 2 bytes per char in mode 1
        addde

        call    updateCursor

        pop     hl

        ld      b, 8
nextByte:
IF  1
        ld      a, (hl)                 ; [7] Get byte of font data
        and     0xf0                    ; [7] Mask off lower nibble
        ld      c, a                    ; [4] Save upper nibble
        rrca                            ; [4] Move upper nibble to lower nibble
        rrca                            ; [4]
        rrca                            ; [4]
        rrca                            ; [4]
        or      c                       ; [4] Or upper nibble back in
        and     (IX+0)                  ; [19] Pen mask
        ld      (de), a                 ; [7] Write to the screen

        inc     e                       ; [4] Next screen address

        ld      a, (hl)                 ; [7] Get byte of font data
        and     0x0f                    ; [7] Mask off upper nibble
        ld      c, a                    ; [4] Save lower nibble
        rlca                            ; [4] Move lower nibble to upper nibble
        rlca                            ; [4]
        rlca                            ; [4]
        rlca                            ; [4]
        or      c                       ; [4] Or lower nibble back in
        and     (IX+0)                  ; [19] Pen mask
        ld      (de), a                 ; [7] Write to the screen
ELSE
        push    bc                      ; [11]

        ld      b, 2                    ; [7]
        ld      a, (hl)                 ; [7] Get byte of font data
nextNibble:
        push    bc                      ; [11]

        ld      c, a                    ; [4]
        ld      b, 4                    ; [7]
        ld      IY, pixelMask           ; [14]
        xor     a                       ; [4]
nextPixel:
        rlc     c                       ; [8]
        jr      nc, noPixel             ; [12/7]
        or      (IY+0)                  ; [19]
noPixel:
        inc     IY                      ; [10]
        djnz    nextPixel               ; [13/8]

        and     (IX+0)                  ; [19] Pen mask
        ld      (de), a                 ; [7] Write to the screen
        inc     e                       ; [4] Next screen address
        ld      a, c                    ; [4]

        pop     bc                      ; [10]
        djnz    nextNibble              ; [13/8]

        pop     bc                      ; [10]
        dec     e
ENDIF
        dec     e                       ; Previous screen address
        ; Next screen line down
        ld      a, 0x08
        add     d
        ld      d, a

        inc     hl                      ; Next byte of font data
        djnz    nextByte

        ret

        section RODATA_0
        ; Pen and pixel masks for video mode 1
IF  0
pixelMask:
        db      %10001000
        db      %01000100
        db      %00100010
        db      %00010001
ENDIF
penMask:
        db      0x00                    ; Pen 0
        db      0x0f                    ; Pen 1
        db      0xf0                    ; Pen 2
        db      0xff                    ; Pen 3

        section BSS_0
cursorPos:
        ds      2
