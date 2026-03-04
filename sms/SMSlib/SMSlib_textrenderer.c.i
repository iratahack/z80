
#line 1 "SMSlib/SMSlib_textrenderer.c"



 

#line 1 "/snap/z88dk/current/share/z88dk/cmake/../include/stdio.h"




#line 1 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/compiler.h"






#line 1 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/proto.h"



 
 


#line 21 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/proto.h"

#line 35 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/proto.h"

#line 49 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/proto.h"

#line 63 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/proto.h"



#line 7 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/compiler.h"




#line 29 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/compiler.h"


 

#line 43 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/compiler.h"

 


 



 








 





























#line 5 "/snap/z88dk/current/share/z88dk/cmake/../include/stdio.h"

#line 1 "/snap/z88dk/current/share/z88dk/cmake/../include/stdint.h"




 





#line 1 "/snap/z88dk/current/share/z88dk/cmake/../include/sys/types.h"






 







typedef float float_t;








typedef float double_t;









typedef short _Float16;             



typedef _Float16 half_t;





typedef unsigned int size_t;




typedef signed int ssize_t;




typedef unsigned long clock_t;




typedef signed int pid_t;




typedef unsigned char bool_t;




typedef unsigned int ino_t;




typedef unsigned long nseconds_t;




typedef long time_t;




typedef short wild_t;




typedef unsigned long fpos_t;



typedef unsigned char   u8_t;       
typedef unsigned short u16_t;       
typedef unsigned long  u32_t;       

typedef char            i8_t;       
typedef short          i16_t;       
typedef long           i32_t;       

 



   typedef unsigned char uchar;     




   typedef unsigned int uint;       


 











#line 12 "/snap/z88dk/current/share/z88dk/cmake/../include/stdint.h"

typedef signed char            int8_t;
typedef signed int             int16_t;
typedef signed long            int32_t;

typedef unsigned char          uint8_t;
typedef unsigned int           uint16_t;
typedef unsigned long          uint32_t;

typedef signed char            int_least8_t;
typedef signed int             int_least16_t;
typedef signed long            int_least32_t;

typedef unsigned char          uint_least8_t;
typedef unsigned int           uint_least16_t;
typedef unsigned long          uint_least32_t;

typedef signed int             int_fast8_t;
typedef signed int             int_fast16_t;
typedef signed long            int_fast32_t;

typedef unsigned int           uint_fast8_t;
typedef unsigned int           uint_fast16_t;
typedef unsigned long          uint_fast32_t;

typedef long long              int64_t;
typedef unsigned long long     uint64_t;

typedef long long              int_least64_t;
typedef unsigned long long     uint_least64_t;

typedef long long              int_fast64_t;
typedef unsigned long long     uint_fast64_t;




typedef int                    intptr_t;


typedef unsigned int           uintptr_t;

typedef long                   intmax_t;
typedef unsigned long          uintmax_t;


















































 
 






 
 
















#line 6 "/snap/z88dk/current/share/z88dk/cmake/../include/stdio.h"

 





















 




 









 













#line 70 "/snap/z88dk/current/share/z88dk/cmake/../include/stdio.h"





 


#line 1 "/snap/z88dk/current/share/z88dk/cmake/../include/fcntl.h"








 



















 


typedef int mode_t;

 extern int  open ( const char *  name , int  flags , mode_t  mode ) __smallc; 
 extern int  creat ( const char *  name , mode_t  mode ) __smallc; 

extern int    close(int fd);

 extern ssize_t  read ( int  fd , void *  ptr , size_t  len ) __smallc; 
 extern ssize_t  write ( int  fd , void *  ptr , size_t  len ) __smallc; 


extern long       lseek(int fd,long posn, int whence) __smallc;




extern int    readbyte(int fd) __z88dk_fastcall;   
 extern int  writebyte ( int  fd , int  c ) __smallc; 

extern int    fsync(int fd);

 
 


 extern char  *  getcwd ( char *  buf , size_t  newlen ) __smallc; 
