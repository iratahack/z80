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
        ld      b, 0                    ; Reset to left size of screen
        ld      a, c
        cp      24                      ; screen character height in mode 1
        jr      nz, nextRow
        ld      c, 0
        jr      setCursor
nextRow:
        inc     c                       ;
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
        cp      ' '
        ret     c

        ld      IX, mode1PenMask
        ld      d, 0x00
        add     IX, de

        sub     ' '
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
        ld      a, (hl)                 ; Get byte of font data
        and     0xf0                    ; Mask off lower nibble
        ld      c, a                    ; Save upper nibble
        rrca                            ; Move upper nibble to lower nibble
        rrca
        rrca
        rrca
        or      c                       ; Or upper nibble back in
        and     (IX+0)                  ; Pen mask
        ld      (de), a                 ; Write to the screen

        inc     e                       ; Next screen address

        ld      a, (hl)                 ; Get byte of font data
        and     0x0f                    ; Mask off upper nibble
        ld      c, a                    ; Save lower nibble
        rlca                            ; Move lower nibble to upper nibble
        rlca
        rlca
        rlca
        or      c                       ; Or lower nibble back in
        and     (IX+0)                  ; Pen mask
        ld      (de), a                 ; Write to the screen

        dec     e                       ; Previous screen address
        ; Next screen line down
        ld      a, 0x08
        add     d
        ld      d, a

        inc     hl                      ; Next byte of font data
        djnz    nextByte

        ret

        section RODATA_0
mode1PenMask:
        db      0x00                    ; Pen 0
        db      0x0f                    ; Pen 1
        db      0xf0                    ; Pen 2
        db      0xff                    ; Pen 3

        section BSS_0
cursorPos:
        ds      2
