        public  puts
        public  putc

        extern  screenTab
        extern  font

        section CODE_0

        ; HL = Pointer to null terminated string to output
        ; B  = Column
        ; C  = Row
puts:
        ld      a, (hl)
        inc     hl
        or      a
        ret     z

        push    hl
        push    bc

        call    putc

        pop     bc
        pop     hl

        inc     b
        jp      puts

putc:
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
        ld      c, (hl)
        inc     hl

        ld      a, c
        rrca
        rrca
        rrca
        rrca
        and     %00001111
        ld      (de), a
        inc     e
        ld      a, c
        and     %00001111
        ld      (de), a
        dec     e

        ; Next screen line down
        ld      a, 0x08
        add     d
        ld      d, a

        djnz    nextByte

        ret
