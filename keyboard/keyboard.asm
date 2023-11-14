
        #define     CAP_SHIFT 0x27
        #define     SYM_SHIFT 0x18

        org     $8000
        public  _main

_main:

        call    keyboardScan
        jr      z, _main
        rst     $10
        jr      _main
        ret

keyboardScan:
		; Scan the keyboard and update the key pressed map
        ld      e, $00
        ld      hl, lastInput
        ld      bc, $fefe
nextRow:
		; Read the port
        in      a, (c)
        or      $e0
        cpl

        ld      d, a
        xor     (hl)
        ld      (hl), d
        and     d

        ld      d, 5
checkForKey:
        rrca
        jr      c, foundKey
        inc     e
        dec		d
        jr		nz, checkForKey

        inc     hl
        rlc     b
        jr      c, nextRow

foundKey:
		ld		d, $00

		; Read Sym-shift
		ld		b, $7f
        in      a, (c)
		and		$02
		ld		hl, keyMap
		jr		nz, noSymShift

		ld		hl, symMap
		add		hl, de
		ld		a, (hl)
		or		a
		ret

noSymShift:
		add		hl, de

		; Read Caps-shift again
		ld		b, $fe
        in      a, (c)
        rrca
        ld      a, (hl)
		jr		c, noShift

		cp		'0'						; Shift is pressed check for backspace
		jr		nz, notBackspace
		ld		a, $08
notBackspace:
		or		a
        ret

noShift:
		cp		'A'
		jr		c, notBackspace			; < 'A'
		cp		'Z'+1
		jr		nc, notBackspace		; > 'Z'

		; Make lowercase
		or		$20
        ret

keyMap:                                 ; Bit 0,  1,  2,  3,  4
        db      $00, "Z", "X", "C", "V"
        db      "A", "S", "D", "F", "G"
        db      "Q", "W", "E", "R", "T"
        db      "1", "2", "3", "4", "5"
        db      "0", "9", "8", "7", "6"
        db      "P", "O", "I", "U", "Y"
        db      "\r", "L", "K", "J", "H"
        db      " ", $00, "M", "N", "B"
        db      0x00                    ; No key pressed

symMap:                                 ; Bit 0,  1,  2,  3,  4
        db      $00, ":", $60, "?", "/"
        db      $00, $00, $00, $00, $00
        db      $00, $00, $00, "<", ">"
        db      "!", "@", "#", "$", "%"
        db      "_", ")", "(", "'", "&"
        db      "\"", ";", $00, $00, $00
        db      $00, "=", "+", "-", "^"
        db      $00, $00, ".", ",", "*"
        db      0x00                    ; No key pressed

lastInput:
        ds      8
