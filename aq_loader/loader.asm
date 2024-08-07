str_tempdesc    	equ $2115
load_addr   		equ $4000
file_len    		equ 9192
file_load_binary    	equ $C042
aux_call    		equ $2100                   ; Call routine in auxillary ROM
bank_1			equ $f1
VPALSEL			equ $EA
VPALDATA		equ $EB
VCTRL			equ $e0

        org     $38E1
        binary  "loader.bas"

	ld	a, 20
	out	(bank_1), a

        ld      de, filename            ; DE = Filename address
        call    str_tempdesc            ; Build string descriptor for save
        ld      de, load_addr           ; DE = Data start address
        ld      bc, file_len            ; BC = Data length
        ld      iy, file_load_binary    ; Call load routine
        call    aux_call                ; in auxillary ROM

	ld	hl, load_addr+(40*200)
	ld	b, 32
	ld	a, 32
setPal:
	out	(VPALSEL), a
	inc	a

	ex	af, af'
	ld	a, (hl)
	inc	hl
	out	(VPALDATA), a
	ex	af, af'

	djnz	setPal

	ld	a, 2<<1
	out	(VCTRL), a
        jr      $

filename:
        byte    "loading_screen.scr", 0
