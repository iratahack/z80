        include "zcc_opt.def"
        EXTERN  __BSS_0_head
        EXTERN  __BSS_1_head
        EXTERN  __BSS_2_head
        EXTERN  __BSS_3_head
        EXTERN  __BSS_0_tail
        EXTERN  __BSS_1_tail
        EXTERN  __BSS_2_tail
        EXTERN  __BSS_3_tail

        extern  _main

IFNDEF  CRT_INITIALIZE_BSS
        DEFC    CRT_INITIALIZE_BSS=1
ENDIF

        SECTION BANK_0
        ORG     CRT_ORG_BANK_0
crt0:
        di
IF  CRT_INITIALIZE_BSS
        call    bssInit
ENDIF
        call    _main

        ei
        ret

IF  CRT_INITIALIZE_BSS
		;
		; Clear the BSS sections
		;
bssInit:
        ld      hl, bssTable
nextBSSSection:
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl

        ld      a, d                    ; If the start address is
        or      e                       ; 0x0000 it's the end of
        ret     z                       ; the BSS table.

        ld      a, (hl)                 ; Get the bank
        inc     hl

	; Switch memory banks
        call    bankSwitch

        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl

        ld      a, b                    ; If the BSS size
        or      c                       ; is zero, skip to the
        jr      z, nextBSSSection       ; next BSS section in the table.

        push    hl
        ex      de, hl

        ld      (hl), 0                 ; Zero first byte of BSS.
        dec     bc                      ; Decrement counter.
        ld      a, b
        or      c
        jr      z, sectionDone          ; If counter is 0, next section in table.

        ld      de, hl
        inc     de                      ; DE = HL + 1.
        ldir                            ; Do the fill.

sectionDone:
        pop     hl
        jr      nextBSSSection

ENDIF

        include "bankswitch.asm"

        SECTION RODATA_1
bssTable:
IFDEF   CRT_ORG_BANK_0
        dw      __BSS_0_head
        db      0xc0
        dw      __BSS_0_tail-__BSS_0_head
ENDIF
IFDEF   CRT_ORG_BANK_1
        dw      __BSS_1_head
        db      0xc0
        dw      __BSS_1_tail-__BSS_1_head
ENDIF
IFDEF   CRT_ORG_BANK_2
        dw      __BSS_2_head
        db      0xc0
        dw      __BSS_2_tail-__BSS_2_head
ENDIF
IFDEF   CRT_ORG_BANK_3
        dw      __BSS_3_head
        db      0xc0
        dw      __BSS_3_tail-__BSS_3_head
ENDIF
        dw      0x0000

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   		; Define Memory Banks
   		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IFDEF   CRT_ORG_BANK_0
        SECTION BANK_0
;        org     CRT_ORG_BANK_0
        SECTION CODE_0
        SECTION RODATA_0
        SECTION DATA_0
        SECTION BSS_0
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_1
        SECTION BANK_1
        org     CRT_ORG_BANK_1
        SECTION CODE_1
        SECTION RODATA_1
        SECTION DATA_1
        SECTION BSS_1
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_2
        SECTION BANK_2
        org     CRT_ORG_BANK_2
        SECTION code_clib
        SECTION code_l_sccz80
        SECTION CODE_2
        SECTION RODATA_2
        SECTION DATA_2
        SECTION BSS_2
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_3
        SECTION BANK_3
        org     CRT_ORG_BANK_3
        SECTION CODE_3
        SECTION RODATA_3
        SECTION DATA_3
        SECTION BSS_3
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_4
        SECTION BANK_4
        org     CRT_ORG_BANK_4
        SECTION CODE_4
        SECTION RODATA_4
        SECTION DATA_4
        SECTION BSS_4
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_5
        SECTION BANK_5
        org     CRT_ORG_BANK_5
        SECTION CODE_5
        SECTION RODATA_5
        SECTION DATA_5
        SECTION BSS_5
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_6
        SECTION BANK_6
        org     CRT_ORG_BANK_6
        SECTION CODE_6
        SECTION RODATA_6
        SECTION DATA_6
        SECTION BSS_6
        org     -1
ENDIF

IFDEF   CRT_ORG_BANK_7
        SECTION BANK_7
        org     CRT_ORG_BANK_7
        SECTION CODE_7
        SECTION RODATA_7
        SECTION DATA_7
        SECTION BSS_7
        org     -1
ENDIF
