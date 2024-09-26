        #include    "plus.inc"
        section BANK_00
start:
        di
        jr      init
        ds      $08-$
rst8:
        ret
        ds      $10-$
rst10:
        ret
        ds      $18-$
rst18:
        ret
        ds      $20-$
rst20:
        ret
        ds      $28-$
rst28:
        ret
        ds      $30-$
rst30:
        ret
        ds      $38-$
	; ISR
rst38:

	    ; Clear interrupt status
        ld      a, IRQ_VBLANK
        out     (IO_IRQSTAT), a
        ei
        ret

        section CODE_0
init:
        ld      sp, stackTop

	    ;
	    ; Setup base memory map
	    ; RAM page 32 -> BANK 0
	    ; RAM page 33 -> BANK 1
	    ; RAM page 34 -> BANK 2
	    ; RAM page 35 -> BANK 3
	    ;
	    ; RAM page 36-63 -> BANK 3
	    ;
        ld      a, USER_RAM
        ld      bc, 4<<8|IO_BANK0
memmapSetup:
        out     (c), a
        inc     a
        inc     c
        djnz    memmapSetup

    	; Setup VBLANK interrupts
        ld      a, IRQ_VBLANK
        out     (IO_IRQMASK), a
        out     (IO_IRQSTAT), a
        im      1
        ei

        halt
        jr      $-1

        section BSS_0
        ds      $20, $55
stackTop:
