;       Startup Code for Sega Master System
;
;    Haroldo O. Pinheiro February 2006
;
;    $Id: sms_crt0.asm,v 1.20 2016-07-13 22:12:25 dom Exp $
;

    DEFC    CODE_Start = $0100
    DEFC    RAM_Start  = $C000
    DEFC    RAM_Length = $2000


    MODULE  sms_crt0

;-------
; Include zcc_opt.def to find out information about us
;-------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

    INCLUDE     "target/sms/def/sms.h"

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    __Exit         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)

    PUBLIC __IO_VDP_DATA
    PUBLIC __IO_VDP_COMMAND
    PUBLIC __IO_VDP_STATUS
    PUBLIC  __IO_SN76489_PORT

    EXTERN  clear_vram

IF __GAMEGEAR__
    defc CONSOLE_XOFFSET = 6
    defc CONSOLE_YOFFSET = 3
    defc CONSOLE_COLUMNS = 20
    defc CONSOLE_ROWS = 18
    defc __GAMEGEAR_ENABLED = 1
ELSE
    defc __GAMEGEAR_ENABLED = 0
    defc CONSOLE_COLUMNS = 32
  IF !DEFINED_CONSOLE_ROWS
    defc CONSOLE_ROWS = 24
  ENDIF
ENDIF

    EXTERN  __tms9918_status_register
    PUBLIC  __SMSlib_VDPFlags
    defc    __SMSlib_VDPFlags = __tms9918_status_register
    

    defc    CRT_ORG_CODE        = 0
    defc    TAR__register_sp    = $dff0
    defc    TAR__clib_exit_stack_size = 32
    defc    __CPU_CLOCK = 3580000
    defc    TAR__crt_enable_nmi = 1

    INCLUDE "crt/classic/crt_rules.inc"


    org     CRT_ORG_CODE

    jp      start

    defs 0x0008 - ASMPC
if (ASMPC<>$0008)
    defs    CODE_ALIGNMENT_ERROR
endif

   PUBLIC _SMS_crt0_RST08
   PUBLIC __RST08_SMS_crt0_RST08

_SMS_crt0_RST08:               ; Restart 08h - write HL to VDP Control Port
__RST08_SMS_crt0_RST08:
    ld      c,__IO_VDP_COMMAND
    di                          ; make it interrupt SAFE
    out     (c),l
    out     (c),h
    ei
    ret

    defm "Z88DK"
   
    defs 0x0018 - ASMPC
if (ASMPC<>$0018)
    defs    CODE_ALIGNMENT_ERROR
endif
    PUBLIC _SMS_crt0_RST18
    PUBLIC __RST18_SMS_crt0_RST18

_SMS_crt0_RST18:               ; Restart 18h - write HL to VDP Data Port
__RST18_SMS_crt0_RST18:
    ld      a,l                      ; (respecting VRAM time constraints)
    out     (__IO_VDP_DATA),a        ; 11
    ld      a,h                      ; 4
    sub     0                        ; 7
    nop                              ; 4 = 26 (VRAM SAFE)
    out     (__IO_VDP_DATA),a
    ret

    defs    $0030-ASMPC
if (ASMPC<>$0030)
    defs    CODE_ALIGNMENT_ERROR
endif

    defs    $0038-ASMPC
if (ASMPC<>$0038)
    defs    CODE_ALIGNMENT_ERROR
endif

    
;-------        
; Interrupt handlers
;-------
    extern _SMS_isr
__RST38_SMS_crt0_RST38:
	jp	_SMS_isr

    defs    $0066-ASMPC
IF (ASMPC<>$0066)
    defs    CODE_ALIGNMENT_ERROR
ENDIF

    EXTERN  _SMS_nmi_isr
__RST66_SMS_crt0_RST66:
    jp      _SMS_nmi_isr

;-------        
; Beginning of the actual code
;-------
    defs    (CODE_Start - ASMPC)
IF (ASMPC<>CODE_Start)
    defs    CODE_ALIGNMENT_ERROR
