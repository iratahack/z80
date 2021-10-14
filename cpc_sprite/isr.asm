        public  initISR
        public  ticks

        defc    JP_OPCODE=0xc3
        defc    RST_38=0x38

        section CODE_0
initISR:
        ld      a, JP_OPCODE            ; Store the opcode for JP
        ld      (RST_38), a

        ld      de, isr                 ; Store the jump address which is the address of the
        ld      (RST_38+1), de

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
        ld      hl, ticks
        inc     (hl)

        pop     iy
        pop     ix
        pop     hl
        pop     de
        pop     bc
        pop     af                      ; Restore the registers we used
        ei                              ; Enable interrupts
        reti                            ; Acknowledge and return from interrupt

        section BSS_0
ticks:
        ds      1
