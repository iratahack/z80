
#line 1 "/home/devel/git/z80/sms/SMSlib/SMSlib_STC4comp.c"



 


#line 1 "/home/devel/git/z80/sms/SMSlib/SMSlib.h"



 

 
 

 
 

 
 

 
void SMS_init (void);

 
 
 

void SMS_VDPturnOnFeature (unsigned int feature) __z88dk_fastcall;
void SMS_VDPturnOffFeature (unsigned int feature)__z88dk_fastcall;
 
 

 







 







 
 

 



void SMS_setBGScrollX (unsigned char scrollX) __z88dk_fastcall;
void SMS_setBGScrollY (unsigned char scrollY) __z88dk_fastcall;
void SMS_setBackdropColor (unsigned char entry) __z88dk_fastcall;
void SMS_useFirstHalfTilesforSprites (_Bool usefirsthalf) __z88dk_fastcall;
void SMS_setSpriteMode (unsigned char mode) __z88dk_fastcall;
 





 
void SMS_waitForVBlank (void);

 
 
 

 
volatile __at (0xffff) unsigned char ROM_bank_to_be_mapped_on_slot2;


 


 
 
 
 
 
 
 



 
volatile __at (0xfffe) unsigned char ROM_bank_to_be_mapped_on_slot1;
volatile __at (0xfffd) unsigned char ROM_bank_to_be_mapped_on_slot0;

 
volatile __at (0xfffc) unsigned char SRAM_bank_to_be_mapped_on_slot2;




 
__at (0x8000) unsigned char SMS_SRAM[];

 
 
 

void SMS_crt0_RST08(unsigned int addr) __z88dk_fastcall __preserves_regs(a,b,d,e,h,l,iyh,iyl);
void SMS_crt0_RST18(unsigned int tile) __z88dk_fastcall __preserves_regs(b,c,d,e,h,l,iyh,iyl);

 



 

 








 


 





 

void SMS_load1bppTiles (const void *src, unsigned int tilefrom, unsigned int size, unsigned char color0, unsigned char color1);

void SMS_load2bppTilesatAddr (const void *src, unsigned int dest, unsigned int size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1);

 

void SMS_loadSTC0compressedTilesatAddr (const void *src, unsigned int dst) __naked __sdcccall(1);

void SMS_loadSTC4compressedTilesatAddr (const void *src, unsigned int dst) __naked __sdcccall(1);

void SMS_loadPSGaidencompressedTilesatAddr (const void *src, unsigned int dst) __naked __sdcccall(1);


void SMS_decompressZX7toVRAM (const void *src, unsigned int dst) __naked __sdcccall(1);

 

void UNSAFE_SMS_loadaPLibcompressedTilesatAddr (const void *src, unsigned int dst) __naked __sdcccall(1);

 


void SMS_loadTileMapAreaatAddr (unsigned int dst, const void *src, unsigned char width, unsigned char height) __naked __z88dk_callee __sdcccall(1);


void SMS_loadTileMapColumnatAddr (unsigned int dst, const void *src, unsigned int height) __naked __z88dk_callee __sdcccall(1);


void SMS_loadSTMcompressedTileMapatAddr (unsigned int dst, const void *src);


 

 
unsigned int SMS_getTile(void) __naked __z88dk_fastcall __preserves_regs(b,c,d,e,iyh,iyl);

 


 







 
void SMS_saveTileMapArea(unsigned char x, unsigned char y, void *dst, unsigned char width, unsigned char height);
void * SMS_saveTileMapColumnatAddr(unsigned int src, void *dst, unsigned int height) __naked __z88dk_callee __sdcccall(1);

void SMS_readVRAM(void *dst, unsigned int src, unsigned int size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1);

 
 
 

void SMS_initSprites (void);





 
 
 
 

signed char SMS_addSprite_f (unsigned int y, unsigned int x_tile) __naked __preserves_regs(d,e,iyh,iyl) __sdcccall(1);           
void SMS_addTwoAdjoiningSprites_f (unsigned int y, unsigned int x_tile) __naked __preserves_regs(d,e,iyh,iyl) __sdcccall(1);     
void SMS_addThreeAdjoiningSprites_f (unsigned int y, unsigned int x_tile) __naked __preserves_regs(d,e,iyh,iyl) __sdcccall(1);   
void SMS_addFourAdjoiningSprites_f (unsigned int y, unsigned int x_tile) __naked __preserves_regs(d,e,iyh,iyl) __sdcccall(1);    

