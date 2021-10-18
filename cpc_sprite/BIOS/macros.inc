
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
