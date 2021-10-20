        include "BIOS/macros.inc"

        public  border

        extern  palettes

        section CODE_0

        ; Set the border color
		;
		; Entry:
		;	B = Palette 0 color
        ;	C = Palette 1 color
        ;
        ; Exit:
        ;   HL, DE corrupted.
border:
        ld      hl, (palettes)
        ld      de, 0x10
        add     hl, de
        ld      (hl), b
        ld      hl, (palettes+2)
        add     hl, de
        ld      (hl), c
        ret