ENDIF

start:
    INCLUDE "crt/classic/crt_init_sp.inc"
    ld      hl,RAM_Start
    ld      de,RAM_Start+1
    ld      bc,RAM_Length-1
    ld      (hl),0
    ldir
    call    crt0_init
    INCLUDE "crt/classic/crt_init_atexit.inc"

    im      1
    ei
    call    _main

__Exit:
    push    hl
    call    crt0_exit
endloop:
    jr      endloop

l_dcal:
    jp      (hl) 

    PUBLIC  l_ret
l_ret:
    ret

IF CRT_ENABLE_BANKED_CALLS = 1
    GLOBAL  banked_call
    defc    MAPPER_ADDRESS_8000 = 0xffff

banked_call:
    pop     hl              ; Get the return address
    ld      (mainsp),sp
    ld      sp,(tempsp)
    ld      a,(__current_bank)
    push    af              ; Push the current bank onto the stack
    ld      e,(hl)          ; Fetch the call address
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)          ; ...and page
    inc     hl
    inc     hl              ; Yes this should be here
    push    hl              ; Push the real return address
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
    ld      l,e
    ld      h,d
    call    l_dcal          ; jp(hl)
    ld      (mainsp),sp
    ld      sp,(tempsp)
    pop     bc              ; Get the return address
    pop     af              ; Pop the old bank
    ld      (tempsp),sp
    ld      sp,(mainsp)
    ld      (__current_bank),a
    ld      (MAPPER_ADDRESS_8000),a
    push    bc
    ret
ENDIF

    INCLUDE "crt/classic/crt_runtime_selection.inc"

    ; And include handling disabling screenmodes
    INCLUDE "crt/classic/tms99x8/tms99x8_mode_disable.inc"

    IF DEFINED_CRT_ORG_BSS
        defc __crt_org_bss = CRT_ORG_BSS
    ELSE
        defc __crt_org_bss = RAM_Start
    ENDIF


    ; If we were given a model then use it
    IF DEFINED_CRT_MODEL
        defc __crt_model = CRT_MODEL
    ELSE
        defc __crt_model = 1
    ENDIF
    INCLUDE    "crt/classic/crt_section.inc"


IF CRT_ENABLE_BANKED_CALLS = 1
        SECTION bss_driver
mainsp:         defw    0
tempstack:      defs    CLIB_BANKING_STACK_SIZE
__current_bank: defb    2

        SECTION data_driver
