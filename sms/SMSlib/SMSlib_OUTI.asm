; **************************************************
; SMSlib - shared OUTI transfer block
; **************************************************

	GLOBAL _OUTI128
	GLOBAL _OUTI96
	GLOBAL _OUTI64
	GLOBAL _OUTI32
	GLOBAL _outi_block

	SECTION code_driver

;--------------------------------------------------------------------------
; here is a block of 128 OUTI instructions, made for enabling
; UNSAFE but FAST short data transfers to VRAM
;--------------------------------------------------------------------------
_OUTI128:
	rept 32
	outi
	endr
_OUTI96:
	rept 32
	outi
	endr
_OUTI64:
	rept 32
	outi
	endr
_OUTI32:
	rept 32
	outi
	endr
_outi_block:
	ret
