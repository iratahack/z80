        section code_compiler
	extern	printf
        public  _main
_main:
        ld      hl, message
        push    hl
        ld      a, $01
        call    printf
        pop     bc
        ld      hl, $0000
        ret

	section	rodata_compiler
message:
	db	"Hello World!\n", $00