tempsp: defw    tempstack + CLIB_BANKING_STACK_SIZE
ENDIF

    ; DEFINE SECTIONS FOR BANKSWITCHING
    ; consistent with appmake and new c library

   IFNDEF CRT_ORG_BANK_02
      defc CRT_ORG_BANK_02 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_03
      defc CRT_ORG_BANK_03 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_04
      defc CRT_ORG_BANK_04 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_05
      defc CRT_ORG_BANK_05 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_06
      defc CRT_ORG_BANK_06 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_07
      defc CRT_ORG_BANK_07 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_08
      defc CRT_ORG_BANK_08 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_09
      defc CRT_ORG_BANK_09 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0A
      defc CRT_ORG_BANK_0A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0B
      defc CRT_ORG_BANK_0B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0C
      defc CRT_ORG_BANK_0C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0D
      defc CRT_ORG_BANK_0D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0E
      defc CRT_ORG_BANK_0E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_0F
      defc CRT_ORG_BANK_0F = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_10
      defc CRT_ORG_BANK_10 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_11
      defc CRT_ORG_BANK_11 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_12
      defc CRT_ORG_BANK_12 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_13
      defc CRT_ORG_BANK_13 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_14
      defc CRT_ORG_BANK_14 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_15
      defc CRT_ORG_BANK_15 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_16
      defc CRT_ORG_BANK_16 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_17
      defc CRT_ORG_BANK_17 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_18
      defc CRT_ORG_BANK_18 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_19
      defc CRT_ORG_BANK_19 = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1A
      defc CRT_ORG_BANK_1A = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1B
      defc CRT_ORG_BANK_1B = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1C
      defc CRT_ORG_BANK_1C = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1D
      defc CRT_ORG_BANK_1D = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1E
      defc CRT_ORG_BANK_1E = 0x8000
   ENDIF

   IFNDEF CRT_ORG_BANK_1F
      defc CRT_ORG_BANK_1F = 0x8000
   ENDIF


    SECTION BANK_02
    org $020000 + CRT_ORG_BANK_02
    SECTION CODE_2
    SECTION RODATA_2

    SECTION BANK_03
    org $030000 + CRT_ORG_BANK_03
    SECTION CODE_3
    SECTION RODATA_3

    SECTION BANK_04
    org $040000 + CRT_ORG_BANK_04
    SECTION CODE_4
    SECTION RODATA_4

    SECTION BANK_05
    org $050000 + CRT_ORG_BANK_05
    SECTION CODE_5
    SECTION RODATA_5

    SECTION BANK_06
    org $060000 + CRT_ORG_BANK_06
    SECTION CODE_6
    SECTION RODATA_6

    SECTION BANK_07
    org $070000 + CRT_ORG_BANK_07
    SECTION CODE_7
    SECTION RODATA_7

    SECTION BANK_08
    org $080000 + CRT_ORG_BANK_08
    SECTION CODE_8
    SECTION RODATA_8

    SECTION BANK_09
    org $090000 + CRT_ORG_BANK_09
    SECTION CODE_9
    SECTION RODATA_9

    SECTION BANK_0A
    org $0a0000 + CRT_ORG_BANK_0A
    SECTION CODE_10
    SECTION RODATA_10

    SECTION BANK_0B
    org $0b0000 + CRT_ORG_BANK_0B
    SECTION CODE_11
    SECTION RODATA_11

    SECTION BANK_0C
    org $0c0000 + CRT_ORG_BANK_0C
    SECTION CODE_12
    SECTION RODATA_12

    SECTION BANK_0D
    org $0d0000 + CRT_ORG_BANK_0D
    SECTION CODE_13
    SECTION RODATA_13

    SECTION BANK_0E
    org $0e0000 + CRT_ORG_BANK_0E
    SECTION CODE_14
    SECTION RODATA_14

    SECTION BANK_0F
    org $0f0000 + CRT_ORG_BANK_0F
    SECTION CODE_15
    SECTION RODATA_15

    SECTION BANK_10
    org $100000 + CRT_ORG_BANK_10
    SECTION CODE_16
    SECTION RODATA_16

    SECTION BANK_11
    org $110000 + CRT_ORG_BANK_11
    SECTION CODE_17
    SECTION RODATA_17

    SECTION BANK_18
    org $180000 + CRT_ORG_BANK_18
    SECTION CODE_24
    SECTION RODATA_24

    SECTION BANK_19
    org $190000 + CRT_ORG_BANK_19
    SECTION CODE_25
    SECTION RODATA_25

    SECTION BANK_1A
    org $1a0000 + CRT_ORG_BANK_1A
    SECTION CODE_26
    SECTION RODATA_26

    SECTION BANK_1B
    org $1b0000 + CRT_ORG_BANK_1B
    SECTION CODE_27
    SECTION RODATA_27

    SECTION BANK_1C
    org $1c0000 + CRT_ORG_BANK_1C
    SECTION CODE_28
    SECTION RODATA_28

    SECTION BANK_1D
    org $1d0000 + CRT_ORG_BANK_1D
    SECTION CODE_29
    SECTION RODATA_29

    SECTION BANK_1E
    org $1e0000 + CRT_ORG_BANK_1E
    SECTION CODE_30
    SECTION RODATA_30

    SECTION BANK_1F
    org $1f0000 + CRT_ORG_BANK_1F
    SECTION CODE_31
    SECTION RODATA_31

    SECTION UNASSIGNED
    org 0
