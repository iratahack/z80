;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Linux)
;--------------------------------------------------------
; Processed by Z88DK
;--------------------------------------------------------

	EXTERN __divschar
	EXTERN __divschar_callee
	EXTERN __divsint
	EXTERN __divsint_callee
	EXTERN __divslong
	EXTERN __divslong_callee
	EXTERN __divslonglong
	EXTERN __divslonglong_callee
	EXTERN __divsuchar
	EXTERN __divsuchar_callee
	EXTERN __divuchar
	EXTERN __divuchar_callee
	EXTERN __divuint
	EXTERN __divuint_callee
	EXTERN __divulong
	EXTERN __divulong_callee
	EXTERN __divulonglong
	EXTERN __divulonglong_callee
	EXTERN __divuschar
	EXTERN __divuschar_callee
	EXTERN __modschar
	EXTERN __modschar_callee
	EXTERN __modsint
	EXTERN __modsint_callee
	EXTERN __modslong
	EXTERN __modslong_callee
	EXTERN __modslonglong
	EXTERN __modslonglong_callee
	EXTERN __modsuchar
	EXTERN __modsuchar_callee
	EXTERN __moduchar
	EXTERN __moduchar_callee
	EXTERN __moduint
	EXTERN __moduint_callee
	EXTERN __modulong
	EXTERN __modulong_callee
	EXTERN __modulonglong
	EXTERN __modulonglong_callee
	EXTERN __moduschar
	EXTERN __moduschar_callee
	EXTERN __mulint
	EXTERN __mulint_callee
	EXTERN __mullong
	EXTERN __mullong_callee
	EXTERN __mullonglong
	EXTERN __mullonglong_callee
	EXTERN __mulschar
	EXTERN __mulschar_callee
	EXTERN __mulsuchar
	EXTERN __mulsuchar_callee
	EXTERN __muluchar
	EXTERN __muluchar_callee
	EXTERN __muluschar
	EXTERN __muluschar_callee
	EXTERN __rlslonglong
	EXTERN __rlslonglong_callee
	EXTERN __rlulonglong
	EXTERN __rlulonglong_callee
	EXTERN __rrslonglong
	EXTERN __rrslonglong_callee
	EXTERN __rrulonglong
	EXTERN __rrulonglong_callee
	EXTERN ___mulsint2slong
	EXTERN ___mulsint2slong_callee
	EXTERN ___muluint2ulong
	EXTERN ___muluint2ulong_callee
	EXTERN ___sdcc_call_hl
	EXTERN ___sdcc_call_iy
	EXTERN ___sdcc_enter_ix
	EXTERN banked_call
	EXTERN _banked_ret
	EXTERN ___fs2schar
	EXTERN ___fs2schar_callee
	EXTERN ___fs2sint
	EXTERN ___fs2sint_callee
	EXTERN ___fs2slong
	EXTERN ___fs2slong_callee
	EXTERN ___fs2slonglong
	EXTERN ___fs2slonglong_callee
	EXTERN ___fs2uchar
	EXTERN ___fs2uchar_callee
	EXTERN ___fs2uint
	EXTERN ___fs2uint_callee
	EXTERN ___fs2ulong
	EXTERN ___fs2ulong_callee
	EXTERN ___fs2ulonglong
	EXTERN ___fs2ulonglong_callee
	EXTERN ___fsadd
	EXTERN ___fsadd_callee
	EXTERN ___fsdiv
	EXTERN ___fsdiv_callee
	EXTERN ___fseq
	EXTERN ___fseq_callee
	EXTERN ___fsgt
	EXTERN ___fsgt_callee
	EXTERN ___fslt
	EXTERN ___fslt_callee
	EXTERN ___fsmul
	EXTERN ___fsmul_callee
	EXTERN ___fsneq
	EXTERN ___fsneq_callee
	EXTERN ___fssub
	EXTERN ___fssub_callee
	EXTERN ___schar2fs
	EXTERN ___schar2fs_callee
	EXTERN ___sint2fs
	EXTERN ___sint2fs_callee
	EXTERN ___slong2fs
	EXTERN ___slong2fs_callee
	EXTERN ___slonglong2fs
	EXTERN ___slonglong2fs_callee
	EXTERN ___uchar2fs
	EXTERN ___uchar2fs_callee
	EXTERN ___uint2fs
	EXTERN ___uint2fs_callee
	EXTERN ___ulong2fs
	EXTERN ___ulong2fs_callee
	EXTERN ___ulonglong2fs
	EXTERN ___ulonglong2fs_callee
	EXTERN ____sdcc_2_copy_src_mhl_dst_deix
	EXTERN ____sdcc_2_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_deix
	EXTERN ____sdcc_4_copy_src_mhl_dst_bcix
	EXTERN ____sdcc_4_copy_src_mhl_dst_mbc
	EXTERN ____sdcc_4_ldi_nosave_bc
	EXTERN ____sdcc_4_ldi_save_bc
	EXTERN ____sdcc_4_push_hlix
	EXTERN ____sdcc_4_push_mhl
	EXTERN ____sdcc_lib_setmem_hl
	EXTERN ____sdcc_ll_add_de_bc_hl
	EXTERN ____sdcc_ll_add_de_bc_hlix
	EXTERN ____sdcc_ll_add_de_hlix_bc
	EXTERN ____sdcc_ll_add_de_hlix_bcix
	EXTERN ____sdcc_ll_add_deix_bc_hl
	EXTERN ____sdcc_ll_add_deix_hlix
	EXTERN ____sdcc_ll_add_hlix_bc_deix
	EXTERN ____sdcc_ll_add_hlix_deix_bc
	EXTERN ____sdcc_ll_add_hlix_deix_bcix
	EXTERN ____sdcc_ll_asr_hlix_a
	EXTERN ____sdcc_ll_asr_mbc_a
	EXTERN ____sdcc_ll_copy_src_de_dst_hlix
	EXTERN ____sdcc_ll_copy_src_de_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_deix_dst_hl
	EXTERN ____sdcc_ll_copy_src_deix_dst_hlix
	EXTERN ____sdcc_ll_copy_src_deixm_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_desp_dst_hlsp
	EXTERN ____sdcc_ll_copy_src_hl_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_de
	EXTERN ____sdcc_ll_copy_src_hlsp_dst_deixm
	EXTERN ____sdcc_ll_lsl_hlix_a
	EXTERN ____sdcc_ll_lsl_mbc_a
	EXTERN ____sdcc_ll_lsr_hlix_a
	EXTERN ____sdcc_ll_lsr_mbc_a
	EXTERN ____sdcc_ll_push_hlix
	EXTERN ____sdcc_ll_push_mhl
	EXTERN ____sdcc_ll_sub_de_bc_hl
	EXTERN ____sdcc_ll_sub_de_bc_hlix
	EXTERN ____sdcc_ll_sub_de_hlix_bc
	EXTERN ____sdcc_ll_sub_de_hlix_bcix
	EXTERN ____sdcc_ll_sub_deix_bc_hl
	EXTERN ____sdcc_ll_sub_deix_hlix
	EXTERN ____sdcc_ll_sub_hlix_bc_deix
	EXTERN ____sdcc_ll_sub_hlix_deix_bc
	EXTERN ____sdcc_ll_sub_hlix_deix_bcix
	EXTERN ____sdcc_load_debc_deix
	EXTERN ____sdcc_load_dehl_deix
	EXTERN ____sdcc_load_debc_mhl
	EXTERN ____sdcc_load_hlde_mhl
	EXTERN ____sdcc_store_dehl_bcix
	EXTERN ____sdcc_store_debc_hlix
	EXTERN ____sdcc_store_debc_mhl
	EXTERN ____sdcc_cpu_pop_ei
	EXTERN ____sdcc_cpu_pop_ei_jp
	EXTERN ____sdcc_cpu_push_di
	EXTERN ____sdcc_outi
	EXTERN ____sdcc_outi_128
	EXTERN ____sdcc_outi_256
	EXTERN ____sdcc_ldi
	EXTERN ____sdcc_ldi_128
	EXTERN ____sdcc_ldi_256
	EXTERN ____sdcc_4_copy_srcd_hlix_dst_deix
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_deix
	EXTERN ____sdcc_4_or_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_dehl_dst_bcix
	EXTERN ____sdcc_4_and_src_dehl_dst_bcix
	EXTERN ____sdcc_4_xor_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_mbc_mhl_dst_debc
	EXTERN ____sdcc_4_cpl_src_mhl_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_or_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_mhl_dst_debc
	EXTERN ____sdcc_4_and_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_or_src_debc_hlix_dst_debc
	EXTERN ____sdcc_4_xor_src_debc_hlix_dst_debc

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	GLOBAL _stc4_buffer
	GLOBAL _SMS_SRAM
	GLOBAL _SRAM_bank_to_be_mapped_on_slot2
	GLOBAL _ROM_bank_to_be_mapped_on_slot0
	GLOBAL _ROM_bank_to_be_mapped_on_slot1
	GLOBAL _ROM_bank_to_be_mapped_on_slot2
	GLOBAL _SMS_loadSTC4compressedTilesatAddr
