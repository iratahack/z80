        public  puts
        public  putc

        extern  screenTab
        extern  font

        ;
        ; Display a string.
        ;
        ; Entry:
        ;   HL = Pointer to null terminated string to output
        ;   B = Column
        ;   C = Row
        ;   E = Pen
puts:
        ld      a, (hl)
        inc     hl
        or      a
        ret     z

        push    bc
        push    de
        push    hl

        call    putc

        pop     hl
        pop     de
        pop     bc

        inc     b
        jp      puts

        ;
        ; Display a character
        ;
        ; Entry:
        ;   A = Character to display
        ;   B = Column
        ;   C = Row
        ;   E = Pen
putc:
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
        add     a
        add     e
        ld      e, a

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
;        and     0xf0                    ; Mask to switch pen color
        and     (IX+0)
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
;        and     0xf0                    ; Mask to switch pen color
        and     (IX+0)
        ld      (de), a                 ; Write to the screen

        dec     e                       ; Previous screen address
        ; Next screen line down
        ld      a, 0x08
        add     d
        ld      d, a

        inc     hl                      ; Next byte of font data
        djnz    nextByte

        ret

mode1PenMask:
        db      0x00                    ; Pen 0
        db      0x0f                    ; Pen 1
        db      0xf0                    ; Pen 2
        db      0xff                    ; Pen 3