extern int    chdir(const char *dir);
extern char    *getwd(char *buf);

 
extern int     rmdir(const char *);




 










 


extern void *_RND_BLOCKSIZE;





 
 

struct RND_FILE {
	char    name_prefix;    
	char    name[15];          
	i16_t	blocksize;
	unsigned char *blockptr;
	long    size;              
	long    position;          
	i16_t	pos_in_block;
	mode_t  mode;
};


 
 extern int  rnd_loadblock ( char *  name , void *  loadstart , size_t  len ) __smallc; 
 extern int  rnd_saveblock ( char *  name , void *  loadstart , size_t  len ) __smallc; 

extern int      rnd_erase(char *name);

extern int      rnd_erase_fastcall(char *name) __z88dk_fastcall;




 


#line 79 "/snap/z88dk/current/share/z88dk/cmake/../include/stdio.h"












struct filestr {
        union f0xx {
                int         fd;
                uint8_t    *ptr;
        } desc;
        uint8_t   flags;
        uint8_t   ungetc;
        intptr_t  extra;
        uint8_t   flags2;
        uint8_t   reserved;
        uint8_t   reserved1;
        uint8_t   reserved2;
};




 

 

 

 

 

 






 

#line 141 "/snap/z88dk/current/share/z88dk/cmake/../include/stdio.h"
typedef struct filestr FILE;




 











 

extern void *_FOPEN_MAX;




extern struct filestr _sgoioblk[10]; 
extern struct filestr _sgoioblk_end; 







 
 
 
 
 
 
 
 
 
 








 





extern FILE    *fopen_zsock(char *name);

 
extern int    fileno(FILE *stream) __smallc __z88dk_fastcall;

 

 extern FILE  *  fopen ( const char *  name , const char *  mode ) __smallc; 
 extern FILE  *  freopen ( const char *  name , const char *  mode , FILE *  fp ) __smallc; 
 extern FILE  *  fdopen ( const int  fileds , const char *  mode ) __smallc; 

 extern FILE  *  _freopen1 ( const char *  name , int  fd , const char *  mode , FILE *  fp ) __smallc; 
 extern FILE  *  fmemopen ( void *  buf , size_t  size , const char *  mode ) __smallc; 

 

extern FILE    *funopen(const void     *cookie, int (*readfn)(void *, char *, int),
                    int (*writefn)(void *, const char *, int),
                    fpos_t (*seekfn)(void *, fpos_t, int), int (*closefn)(void *)) __smallc;


extern int     fclose(FILE *fp);
extern int     fflush(FILE *);

extern void    closeall(void);



 
 

 extern char  *  fgets ( char *  s , int  l , FILE *  fp ) __smallc; 

 extern int  fputs ( const char *  s , FILE *  fp ) __smallc; 

extern int     fputs_callee(const char *s,  FILE *fp) __smallc __z88dk_callee;





extern int    fputc(int c, FILE *fp) __smallc;

extern int     fputc_callee(int c, FILE *fp) __smallc __z88dk_callee;




 




extern int    fgetc(FILE *fp);


 extern int  ungetc ( int  c , FILE *  fp ) __smallc; 

extern int    feof(FILE *fp);

extern int    feof_fastcall(FILE *fp) __z88dk_fastcall;




extern int    ferror(FILE *fp);

extern int    ferror_fastcall(FILE *fp) __z88dk_fastcall;



extern int    puts(const char *);







 
extern fpos_t    ftell(FILE *fp);
 extern int  fgetpos ( FILE *  fp , fpos_t *  pos ) __smallc; 



extern int       fseek(FILE *fp, fpos_t offset, int whence) __smallc;







 
 extern int  fread ( void *  ptr , size_t  size , size_t  num , FILE *  fp ) __smallc; 
 extern int  fwrite ( void *  ptr , size_t  size , size_t  num , FILE *  fp ) __smallc; 


extern char    *gets(char *s);