;--------------------------------------------------------
; Externals used
;--------------------------------------------------------
	GLOBAL _SMS_nmi_isr
	GLOBAL _SMS_isr
	GLOBAL _SMS_debugPrintf
	GLOBAL _UNSAFE_SMS_VRAMmemcpy
	GLOBAL _UNSAFE_SMS_VRAMmemcpy128
	GLOBAL _UNSAFE_SMS_VRAMmemcpy96
	GLOBAL _UNSAFE_SMS_VRAMmemcpy64
	GLOBAL _UNSAFE_SMS_VRAMmemcpy32
	GLOBAL _UNSAFE_SMS_copySpritestoSAT
	GLOBAL _SMS_VRAMmemsetW
	GLOBAL _SMS_VRAMmemset_f
	GLOBAL _SMS_VRAMmemcpy_brief
	GLOBAL _SMS_VRAMmemcpy
	GLOBAL _SMS_getVCount
	GLOBAL _SMS_setLineCounter
	GLOBAL _SMS_setLineInterruptHandler
	GLOBAL _SMS_setFrameInterruptHandler
	GLOBAL _SMS_resetPauseRequest
	GLOBAL _SMS_queryPauseRequested
	GLOBAL _SMS_readPaddle
	GLOBAL _SMS_detectPaddle
	GLOBAL _SMS_getKeysReleased
	GLOBAL _SMS_getKeysHeld
	GLOBAL _SMS_getKeysPressed
	GLOBAL _SMS_getKeysStatus
	GLOBAL _SMS_decompressaPLib
	GLOBAL _SMS_decompressZX7
	GLOBAL _SMS_print
	GLOBAL _SMS_putchar
	GLOBAL _SMS_autoSetUpTextRenderer
	GLOBAL _SMS_configureTextRenderer
	GLOBAL _SMS_loadSpritePaletteafterColorSubtraction
	GLOBAL _SMS_loadBGPaletteafterColorSubtraction
	GLOBAL _SMS_loadSpritePaletteafterColorAddition
	GLOBAL _SMS_loadBGPaletteafterColorAddition
	GLOBAL _SMS_zeroSpritePalette
	GLOBAL _SMS_zeroBGPalette
	GLOBAL _SMS_loadSpritePaletteHalfBrightness
	GLOBAL _SMS_loadBGPaletteHalfBrightness
	GLOBAL _SMS_setColor
	GLOBAL _SMS_loadSpritePalette
	GLOBAL _SMS_loadBGPalette
	GLOBAL _SMS_setSpritePaletteColor
	GLOBAL _SMS_setBGPaletteColor
	GLOBAL _SMS_addMetaSprite_f
	GLOBAL _SMS_copySpritestoSAT
	GLOBAL _SMS_finalizeSprites
	GLOBAL _SMS_addSpriteClipping
	GLOBAL _SMS_setClippingWindow
	GLOBAL _SMS_hideSprite
	GLOBAL _SMS_updateSpriteImage
	GLOBAL _SMS_updateSpritePosition
	GLOBAL _SMS_reserveSprite
	GLOBAL _SMS_addFourAdjoiningSprites_f
	GLOBAL _SMS_addThreeAdjoiningSprites_f
	GLOBAL _SMS_addTwoAdjoiningSprites_f
	GLOBAL _SMS_addSprite_f
	GLOBAL _SMS_initSprites
	GLOBAL _SMS_readVRAM
	GLOBAL _SMS_saveTileMapColumnatAddr
	GLOBAL _SMS_saveTileMapArea
	GLOBAL _SMS_getTile
	GLOBAL _SMS_loadSTMcompressedTileMapatAddr
	GLOBAL _SMS_loadTileMapColumnatAddr
	GLOBAL _SMS_loadTileMapAreaatAddr
	GLOBAL _UNSAFE_SMS_loadaPLibcompressedTilesatAddr
	GLOBAL _SMS_decompressZX7toVRAM
	GLOBAL _SMS_loadPSGaidencompressedTilesatAddr
	GLOBAL _SMS_loadSTC0compressedTilesatAddr
	GLOBAL _SMS_load2bppTilesatAddr
	GLOBAL _SMS_load1bppTiles
	GLOBAL _SMS_crt0_RST18
	GLOBAL _SMS_crt0_RST08
	GLOBAL _SMS_waitForVBlank
	GLOBAL _SMS_setSpriteMode
	GLOBAL _SMS_useFirstHalfTilesforSprites
	GLOBAL _SMS_setBackdropColor
	GLOBAL _SMS_setBGScrollY
	GLOBAL _SMS_setBGScrollX
	GLOBAL _SMS_VDPturnOffFeature
	GLOBAL _SMS_VDPturnOnFeature
	GLOBAL _SMS_init
	GLOBAL _SMS_Port3EBIOSvalue
	GLOBAL _SMS_VDPFlags
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
defc _SMS_VDPControlPort	=	0x00bf
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	SECTION bss_compiler
defc _ROM_bank_to_be_mapped_on_slot2	=	0xffff
defc _ROM_bank_to_be_mapped_on_slot1	=	0xfffe
defc _ROM_bank_to_be_mapped_on_slot0	=	0xfffd
defc _SRAM_bank_to_be_mapped_on_slot2	=	0xfffc
defc _SMS_SRAM	=	0x8000
_stc4_buffer:
	DEFS 4
