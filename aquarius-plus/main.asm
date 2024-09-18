CRT_ORG_CODE    equ $4000
print_c_string  equ $210c

        org     CRT_ORG_CODE
_main:
        ld      hl, message
        call    print_c_string
        ret

        section rodata
message:
        db      "Hello World!", $00
