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
;        define	TAPE
        defc    TAPE_BLOCK_START=0xa864
        defc    TAPE_BLOCK_LENGTH=14*3
        defc    DISK_BLOCK_START=0xbc77

        defc    mc_start_program=0xbd16
        defc    kl_rom_walk=0xbccb
        defc    scr_set_mode=0xbc0e
        defc    current_drive=0xbe7d
        defc    cas_in_open=0xbc77
        defc    cas_in_direct=0xbc83
        defc    cas_in_close=0xbc7a
        defc    txt_set_cursor=0xbb75
        defc    txt_output=0xbb5a
        defc    txt_clear_window=0xbb6c
        defc    scr_set_ink=0xbc32
        defc    scr_set_border=0xbc38
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
        ;------------------------------------------------------------------------
        ; store the drive number the loader was run from
        ld      a, (current_drive)
        ld      (drive+1), a

        ;------------------------------------------------------------------------
        ld      c, 0xff                 ; disable all roms
        ld      hl, crt0                ; execution address for program
        call    mc_start_program        ; start it

crt0:
        ; DE = Start of useable RAM
        ; HL = End of useable RAM - Use the value returned from mc_start_program
        ; Beginning of bank 2 which is loaded last
        ld      de, 0x8000
        call    kl_rom_walk             ; enable all roms

        ;------------------------------------------------------------------------
        ; when AMSDOS is enabled, the drive reverts back to drive 0!
        ; This will restore the drive number to the drive the loader was run from
drive:
        ld      a, -1
        ld      (current_drive), a

        ;------------------------------------------------------------------------
        ; set screen mode 1
        ld      a, 1
        call    scr_set_mode

        call    setPalette
        ld      bc, 0x0000
        call    scr_set_border

IFDEF TAPE
        ; Enable tape (|tape)
        ld      hl, TAPE_BLOCK_START
        ld      de, DISK_BLOCK_START
        ld      bc, TAPE_BLOCK_LENGTH
        ldir
ENDIF
        ;------------------------------------------------------------------------
        ; load all memory banks from disk
        call    loadBanks

        ;------------------------------------------------------------------------
        ; No more BIOS calls from here!!!
        di

IF  CRT_INITIALIZE_BSS
        call    bssInit
ENDIF

        ; Enable default memory map
        ld      a, default_map
        include "bankswitch.asm"

IFDEF   REGISTER_SP
        ld      sp, REGISTER_SP
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
        ld      (stackSave+1), sp
        ld      de, 0x5555              ; Word to fill
        ld      b, CRT_STACK_SIZE/2     ; Stack size in words
fillStackLoop:
        push    de                      ; Push data to stack
        djnz    fillStackLoop           ; Loop for all words
stackSave:
        ld      sp, -1
ENDIF

        ; Clear the RST addresses
        ld      hl, 0x0000
        ld      (hl), 0x00
        ld      de, 0x0001
        ld      bc, 0x3f
        ldir

        jp      _main

loadBanks:
        ld      hl, 0x100c              ; x/y cursor location
        call    txt_set_cursor
        ld      hl, loading             ; Null terminated text string
        call    puts

        ; Turn off tape messages
        ld      a, 1
        call    0xbc6b

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

        ; B = length of filename (0 for next file on tape)
        ; HL = address of filename
        ; DE = 2KB ram buffer for loading
IFDEF TAPE
        ld      b, 0
ELSE
        ld      b, fileNameEnd-fileName
ENDIF
        ld      hl, fileName
        call    loadBank

        pop     hl
        jr      loadNextBank            ; On to the next bank.

loadBank:
        call    cas_in_open             ; Load address returned in DE
        ex      de, hl
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
        call    txt_output
        jr      puts

setPalette:
        ld      hl, palette
        xor     a

nextPen:
        ld      b, (hl)
        inc     b                       ; If b = 0 after inc end of list
        ret     z
        dec     b                       ; Restore b

        ld      c, b

        push    hl
        push    af

        call    scr_set_ink

        pop     af
        pop     hl

        inc     hl
        inc     a
        jp      nextPen

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
palette:
        db      0x00, 0x18, 0x02, 0x1a, 0xff

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
IFDEF   CRT_ORG_BANK_3
        ; Bank 3 loaded first as it contains
        ; the loading screen
        db      '3'
        db      0xc0
        dw      __BANK_3_head
ENDIF
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
IFDEF   CRT_ORG_BANK_4
        db      '4'
        db      __BANK_4_head >> 16
        dw      __BANK_4_head
ENDIF
IFDEF   CRT_ORG_BANK_5
        db      '5'
        db      __BANK_5_head >> 16
        dw      __BANK_5_head
ENDIF
IFDEF   CRT_ORG_BANK_6
        db      '6'
        db      __BANK_6_head >> 16
        dw      __BANK_6_head
ENDIF
IFDEF   CRT_ORG_BANK_7
        db      '7'
        db      __BANK_7_head >> 16
        dw      __BANK_7_head
ENDIF
IFDEF   CRT_ORG_BANK_2
        ; Bank 2 loaded last as it will overwrite
        ; RAM used by the ROM's
        db      '2'
        db      0xc0
        dw      __BANK_2_head
ENDIF
        dw      0x0000
crt0_end:

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   		; Define Memory Banks
   		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IFDEF   CRT_ORG_BANK_0
        SECTION BANK_0
;        org     CRT_ORG_BANK_0
; Code BANK_0 follows on from the loader
        org     -1
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