extern int    printf(const char *fmt,...)   ;
extern int    fprintf(FILE *f,const char *fmt,...)   ;
extern int    sprintf(char *s,const char *fmt,...)   ;
extern int    snprintf(char *s,size_t n,const char *fmt,...)   ;
extern int    vfprintf(FILE *f,const char *fmt,void *ap);
extern int    vsnprintf(char *str, size_t n,const char *fmt,void *ap);





 








 
extern void    printn(int number, int radix,FILE *file) __smallc;




 

extern int    scanf(const char *fmt,...)   ;
extern int    fscanf(FILE *,const char *fmt,...)   ;
extern int    sscanf(char *,const char *fmt,...)   ;
extern int    vfscanf(FILE *, const char *fmt, void *ap); 
extern int    vsscanf(char *str, const char *fmt, void *ap);





 



extern int    getarg(void);



 
extern int    fchkstd(FILE *);

 

 
extern int    fgetc_cons(void);

 
extern int    fgetc_cons_inkey(void);

 
extern int    fputc_cons(char c);

 
 extern char  *  fgets_cons ( char *  s , size_t  n ) __smallc; 

extern int    puts_cons(char *s);

 
extern void    fabandon(FILE *);
 
extern long    fdtell(int fd);
 extern int  fdgetpos ( int  fd , fpos_t *  pos ) __smallc; 
 
 extern int  rename ( const char *  s , const char *  d ) __smallc; 
 
extern int    remove(const char *name);


 
extern int    getk(void);
 
extern int    getk_inkey(void);


 
extern int    printk(const char *fmt,...)   ;

 
extern void    perror(const char *msg) __z88dk_fastcall;






 

typedef int (*fputc_cons_func)(char c);
 
extern fputc_cons_func    set_fputc_cons(fputc_cons_func func);

 
extern int    fputc_cons_native(char c);
 
extern int    fputc_cons_generic(char c);
 
extern int    fputc_cons_ansi(char c);





 






#line 6 "SMSlib/SMSlib_textrenderer.c"

#line 1 "SMSlib/SMSlib.h"



 

 
 

 
 

 
 

 
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

 

#line 315 "SMSlib/SMSlib.h"
 







 





 






 



 


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

 



 


 










#line 446 "SMSlib/SMSlib.h"
 

 

 


 










#line 478 "SMSlib/SMSlib.h"
 






 
void SMS_isr (void) __naked;
void SMS_nmi_isr (void) __naked;

 

#line 7 "SMSlib/SMSlib_textrenderer.c"

#line 1 "SMSlib/SMSlib_common.c"



 











 







 
 
__sfr __at 0xBF VDPControlPort;
 
__sfr __at 0xBF VDPStatusPort;
 
__sfr __at 0xBE VDPDataPort;
 
__sfr __at 0x7E VDPVCounterPort;
 
__sfr __at 0x7F VDPHCounterPort;

inline void SMS_write_to_VDPRegister (unsigned char VDPReg, unsigned char value) {
   
  unsigned char v=value;
   __asm di __endasm ;
  VDPControlPort=v;
  VDPControlPort=VDPReg|0x80;
   __asm ei __endasm ;
}

inline void SMS_byte_to_VDP_data (unsigned char data) {
   
  VDPDataPort=data;
}

inline void SMS_byte_array_to_VDP_data (const unsigned char *data, unsigned int size) {
   
  do {
    VDPDataPort=*(data++);
  } while (--size);
}

inline void SMS_byte_brief_array_to_VDP_data (const unsigned char *data, unsigned char size) {
   
  do {
    VDPDataPort=*(data++);
  } while (--size);
}









   
   
   






   
   
   







   
   







#line 8 "SMSlib/SMSlib_textrenderer.c"

signed int SMS_TextRenderer_offset;

void SMS_configureTextRenderer (signed int ascii_to_tile_offset) __z88dk_fastcall {
  SMS_TextRenderer_offset=ascii_to_tile_offset;
}

#pragma save


#pragma disable_warning 59



int  fputc_callee( int c , &_sgoioblk[1] )  {
   SMS_crt0_RST18( c+SMS_TextRenderer_offset ) ;
}

#pragma restore


