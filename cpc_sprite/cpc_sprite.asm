        public  _main

        extern  border
        extern  initISR
        extern  puts
        extern  putc
        extern  cls
        extern  screenTab
        extern  scanKeyboard
        extern  setCursor
        extern  setMode
        extern  initPalette

        section CODE_0
_main:
        call    initISR

        call    cls

        ld      a, 0
        call    setMode

        ld      hl, palette0
        ld      de, palette1
        call    initPalette

        ld      bc, 0x030c
        call    setCursor

        ld      hl, string
        ld      e, 0x0e
        call    puts

        ld      bc, 0x0000
        call    setCursor
waitForKey:
        halt
        call    scanKeyboard
        jr      z, waitForKey

        cp      13
        jr      z, inputDone

        ld      e, 3
        call    putc

        jp      waitForKey

inputDone:

        ld      hl, 96                  ; Character row

        di
        ld      (saveSP+1), sp          ; Save the stack pointer

        add     hl, hl                  ; Multiply by 2
        ld      sp, screenTab           ; Pointer to screen table
        add     hl, sp                  ; Add offset to table
        ld      sp, hl

        ld      hl, testSprite          ; Point to sprite data
        ld      bc, 0x08ff              ; b is number of lines and and c greater than number of bytes

nextLine:
        pop     de                      ; Pop screen pixel row address
        ld      a, e
        add     a, 40
        ld      e, a
        ldi
        ldi
        djnz    nextLine                ; Loop for next pixel row

saveSP:
        ld      sp, -1
        ei

        ld      bc, 0x7F10
firstColor:
        ld      hl, borderColors
loop:
        ld      a, (hl)
        or      a
        jr      z, firstColor

        halt

        out     (c), c
        out     (c), a

        inc     hl
        jp      loop

        ret

        section RODATA_0
string:
        db      "Craig waz ear!", 0

borderColors:
        db      0x4c, 0x52, 0x45, 0x5a, 0x4d, 0x4a, 0x00

testSprite:
        db      %00110000, %11000000
        db      %01110000, %11100000
        db      %11010000, %10110000
        db      %11110000, %11110000
        db      %11110000, %11110000
        db      %11010010, %10110100
        db      %01100001, %01101000
        db      %00110000, %11000000

palette0:
        db      0x44, 0x4a, 0x53, 0x4c, 0x4b, 0x54, 0x55, 0x4d
        db      0x46, 0x5e, 0x5f, 0x47, 0x52, 0x59, 0x44, 0x57
palette1:
        db      0x44, 0x4a, 0x53, 0x4c, 0x4b, 0x54, 0x55, 0x4d
        db      0x46, 0x5e, 0x5f, 0x47, 0x52, 0x59, 0x4a, 0x47
