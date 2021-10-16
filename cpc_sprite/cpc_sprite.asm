        public  _main
        public  screenTab

        extern  border
        extern  initISR
        extern  putc
        extern  puts


        section CODE_0
_main:
        call    initISR

        call    clearScreen

        ld      hl, string
        ld      bc, 0x0d0c
        call    puts

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

firstColor:
        ld      hl, borderColors
loop:
        ld      a, (hl)
        or      a
        jr      z, firstColor
        call    border
        halt
        inc     hl
        jp      loop

        ret

clearScreen:
        di

        call    vsync

        ld      (clsSP+1), sp
        ld      sp, 0
        ld      bc, 0x4000/8
        ld      hl, 0x0000
clsLoop:
        push    hl
        push    hl
        push    hl
        push    hl
        dec     bc
        ld      a, b
        or      c
        jr      nz, clsLoop
clsSP:
        ld      sp, -1

        ei
        ret

        ; Wait for VSYNC
vsync:
        ld      b, 0xf5                 ; PPI port B input
wait_vsync:
        in      a, (c)                  ; read PPI port B input
                                        ; (bit 0 = "1" if vsync is active,
                                        ;  or bit 0 = "0" if vsync is in-active)
        rra                             ; put bit 0 into carry flag
        jp      nc, wait_vsync          ; if carry not set, loop, otherwise continue

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

;  7 6 5 4 3 2 1 0   7 6 5 4 3 2 1 0
; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
; |1|1| | | | | | | | |1| |1| | | | |
; +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
;     |     |
;     +--+--+
;        |
;        +--------------------------- Row lower [2:0]



screenTab:
        dw      0xC000, 0xC800, 0xD000, 0xD800, 0xE000, 0xE800, 0xF000, 0xF800
        dw      0xC050, 0xC850, 0xD050, 0xD850, 0xE050, 0xE850, 0xF050, 0xF850
        dw      0xC0A0, 0xC8A0, 0xD0A0, 0xD8A0, 0xE0A0, 0xE8A0, 0xF0A0, 0xF8A0
        dw      0xC0F0, 0xC8F0, 0xD0F0, 0xD8F0, 0xE0F0, 0xE8F0, 0xF0F0, 0xF8F0
        dw      0xC140, 0xC940, 0xD140, 0xD940, 0xE140, 0xE940, 0xF140, 0xF940
        dw      0xC190, 0xC990, 0xD190, 0xD990, 0xE190, 0xE990, 0xF190, 0xF990
        dw      0xC1E0, 0xC9E0, 0xD1E0, 0xD9E0, 0xE1E0, 0xE9E0, 0xF1E0, 0xF9E0
        dw      0xC230, 0xCA30, 0xD230, 0xDA30, 0xE230, 0xEA30, 0xF230, 0xFA30
        dw      0xC280, 0xCA80, 0xD280, 0xDA80, 0xE280, 0xEA80, 0xF280, 0xFA80
        dw      0xC2D0, 0xCAD0, 0xD2D0, 0xDAD0, 0xE2D0, 0xEAD0, 0xF2D0, 0xFAD0
        dw      0xC320, 0xCB20, 0xD320, 0xDB20, 0xE320, 0xEB20, 0xF320, 0xFB20
        dw      0xC370, 0xCB70, 0xD370, 0xDB70, 0xE370, 0xEB70, 0xF370, 0xFB70
        dw      0xC3C0, 0xCBC0, 0xD3C0, 0xDBC0, 0xE3C0, 0xEBC0, 0xF3C0, 0xFBC0
        dw      0xC410, 0xCC10, 0xD410, 0xDC10, 0xE410, 0xEC10, 0xF410, 0xFC10
        dw      0xC460, 0xCC60, 0xD460, 0xDC60, 0xE460, 0xEC60, 0xF460, 0xFC60
        dw      0xC4B0, 0xCCB0, 0xD4B0, 0xDCB0, 0xE4B0, 0xECB0, 0xF4B0, 0xFCB0
        dw      0xC500, 0xCD00, 0xD500, 0xDD00, 0xE500, 0xED00, 0xF500, 0xFD00
        dw      0xC550, 0xCD50, 0xD550, 0xDD50, 0xE550, 0xED50, 0xF550, 0xFD50
        dw      0xC5A0, 0xCDA0, 0xD5A0, 0xDDA0, 0xE5A0, 0xEDA0, 0xF5A0, 0xFDA0
        dw      0xC5F0, 0xCDF0, 0xD5F0, 0xDDF0, 0xE5F0, 0xED50, 0xF550, 0xFD50
        dw      0xC640, 0xCE40, 0xD640, 0xDE40, 0xE640, 0xEE40, 0xF640, 0xFE40
        dw      0xC690, 0xCE90, 0xD690, 0xDE90, 0xE690, 0xEE90, 0xF690, 0xFE90
        dw      0xC6E0, 0xCEE0, 0xD6E0, 0xDEE0, 0xE6E0, 0xEEE0, 0xF6E0, 0xFEE0
        dw      0xC730, 0xCF30, 0xD730, 0xDF30, 0xE730, 0xEF30, 0xF730, 0xFF30
        dw      0xC780, 0xCF80, 0xD780, 0xDF80, 0xE780, 0xEF80, 0xF780, 0xFF80
