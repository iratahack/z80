        #include    "plus.inc"
        section code_user
        extern  printf
        public  _main
_main:
        ld      hl, message
        push    hl
        ld      a, $01
        call    printf
        pop     bc

        ld      a, USER_RAM
        out     (IO_BANK0), a
        rst     0

        ld      hl, $0000
        ret

        section rodata_user
message:
        db      "Hello World!\n", $00
