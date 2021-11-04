        include "BIOS/macros.inc"

        public  _main

        extern  initISR
        extern  puts
        extern  putc
        extern  cls
        extern  screenTab
        extern  scanKeyboard
        extern  setCursor
        extern  setMode
        extern  initPalette
        extern  vsync
        extern  border

        extern  wyz_player_init
        extern  wyz_play_song
        extern  wyz_player_stop

        section CODE_0
_main:
        ld      a, 0
        call    setMode

        ld      hl, palette0
        ld      de, palette1
        call    initPalette

        call    wyz_player_init

        ; Interrupts must only be initialized after
        ; initPalette and wyz_palyer_init have been
        ; called.
        call    initISR

        call    cls

        ld      a, 1
        di
        call    wyz_play_song
        ei

        ld      bc, 0x030c
        call    setCursor

        ld      hl, string
        ld      e, 0x01
        call    puts

        ld      bc, 0x0000
        call    setCursor
waitForKey:
        halt
        call    scanKeyboard
        jr      z, waitForKey

        cp      13
        jr      z, inputDone

        ld      e, 0x01
        call    putc

        jp      waitForKey

inputDone:

        di
        call    wyz_player_stop
        xor     a
        call    wyz_play_song
        ei

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

        call    vsync

        ld      bc, 0x7F10
firstColor:
        ld      de, borderColors
loop:
        ld      a, (de)
        or      a
        jp      m, firstColor

        ld      hl, palette0
        addhl
        ld      a, (hl)

        halt

        ; Change border color (pen 16)
        out     (c), c
        out     (c), a

        ; Change paper color (pen 0)
        out     (c), 0                  ; Undocumented z80 op-code
        out     (c), a

        inc     de
        jp      loop

        ret

        section RODATA_0
string:
        db      "Irata waz ear!", 13, "<CR>", 0

borderColors:
        db      0, 1, 2, 3, 4, 5, 0x80

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
        db      0x46, 0x5e, 0x5f, 0x47, 0x52, 0x59, 0x44, 0x57, 0x44
palette1:
        db      0x44, 0x4a, 0x53, 0x4c, 0x4b, 0x54, 0x55, 0x4d
        db      0x46, 0x5e, 0x5f, 0x47, 0x52, 0x59, 0x4a, 0x47, 0x4a