signed char SMS_reserveSprite (void);
void SMS_updateSpritePosition (signed char sprite, unsigned char x, unsigned char y);
void SMS_updateSpriteImage (signed char sprite, unsigned char tile);
void SMS_hideSprite (signed char sprite);
void SMS_setClippingWindow (unsigned char x0, unsigned char y0, unsigned char x1, unsigned char y1);
signed char SMS_addSpriteClipping (int x, int y, unsigned char tile);    
void SMS_finalizeSprites (void);      
void SMS_copySpritestoSAT (void);

 


void SMS_addMetaSprite_f (unsigned int origin_yx, void *metasprite) __naked __sdcccall(1);                                      

 
 
 

 



 







 



 









 
void SMS_setBGPaletteColor (unsigned char entry, unsigned char color);
void SMS_setSpritePaletteColor (unsigned char entry, unsigned char color);
void SMS_loadBGPalette (const void *palette) __z88dk_fastcall;
void SMS_loadSpritePalette (const void *palette) __z88dk_fastcall;


void SMS_setColor (unsigned char color) __z88dk_fastcall __preserves_regs(b,c,d,e,h,l,iyh,iyl);
 



 
void SMS_loadBGPaletteHalfBrightness (const void *palette) __z88dk_fastcall;
void SMS_loadSpritePaletteHalfBrightness (const void *palette) __z88dk_fastcall;
void SMS_zeroBGPalette (void);
void SMS_zeroSpritePalette (void);
void SMS_loadBGPaletteafterColorAddition (const void *palette, const unsigned char addition_color);
void SMS_loadSpritePaletteafterColorAddition (const void *palette, const unsigned char addition_color);
void SMS_loadBGPaletteafterColorSubtraction (const void *palette, const unsigned char subtraction_color);
void SMS_loadSpritePaletteafterColorSubtraction (const void *palette, const unsigned char subtraction_color);


 
void SMS_configureTextRenderer (signed int ascii_to_tile_offset) __z88dk_fastcall;
void SMS_autoSetUpTextRenderer (void);
void SMS_putchar (unsigned char c);          
void SMS_print (const unsigned char *str);   
 


 
void SMS_decompressZX7 (const void *src, void *dst) __naked __sdcccall(1);
void SMS_decompressaPLib (const void *src, void *dst) __naked __sdcccall(1);

 
 
 

 
unsigned int SMS_getKeysStatus (void);
unsigned int SMS_getKeysPressed (void);
unsigned int SMS_getKeysHeld (void);
unsigned int SMS_getKeysReleased (void);

 

#line 315 "/home/devel/git/z80/sms/SMSlib/SMSlib.h"
 







 





 






 



 


_Bool SMS_detectPaddle (unsigned char port) __z88dk_fastcall __naked;
unsigned char SMS_readPaddle (unsigned char port) __z88dk_fastcall __naked;



 
_Bool SMS_queryPauseRequested (void);
void SMS_resetPauseRequest (void);




 

 





extern volatile unsigned char SMS_VDPFlags;



extern unsigned char SMS_Port3EBIOSvalue;

 

 
 
void SMS_setFrameInterruptHandler (void (*theHandlerFunction)(void)) __z88dk_fastcall;


 
void SMS_setLineInterruptHandler (void (*theHandlerFunction)(void)) __z88dk_fastcall;
void SMS_setLineCounter (unsigned char count) __z88dk_fastcall;



__sfr __at (0xbf) SMS_VDPControlPort;
 


 
unsigned char SMS_getVCount (void) __naked __preserves_regs(c,d,e,h,l,iyh,iyl);

 
void SMS_VRAMmemcpy (unsigned int dst, const void *src, unsigned int size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1);
void SMS_VRAMmemcpy_brief (unsigned int dst, const void *src, unsigned char size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1);

void SMS_VRAMmemset_f (unsigned char value, unsigned int dst, unsigned int size) __naked __z88dk_callee __preserves_regs(a,h,l,iyh,iyl) __sdcccall(1);
void SMS_VRAMmemsetW (unsigned int dst, unsigned int value, unsigned int size) __naked __z88dk_callee __preserves_regs(d,e,iyh,iyl) __sdcccall(1);

 
void UNSAFE_SMS_copySpritestoSAT (void);
void * UNSAFE_SMS_VRAMmemcpy32 (unsigned int dst, const void *src) __naked __preserves_regs(a,iyh,iyl) __sdcccall(1);
void * UNSAFE_SMS_VRAMmemcpy64 (unsigned int dst, const void *src) __naked __preserves_regs(a,iyh,iyl) __sdcccall(1);
void * UNSAFE_SMS_VRAMmemcpy96 (unsigned int dst, const void *src) __naked __preserves_regs(a,iyh,iyl) __sdcccall(1);
void * UNSAFE_SMS_VRAMmemcpy128 (unsigned int dst, const void *src) __naked __preserves_regs(a,iyh,iyl) __sdcccall(1);
void * UNSAFE_SMS_VRAMmemcpy (unsigned int dst, const void *src, unsigned int size) __naked __z88dk_callee __preserves_regs(iyh,iyl) __sdcccall(1);

 







 
void SMS_debugPrintf(const unsigned char *format, ...) __naked __preserves_regs(a,b,c,iyh,iyl);

 



 


 










