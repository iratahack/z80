IRQMASK equ     $ee
IRQSTAT equ     $ef
VIRQLINE    equ $ed

        section VECTORS
rst0:
        di
        jp      start
        ds      $04
rst8:
        ret
        ds      $07
rst10:
        ret
        ds      $07
rst18:
        ret
        ds      $07
rst20:
        ret
        ds      $07
rst28:
        ret
        ds      $07
rst30:
        ret
        ds      $07
rst38:
        ; Clear VBLANK and VLINE interrupts
        ld      a, $03
        out     (IRQSTAT), a
        ei
        ret

        section CODE_0
initISR:
        di
        ; Enable VBlank interrupt
        ld      a, $01
        out     (IRQMASK), a
        ; Clear interrupt status
        ld      a, $03
        out     (IRQSTAT), a
        ; Interrupt mode 1 (rst38)
        IM      1
        ei
        ret

        extern  _titleMusic
start:
        call    initISR
        call    _titleMusic
        jr      $

