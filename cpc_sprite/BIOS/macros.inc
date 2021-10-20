
        ;
        ; Add 'a' to 'de'
        ;
addde   MACRO
        add     e
        ld      e, a
        adc     d
        sub     e
        ld      d, a
        ENDM

                ;
        ; Add 'a' to 'hl'
        ;
addhl   MACRO
        add     l
        ld      l, a
        adc     h
        sub     l
        ld      h, a
        ENDM
