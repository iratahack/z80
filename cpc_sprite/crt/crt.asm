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

        defc    memory_pool=0xbe7d

        defc    scr_set_mode=0xbc0e
        defc    scr_set_ink=0xbc32
        defc    scr_set_border=0xbc38

        defc    cas_noisy=0xbc6b
        defc    cas_in_open=0xbc77
        defc    cas_in_direct=0xbc83
        defc    cas_in_close=0xbc7a

        defc    txt_set_cursor=0xbb75
        defc    txt_output=0xbb5a
        defc    txt_clear_window=0xbb6c

        defc    bank_io_hi=0x7f
        defc    default_map=0xc0

IFNDEF  CRT_INITIALIZE_BSS
        DEFC    CRT_INITIALIZE_BSS=1
ENDIF
IFNDEF  CRT_FILL_STACK
        DEFC    CRT_FILL_STACK=0
ENDIF
IFNDEF  CRT_LOADING_MESSAGE
        DEFC    CRT_LOADING_MESSAGE=0
ENDIF
IFNDEF  CRT_SET_CURSOR
        DEFC    CRT_SET_CURSOR=0x100c
ENDIF

        SECTION CODE
        ORG     CRT_ORG_CODE
        ;------------------------------------------------------------------------
        ; store the drive number the loader was run from
        ld      hl, (memory_pool)
        ld      a, (hl)                 ; Drive number 0 or 1
        ld      (drive+1), a

        ;------------------------------------------------------------------------
        ld      c, 0xff                 ; disable all roms
        ld      hl, crt0                ; execution address for program
        call    mc_start_program        ; start it

crt0:
        ; HL = End of useable RAM - Use the value returned from mc_start_program
        ; DE = Start of useable RAM use beginning of bank 2 which is loaded last
        ld      de, 0x8000
        call    kl_rom_walk             ; enable all roms

IFDEF   REGISTER_SP
        di
        ld      sp, REGISTER_SP
  IF    CRT_FILL_STACK
        ld      hl, REGISTER_SP-CRT_STACK_SIZE
        ld      de, REGISTER_SP-CRT_STACK_SIZE+1
        ld      bc, CRT_STACK_SIZE-1
        ld      (hl), 0x55
        ldir
  ENDIF
        ei
ENDIF

        ;------------------------------------------------------------------------
        ; when AMSDOS is enabled, the drive reverts back to drive 0!
        ; This will restore the drive number to the drive the loader was run from
drive:
        ld      a, -1
        ld      hl, (memory_pool)
        ld      (hl), a

IFDEF   CRT_SCREEN_MODE
        ;------------------------------------------------------------------------
        ; set screen mode 1
        ld      a, CRT_SCREEN_MODE
        call    scr_set_mode
ENDIF

        ld      hl, palette
        call    setPalette

IFDEF   CRT_BORDER_COLOR
        ld      bc, CRT_BORDER_COLOR
        call    scr_set_border
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
        ld      c, default_map
        ld      b, bank_io_hi
        out     (c), c

        ; Clean memory below this loader
        ld      hl, 0x0000
        ld      (hl), 0x00
        ld      de, 0x0001
        ld      bc, CRT_ORG_CODE-1
        ldir

        jp      _main

loadBanks:
IF  CRT_LOADING_MESSAGE
        ld      hl, CRT_SET_CURSOR      ; x/y cursor location
        call    txt_set_cursor
        ld      hl, loadingMsg          ; Null terminated text string
        call    puts
ENDIF

        ; Turn off tape messages
        ld      a, 1
        call    cas_noisy

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
        ld      b, fileNameEnd-fileName
        ld      hl, fileName
        call    loadBank

        pop     hl
        jr      loadNextBank            ; On to the next bank.

loadBank:
        cp      '2'                     ; Special handling for bank 2
        jr      z, loadBank2

        call    cas_in_open             ; Load address returned in DE
        ex      de, hl
        call    cas_in_direct
        call    cas_in_close
        ret
loadBank2:
        ; Bank 2 is used by the ROMs. Load bank 2
        ; data to the screen then copy it to its
        ; actual location.
        ; Before loading to the screen set all
        ; pens in the palette to black so the
        ; data loaded cannot be seen.
        push    hl
        push    bc
        ld      hl, blackPalette
        call    setPalette
        pop     bc
        pop     hl

        ld      de, 0xc000              ; Block buffer address
        call    cas_in_open             ; Load address returned in DE
        ld      hl, 0xc000              ; Force load to screen memory
        push    bc                      ; Save the length
        call    cas_in_direct
        call    cas_in_close
        pop     bc                      ; Restore the length

        ; We are about to clobber stuff
        ; Disable interrupts first
        ; Interrupts should not be re-enabled until
        ; an ISR has been initialized.
        di
        ; Copy bank 2 data from screen memory to
        ; its actual location.
        ld      hl, 0xc000
        ld      de, 0x8000
        ldir
        ret

IF  CRT_LOADING_MESSAGE

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
ENDIF

setPalette:
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

        ld      c, (hl)                 ; Get the bank
        inc     hl

        ; Switch memory banks
        ld      b, bank_io_hi
        out     (c), c

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
        db 00, 06, 18, 26, 255
blackPalette:
        db      0x00, 0x00, 0x00, 0x00, 0xff

IF  CRT_LOADING_MESSAGE
loadingMsg:
        db      "Loading...", 0
ENDIF

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
        db      __BANK_4_head>>16
        dw      __BANK_4_head
ENDIF
IFDEF   CRT_ORG_BANK_5
        db      '5'
        db      __BANK_5_head>>16
        dw      __BANK_5_head
ENDIF
IFDEF   CRT_ORG_BANK_6
        db      '6'
        db      __BANK_6_head>>16
        dw      __BANK_6_head
ENDIF
IFDEF   CRT_ORG_BANK_7
        db      '7'
        db      __BANK_7_head>>16
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
