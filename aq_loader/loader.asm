        #include    "plus.inc"
        #include    "ioctl.def"

        extern  _titleMusic
        extern  asm_dzx0_turbo
        extern  banked_call
        extern  bordercolor
        extern  generic_console_ioctl

        public  _main

        section code_user
_main:
	; Set the border color
        ld      l, $00
        call    bordercolor

	; Display the image
        call    displayImage

	; Enable bitmap mode
        ld      a, VCTRL_MODE_BM
        out     (IO_VCTRL), a

	; Play music
        call    _titleMusic

        ret


displayImage:
	; Save bank 0 mapping
        in      a, (IO_BANK0)
        push    af

	; Map video RAM to bank 0
        ld      a, VIDEO_RAM
        out     (IO_BANK0), a

	; Uncompress the image
        ld      hl, image
        ld      de, BANK0_BASE
        call    asm_dzx0_turbo

	; Set the image palette
        LD      A, $20
        LD      HL, BANK0_BASE+BMP_PAL_OFS
        LD      DE, (IO_VPALSEL<<8)|IO_VPALDATA
LOUT:
        LD      C, D
        OUT     (C), A
        LD      C, E
        OUTI
        INC     A
        CP      $40
        JR      NZ, LOUT

	; Restore bank 0 mapping
        pop     af
        out     (IO_BANK0), a
        ret

        section rodata_user
image:
        binary  "loading_screen.scr.zx0"
