        public  initISR
        extern  flashInk

        defc    JP_OPCODE=0xc3
        defc    RST_7=0x38
        defc    FLASH_SPEED=0x0c

        section CODE_0
initISR:
        ld      a, JP_OPCODE            ; Store the opcode for JP
        ld      (RST_7), a

        ld      de, isr                 ; Store the jump address which is the address of the
        ld      (RST_7+1), de

        im      1                       ; Enable interrupt mode 1
        ei                              ; Enable interrupts

        ret

isr:
        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy

        ;
        ; Increment the 8-bit ticks count
        ;
        ld      hl, fastTick
nextByte:
        inc     (hl)
        inc     hl
        jr      z, nextByte

        ; check for vsync
        ld      b, 0xf5
        in      a, (c)
        rra
        jr      nc, noVsync

        ld      a, (flashCount)
        inc     a
        cp      FLASH_SPEED
        jr      nz, noFlash

        call    flashInk

        xor     a
noFlash:
        ld      (flashCount), a

noVsync:
        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af                      ; Restore the registers we used
        ei                              ; Enable interrupts
        reti                            ; Acknowledge and return from interrupt

        section BSS_0
flashCount:
        db      0
fastTick:
        ds      5                       ; Enough bits for 15 years at 1/300
