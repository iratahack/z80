        include "zcc_opt.def"
        EXTERN  __BSS_0_head
        EXTERN  __BSS_1_head
        EXTERN  __BSS_2_head
        EXTERN  __BSS_3_head
        EXTERN  __BSS_4_head
        EXTERN  __BSS_5_head
        EXTERN  __BSS_6_head
        EXTERN  __BSS_7_head
        EXTERN  __BSS_0_tail
        EXTERN  __BSS_1_tail
        EXTERN  __BSS_2_tail
        EXTERN  __BSS_3_tail
        EXTERN  __BSS_4_tail
        EXTERN  __BSS_5_tail
        EXTERN  __BSS_6_tail
        EXTERN  __BSS_7_tail

        EXTERN  __BANK_0_head
        EXTERN  __BANK_1_head
        EXTERN  __BANK_2_head
        EXTERN  __BANK_3_head
        EXTERN  __BANK_4_head
        EXTERN  __BANK_5_head
        EXTERN  __BANK_6_head
        EXTERN  __BANK_7_head

        extern  _main

        defc    mc_start_program=0xbd16
        defc    kl_rom_walk=0xbccb
        defc    scr_set_mode=0xbc0e
        defc    current_drive=0xbe7d
        defc    cas_in_open=0xbc77
        defc    cas_in_direct=0xbc83
        defc    cas_in_close=0xbc7a
        defc    txt_set_cursor=0xbb75
        defc    txt_wr_char=0xbb5d
        defc    txt_clear_window=0xbb6c
        defc    bank_io_hi=0x7f
        defc    default_map=0xc0

IFNDEF  CRT_INITIALIZE_BSS
        DEFC    CRT_INITIALIZE_BSS=1
ENDIF
IFNDEF  CRT_FILL_STACK
        DEFC    CRT_FILL_STACK=0
ENDIF

        SECTION CODE
        ORG     CRT_ORG_CODE
        ;;------------------------------------------------------------------------
        ;; store the drive number the loader was run from
        ld      a, (current_drive)
        ld      (drive+1), a

        ;;------------------------------------------------------------------------
        ld      c, 0xff                 ;; disable all roms
        ld      hl, crt0                ;; execution address for program
        call    mc_start_program        ;; start it

crt0:
        call    kl_rom_walk             ;; enable all roms

        ;;------------------------------------------------------------------------
        ;; when AMSDOS is enabled, the drive reverts back to drive 0!
        ;; This will restore the drive number to the drive the loader was run from
drive:
        ld      a, -1
        ld      (current_drive), a

        ;;------------------------------------------------------------------------
        ;; set screen mode 1

        ld      a, 1
        call    scr_set_mode

        di

IFDEF   REGISTER_SP
        ld      sp, REGISTER_SP
ENDIF

        call    loadBanks

IF  CRT_INITIALIZE_BSS
        call    bssInit
ENDIF

        ;
        ; Fill the stack with a known pattern so
        ; we can see how much we are using.
        ;
        ; Interrupts should be disabled so no need to worry
        ; about ISR accessing the stack.
        ;
IF  CRT_FILL_STACK
fillStack:
        ld      de, 0x5555              ; Word to fill
        ld      b, CRT_STACK_SIZE/2     ; Stack size in words
fillStackLoop:
        push    de                      ; Push data to stack
        djnz    fillStackLoop           ; Loop for all words
        ld      sp, REGISTER_SP
ENDIF

        call    txt_clear_window

        ; Enable default memory map
        ld      a, default_map
        include "bankswitch.asm"

        di
        jp      _main

loadBanks:
        ld      hl, 0x100c              ; x/y cursor location
        call    txt_set_cursor
        ld      hl, loading             ; Null terminated text string
        call    puts

        ld      hl, bankTable
loadNextBank:
        ld      a, (hl)                 ; Get the file extension
        inc     hl
        or      a
        ret     z                       ; Zero signifies end of bank table

        ld      c, (hl)                 ; Get the bank
        inc     hl

        ; Switch memory bank
        ld      b, bank_io_hi
        out     (c), c

        ; Get the load address
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl

        push    hl

        ; Update filename for this bank
        ld      hl, fileNameEnd-1
        ld      (hl), a

        ; B = length of filename
        ; HL = address of filename
        ; DE = load address (set from the bank table)
        ld      b, fileNameEnd-fileName
        ld      hl, fileName
        call    loadBank

        pop     hl
        jr      loadNextBank            ; On to the next bank.

loadBank:
        push    de                      ; Save load address
        ; DE = 2KB ram buffer
        ld      de, 0xc000              ; ISN'T THIS THE SCREEN ADDRESS?
        call    cas_in_open
        pop     hl                      ; Restore load address
        call    cas_in_direct
        call    cas_in_close
        ret

        ;
        ; Display the null terminated string pointed to by hl
        ; at the current cursor location.
        ;
puts:
        ld      a, (hl)
        inc     hl
        or      a
        ret     z
        push    hl
        call    txt_wr_char
        pop     hl
        jr      puts

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
        include "bankswitch.asm"

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

        SECTION RODATA
loading:
        db      "Loading...", 0

fileName:
        db      "sprite.b0"
fileNameEnd:

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
IFDEF   CRT_ORG_BANK_4
        dw      __BSS_4_head
        db      0xc4
        dw      __BSS_4_tail-__BSS_4_head
ENDIF
IFDEF   CRT_ORG_BANK_5
        dw      __BSS_5_head
        db      0xc5
        dw      __BSS_5_tail-__BSS_5_head
ENDIF
IFDEF   CRT_ORG_BANK_6
        dw      __BSS_6_head
        db      0xc6
        dw      __BSS_6_tail-__BSS_6_head
ENDIF
IFDEF   CRT_ORG_BANK_7
        dw      __BSS_7_head
        db      0xc7
        dw      __BSS_7_tail-__BSS_7_head
ENDIF
        dw      0x0000

bankTable:
IFDEF   CRT_ORG_BANK_0
        db      '0'
        db      0xc0
        dw      __BANK_0_head
ENDIF
IFDEF   CRT_ORG_BANK_1
        db      '1'
        db      0xc0
        dw      __BANK_1_head
ENDIF
IFDEF   CRT_ORG_BANK_2
        db      '2'
        db      0xc0
        dw      __BANK_2_head
ENDIF
IFDEF   CRT_ORG_BANK_3
        db      '3'
        db      0xc0
        dw      __BANK_3_head
ENDIF
IFDEF   CRT_ORG_BANK_4
        db      '4'
        db      0xc4
        dw      __BANK_4_head
ENDIF
IFDEF   CRT_ORG_BANK_5
        db      '5'
        db      0xc5
        dw      __BANK_5_head
ENDIF
IFDEF   CRT_ORG_BANK_6
        db      '6'
        db      0xc6
        dw      __BANK_6_head
ENDIF
IFDEF   CRT_ORG_BANK_7
        db      '7'
        db      0xc7
        dw      __BANK_7_head
ENDIF
        dw      0x0000
crt0_end:

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   		; Define Memory Banks
   		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IFDEF   CRT_ORG_BANK_0
        SECTION BANK_0
        org     CRT_ORG_BANK_0
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