#line 446 "/home/devel/git/z80/sms/SMSlib/SMSlib.h"
 

 

 


 










#line 478 "/home/devel/git/z80/sms/SMSlib/SMSlib.h"
 






 
void SMS_isr (void) __naked;
void SMS_nmi_isr (void) __naked;

 

#line 7 "/home/devel/git/z80/sms/SMSlib/SMSlib_STC4comp.c"

unsigned char stc4_buffer[4];

#pragma save


#pragma disable_warning 85


void SMS_loadSTC4compressedTilesatAddr (const void *src, unsigned int dst) __naked __sdcccall(1) {
  __asm
  ld c,#0xbf                          ; VDP_CTRL_PORT
  set 6,d                             ; set VRAM address for write
  di
  out (c),e                           ; set VRAM destination address
  out (c),d
  ei

_stc4_decompress_outer_loop:
  ld a,(hl)
  cp #0x20                            ; if value less than 0x20 it is a rerun or an end-of-data marker
  jr c,_reruns_or_leave

  ld b,#4
  ld de,#_stc4_buffer

_stc4_decompress_inner_loop:
  rla
  jr c,_compressed_00_or_FF           ; if 1X found, write $00 or $FF

  rla
  jr nc,_same_or_diff                 ; if 0b00 found it is same or diff

  ld c,a                              ; preserve A
  inc hl
  ld a,(hl)                           ; load uncompressed byte

_stc4_write_byte:
  out (#0xbe),a                       ; write byte to VRAM
  ld (de),a                           ; and to buffer too
  inc de                              ; advance buffer pointer
  ld a,c                              ; restore A
  djnz _stc4_decompress_inner_loop    ; we have got more to process in this byte

  inc hl                              ; move to next byte
  jp _stc4_decompress_outer_loop

_compressed_00_or_FF:
  rla
  ld c,a                              ; preserve A
  sbc a                               ; this turns the CF into $00 or $FF
  jp _stc4_write_byte

_same_or_diff:
  bit 2,b
  jr nz,_diff                         ; if byte is $00nnnnnn then it means it is a diff, not a same byte in the group

_same_byte:
  ld c,a                              ; preserve A
  ld a,(hl)                           ; we won't [inc hl] here because we're loading the same value as before so we are already on that
  jp _stc4_write_byte

; ************************************
_diff:
  rla                                 ; skip D5
  ld c,a                              ; save D4 in C MSB
  rla                                 ; skip D4

_diff_loop:
  rla
  .db 0xFD                            ;   --- SDCC issues workaround
  ld l,a                              ; ld iyl,a  (preserve A)
  jr c,_raw_value_follows             ; when 1 a data byte will follow

  ld a,(de)
  bit 7,c
  jr z,_write_diff_byte

  cpl                                 ; invert data if D4 was set
  ld (de),a                           ; and save it back into the buffer

_write_diff_byte:
  out (#0xbe),a                       ; write byte from buffer to VRAM
  .db 0xFD                            ;   --- SDCC issues workaround
  ld a,l                              ; ld a,iyl (restore A)
  inc de                              ; advance buffer pointer
  djnz _diff_loop                     ; until we are done with the 4 bits

  inc hl                              ; move to next byte
  jp _stc4_decompress_outer_loop      ; loop over

_raw_value_follows:
  inc hl
  ld a,(hl)
  ld (de),a                           ; save it into the buffer
  jp _write_diff_byte

; ************************************
_reruns_or_leave:
  and #0x1F                           ; keep the lowest 5 bits only
  ret z                               ; if value is zero, the EOD marker has been found, so leave

  ld b,a                              ; save reruns counter in B

_transfer_whole_buffer_B_times:
  ld de,#_stc4_buffer
  ld a,(de)                           ; 7
  out (#0xbe),a                       ; 11
  nop                                 ; 4
  inc de                              ; 6  = 28

  ld a,(de)                           ; 7
  out (#0xbe),a                       ; 11
  nop                                 ; 4
  inc de                              ; 6  = 28

  ld a,(de)                           ; 7
  out (#0xbe),a                       ; 11
  nop                                 ; 4
  inc de                              ; 6  = 28

  ld a,(de)                           ; 7
  out (#0xbe),a                       ; 11
  djnz _transfer_whole_buffer_B_times ; 13 = 31

  inc hl                              ; move to next byte
  jp _stc4_decompress_outer_loop      ; loop over

  __endasm;
}
#pragma restore