;--------------------------------------------------------
; ram data
;--------------------------------------------------------

IF 0

; .area _INITIALIZED removed by z88dk


ENDIF

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	SECTION IGNORE
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	SECTION code_crt_init
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	SECTION code_home
;--------------------------------------------------------
; code
;--------------------------------------------------------
	SECTION code_compiler
;SMSlib/SMSlib_STC4comp.c:16: di
;	---------------------------------
; Function SMS_loadSTC4compressedTilesatAddr
; ---------------------------------
_SMS_loadSTC4compressedTilesatAddr:
;SMSlib/SMSlib_STC4comp.c:133: ERROR: no line number 133 in file SMSlib/SMSlib_STC4comp.c
	ld	c,0xbf
	set	6,d
	di
	out	(c),e
	out	(c),d
	ei
_stc4_decompress_outer_loop:
	ld	a,(hl)
	cp	+0x20
	jr	c,_reruns_or_leave
	ld	b,4
	ld	de,_stc4_buffer
_stc4_decompress_inner_loop:
	rla
	jr	c,_compressed_00_or_FF
	rla
	jr	nc,_same_or_diff
	ld	c,a
	inc	hl
	ld	a,(hl)
_stc4_write_byte:
	out	(0xbe),a
	ld	(de),a
	inc	de
	ld	a,c
	djnz	_stc4_decompress_inner_loop
	inc	hl
	jp	_stc4_decompress_outer_loop
