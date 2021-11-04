        include "BIOS/macros.inc"
        public  initPalette
        public  flashInk
        extern  palettes

        defc    NUM_PENS=0x11

        section CODE_0
		; Initialize hardware and software palettes.
		;
		; Entry:
		;	HL = Pointer to palette 0
		;	DE = pointer to palette 1
		;
        ; Exit:
        ;   A, B, C, HL are corrupted.		
initPalette:
        ld      (palettes), hl
        ld      (palettes+2), de
        call    setPalette
        ret

        ; Alternate between the two palettes.
        ;
        ; Exit:
        ;   A, B, C, HL are corrupted.
flashInk:
        ld		hl, index
        rlc		(hl)
        ld      hl, (palettes)
        jr      nc, setPalette
        ld      hl, (palettes+2)
        ; Set all 16 colors of the palette
        ;
        ; Entry:
        ;   HL = Pointer to 17 bytes of palette data
        ;
        ; Exit:
        ;   A, B, C, HL are corrupted.
setPalette:
        xor     a
nextPen:
        ld      c, (hl)
        call    setInk
        inc     hl
        inc     a
        cp      NUM_PENS
        jr      c, nextPen

        ret

        ; Set the ink color for the given pen
        ;
        ; Entry:
        ;   A = Pen number
        ;   C = Hardware color number
        ;
        ; Exit:
        ;   B is corrupted.
setInk:
        ld      b, 0x7F
        out     (c), a
        out     (c), c
        ret

		section	RODATA_0
index:
        db      0xaa

        section BSS_0
palettes:
        ds      2
        ds      2
