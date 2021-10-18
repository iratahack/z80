        public  _main

        extern  border
        extern  initISR
        extern  puts
        extern  putc
        extern  cls
        extern  screenTab
        extern  scanKeyboard


        section CODE_0
_main:
        call    initISR

        call    cls

        ld      hl, string
        ld      bc, 0x0d0c
        ld      e, 1
        call    puts

        ld      bc, 0x0000
ttt:
        push    bc
wait:
        call    scanKeyboard
        jr      z, wait

        pop     bc
        push    bc
        ld      e, 3
        call    putc

        pop     bc
        inc     b
        jp      ttt


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