_compressed_00_or_FF:
	rla
	ld	c,a
	sbc	a
	jp	_stc4_write_byte
_same_or_diff:
	bit	2,b
	jr	nz,_diff
_same_byte:
	ld	c,a
	ld	a,(hl)
	jp	_stc4_write_byte
;	************************************
_diff:
	rla
	ld	c,a
	rla
_diff_loop:
	rla
	ld	iyl,a
	jr	c,_raw_value_follows
	ld	a,(de)
	bit	7,c
	jr	z,_write_diff_byte
	cpl
	ld	(de),a
_write_diff_byte:
	out	(0xbe),a
	ld	a,iyl
	inc	de
	djnz	_diff_loop
	inc	hl
	jp	_stc4_decompress_outer_loop
_raw_value_follows:
	inc	hl
	ld	a,(hl)
	ld	(de),a
	jp	_write_diff_byte
;	************************************
_reruns_or_leave:
	and	+0x1F
	ret	z
	ld	b,a
_transfer_whole_buffer_B_times:
	ld	de,_stc4_buffer
	ld	a,(de)
	out	(0xbe),a
	4
	inc	de
	ld	a,(de)
	out	(0xbe),a
	4
	inc	de
	ld	a,(de)
	out	(0xbe),a
	4
	inc	de
	ld	a,(de)
	out	(0xbe),a
	djnz	_transfer_whole_buffer_B_times
	inc	hl
	jp	_stc4_decompress_outer_loop
;SMSlib/SMSlib_STC4comp.c:134: ERROR: no line number 134 in file SMSlib/SMSlib_STC4comp.c
	SECTION IGNORE
