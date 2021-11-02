        include "BIOS/macros.inc"

        public  puts
        public  putc
        public  setCursor

        extern  screenTab
        extern  font
        extern  screenMode

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
        jr      z, newLine

        sub     ' '                     ; Characters below 0x20 are not displayed
        ret     c

        ; HL will point to the font data
        ld      l, a
        ld      h, 0
        add     hl, hl
        add     hl, hl
        add     hl, hl
        ld      bc, font
        add     hl, bc
        push    hl

        ld      d, 0
        ld      bc, (cursorPos)

        ld      a, (screenMode)
        or      a
        jr      nz, chkMode1

        ; Mode 0
        ld      hl, penMask0
        add     hl, de
        ld      a, (hl)
        ld      (penMask+1), a

        ld      a, 4                    ; Bytes per char
        ld      (bpc+1), a
        ld      a, 2                    ; Pixels per byte
        ld      (ppb+1), a

        ld      hl, pixelMask0
        ld      a, b
        add     a
        add     a
        jr      setupDone
chkMode1:
        cp      1
        jr      nz, chkMode2

        ; Mode 1
        ld      hl, penMask1
        add     hl, de
        ld      a, (hl)
        ld      (penMask+1), a

        ld      a, 2                    ; Bytes per char
        ld      (bpc+1), a
        ld      a, 4                    ; Pixels per byte
        ld      (ppb+1), a
        ld      hl, pixelMask1
        ld      a, b
        add     a
        jr      setupDone
chkMode2:

        ; Mode 2
        ld      hl, penMask2
        add     hl, de
        ld      a, (hl)
        ld      (penMask+1), a

        ld      a, 1                    ; Bytes per char
        ld      (bpc+1), a
        ld      a, 8                    ; Pixels per byte
        ld      (ppb+1), a
        ld      hl, pixelMask2
        ld      a, b
setupDone:

        ld      (pm+2), hl

        ; DE will point to the screen memory
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
        addde

        call    updateCursor

        pop     hl

        ld      b, 8                    ; # screen lines per char
nextLine:
        push    de
        push    bc

bpc:
        ld      b, -1                   ; Bytes per char
        ld      a, (hl)                 ; Get byte of font data
nextByte:
        push    bc

        ld      c, a
ppb:
        ld      b, -1                   ; Pixels per byte
pm:
        ld      IY, -1
        xor     a
nextPixel:
        rlc     c
        jr      nc, noPixel

        or      (IY+0)
noPixel:
        inc     IY
        djnz    nextPixel

penMask:
        and     -1
        ld      (de), a                 ; Write to the screen
        inc     e                       ; Next screen address
        ld      a, c

        pop     bc
        djnz    nextByte

        pop     bc
        pop     de

        ; Next screen line down
        ld      a, 0x08
        add     d
        ld      d, a

        inc     hl                      ; Next byte of font data
        djnz    nextLine

        ret

        section RODATA_0
penMask0:
        db      %00000000
        db      %11000000
        db      %00001100
        db      %11001100

        db      %00110000
        db      %11110000
        db      %00111100
        db      %11111100

        db      %00000011
        db      %11000011
        db      %00001111
        db      %11001111

        db      %00110011
        db      %11110011
        db      %00111111
        db      %11111111

penMask1:
        db      %00000000
        db      %11110000
        db      %00001111
        db      %11111111

penMask2:
        db      %00000000
        db      %11111111

pixelMask0:
        db      %10101010
        db      %01010101

pixelMask1:
        db      %10001000
        db      %01000100
        db      %00100010
        db      %00010001

pixelMask2:
        db      %10000000
        db      %01000000
        db      %00100000
        db      %00010000
        db      %00001000
        db      %00000100
        db      %00000010
        db      %00000001

        section BSS_0
cursorPos:
        ds      2
