CRT_ORG_CODE    equ $4000
	#include "kernel.inc"

        org     CRT_ORG_CODE
_main:
        ld      hl, message
        call    print_c_string
        ret

        section rodata
message:
        db      "Hello World!", $00
