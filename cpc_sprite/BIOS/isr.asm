        public  initISR
        extern  flashInk
        extern  wyz_play_frame

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

		; Called from isr during vsync
		;
		; Things which need to be done every 1/50th
		; of a second.
vSync:
        call    wyz_play_frame

        ld      hl, flashCount
        dec     (hl)
        ret     p
        ld      (hl), FLASH_SPEED
        call    flashInk
        ret

isr:
        push    af
        push    bc
        push    de
        push    hl
        push    ix
        push    iy

        ;
        ; Increment the 40-bit ticks count
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
        call    c, vSync

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
fastTick:
        ds      5                       ; Enough bits for 15 years at 1/300
soundCount:
        ds      1
flashCount:
        ds      1
