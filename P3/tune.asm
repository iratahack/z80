        public  _main

  IF    _SMS
        defc    keyPort=$dc
        defc    PSGDataPort=$7f
        defc    PSGLatch=$80
        defc    PSGData=$40
        defc    PSGChannel0=%00000000
        defc    PSGChannel1=%00100000
        defc    PSGChannel2=%01000000
        defc    PSGChannel3=%01100000
        defc    PSGVolumeData=%00010000
        defc    PSG_VOL=$0f
  ELSE
        defc    keyPort=$fe
        defc    PSGDataPort=$fe
  ENDIF

        section code_user

_main:
        ld      hl, musicData
        call    play
        ret



	;engine code

OP_NOP  equ     $00
OP_INCBC    equ $03
OP_DECBC    equ $0b
OP_INCSP    equ $33
OP_DECSP    equ $3b
OP_INCDE    equ $13
OP_DECDE    equ $1b
OP_DECHL    equ $2b
OP_ANDH equ     $a4
OP_XORH equ     $ac
OP_ORC  equ     $b1
OP_ORH  equ     $b4

        section data_user

play:

        di
  IF    _SMS
        ld      bc, PSGDataPort
        ; Silence all channels
        ; latch channel 0, volume=0xF (silent)
        ld      a, PSGLatch|PSGChannel0|PSGVolumeData|$0f
        out     (c), a
        ld      a, PSGLatch|PSGChannel1|PSGVolumeData|$0f
        out     (c), a
        ld      a, PSGLatch|PSGChannel2|PSGVolumeData|$0f
        out     (c), a
        ld      a, PSGLatch|PSGChannel3|PSGVolumeData|$0f
        out     (c), a

        ; Set tone value for tone channels
        ld      a, PSGLatch|PSGChannel0|$01
        out     (c), a
        out     (c), b

        ld      a, PSGLatch|PSGChannel1|$01
        out     (c), a
        out     (c), b

        ld      a, PSGLatch|PSGChannel2|$01
        out     (c), a
        out     (c), b

        ld      a, PSGLatch|PSGChannel3|$01
        out     (c), a
        out     (c), b
  ENDIF

        exx
        push    iy
        push    hl
        ld      (stopPlayer_oldSP), sp
        exx
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      (readRow_pos), de
        ld      (readRow_loop), de
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      (readRow_insList0), de
        ld      (readRow_insList1), de
        ld      (playDrumSample_drumList), hl

        ld      hl, 0
        ld      (soundInit_ch0cnt0), hl
        ld      ix, 0                   ;ch0cnt1
        ld      (readRow_ch1cnt0), hl
        ld      iy, 0                   ;ch1cnt1
        ld      (soundInit_ch0add0), hl
        ld      sp, hl                  ;ch0add1
        ld      (readRow_ch1add0), hl
        ld      (readRow_ch1add1), hl
        xor     a
        ld      (readRow_ch0int), a
        ld      (readRow_ch1int), a
        ld      (readRow_ch0det), a
        ld      (readRow_ch1det), a
        ld      (soundInit_skip), a
        ld      (soundLoop_phaseSlideDivA), a
        ld      (soundLoop_phaseSlideDivB), a
        ld      a, 64
        ld      (readRow_ch0pha), a
        ld      (readRow_ch1pha), a
        ld      a, 8
        ld      (soundInit_len), a
        exx
        ld      hl, 0                   ;ch1cnt0
        ld      de, 0                   ;ch1add1
        ld      bc, 0                   ;ch1add0
        exx



readRow:

readRow_pos equ $+1
        ld      hl, 0

read:

        ld      a, (hl)
        inc     hl
        cp      245
        jp      c, ch0
        jr      z, setSpeed
        cp      254
        jr      z, setLoop
        cp      255
        jr      z, readLoop
        ld      (readRow_pos), hl
        sub     246
        jp      playDrumSample

setSpeed:

        ld      a, (hl)
        ld      (soundInit_len), a
        inc     hl
        jp      read

setLoop:

        ld      (readRow_loop), hl
        jp      read

readLoop:

readRow_loop    equ $+1
        ld      hl, 0
        jp      read


ch0mute:

        ld      sp, 0
        ld      ix, 0
        ld      (soundInit_ch0cnt0), sp
        ld      (soundInit_ch0add0), sp
        jp      ch1

ch1mute:

        exx
        ld      hl, 0
        ld      iy, 0
        ld      d, h
        ld      e, h
        ld      b, h
        ld      c, h
        exx
        jp      ch1skip

ch0:

        add     a, a
        jp      nc, note0               ;bit 7 is not set, it is a note
        ex      de, hl                  ;set instrument of channel 0

        ld      h, 0
        ld      l, a
        add     hl, hl
        add     hl, hl
readRow_insList0    equ $+1
        ld      bc, 0
        add     hl, bc

        ld      a, (hl)
        inc     hl
        ld      (readRow_ch0int), a
        ld      a, (hl)
        inc     hl
        ld      (readRow_ch0pha), a
        inc     a
        jr      z, $+4
        ld      a, $0a
        xor     $0a
        ld      (phasereset0), a

        ld      a, (hl)
        ld      (readRow_ch0det), a
        inc     hl
        ld      a, (hl)                 ;mix mode
        inc     hl
        ld      (soundLoop_opA0), a
        ld      (soundLoop_opA1), a
        ld      (soundLoop_opA2), a
        ld      (soundLoop_opA3), a

  IF    _SMS
        ld      a, (hl)                 ;volume
        inc     hl
        rrca
        rrca
        rrca
        rrca
        and     $0f
        ld      (soundLoop_volA0), a
        ld      (soundLoop_volA1), a
        ld      (soundLoop_volA2), a
        ld      (soundLoop_volA3), a
  ELSE
        ld      c, (hl)                 ;volume
        inc     hl
        ld      b, 18                   ;out mask - new test
        ld      a, c
        and     b
        ld      (soundLoop_volA0), a
        rr      c
        ld      a, c
        and     b
        ld      (soundLoop_volA1), a
        rr      c
        ld      a, c
        and     b
        ld      (soundLoop_volA2), a
        rr      c
        ld      a, c
        and     b
        ld      (soundLoop_volA3), a
  ENDIF

        ld      a, (hl)                 ;phase slide speed
        inc     hl
        ld      (soundLoop_phaseSlideSpeedA), a

        or      a
        jr      z, $+4
        ld      a, soundLoop_phaseSlideA1-soundLoop_phaseSlideA0
        xor     soundLoop_phaseSlideA1-soundLoop_phaseSlideA0
        ld      (soundLoop_phaseSlideEnableA), a

        ld      bc, 0
        ld      (soundLoop_cntA0Slide+0), bc
        ld      (soundLoop_cntA0Slide+2), bc
        ld      (soundLoop_cntA1Slide+0), bc
        ld      (soundLoop_cntA1Slide+2), bc

        ld      a, (hl)                 ;generator 1 slide
        inc     hl
        ld      c, a
        or      a
        jr      z, ch0noslide0
        and     $0f
        or      OP_INCBC&$f0
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA0Slide+0), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA0Slide+1), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA0Slide+2), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA0Slide+3), a

ch0noslide0:

        ld      a, (hl)                 ;generator 2 slide
        ld      c, a
        or      a
        jr      z, ch0noslide1
        and     $0f
        or      OP_INCSP&$f0
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA1Slide+0), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA1Slide+1), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA1Slide+2), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntA1Slide+3), a

ch0noslide1:

        ex      de, hl
        ld      a, (hl)                 ;instrument always followed by a note
        inc     hl
        add     a, a

note0:

        jp      z, ch1                  ;empty row, skip to the second channel
        cp      2
        jp      z, ch0mute
        ex      de, hl
        ld      l, a

phasereset0 equ $+1
        jr      $+2                     ;$+2 to reset, $+12 to skip

        ld      ix, (soundInit_ch0cnt0)
readRow_ch0pha  equ $+1
        ld      a, 0
        add     a, ixh
        ld      ixh, a

ch0phaseresetskip:

        ld      h, noteTable/256
        ld      c, (hl)
        inc     l
        ld      b, (hl)
        ld      (soundInit_ch0add0), bc
readRow_ch0int  equ $+1
        ld      a, 0
        add     a, l
        ld      l, a
        ld      b, (hl)
        dec     l
        ld      c, (hl)
readRow_ch0det  equ $+1
        ld      hl, 0
        add     hl, bc
        ld      sp, hl                  ;ch0add1
        ex      de, hl

ch1:

        ld      a, (hl)
        inc     hl
        add     a, a
        jp      nc, note1

        ex      de, hl                  ;set instrument of channel 1

        ld      h, 0
        ld      l, a
        add     hl, hl
        add     hl, hl
readRow_insList1    equ $+1
        ld      bc, 0
        add     hl, bc

        ld      a, (hl)
        inc     hl
        ld      (readRow_ch1int), a
        ld      a, (hl)
        inc     hl
        ld      (readRow_ch1pha), a
        inc     a
        jr      z, $+4
        ld      a, $0a
        xor     $0a
        ld      (phasereset1), a

        ld      a, (hl)
        ld      (readRow_ch1det), a
        inc     hl
        ld      a, (hl)                 ;mix mode
        inc     hl
        ld      (soundLoop_opB0), a
        ld      (soundLoop_opB1), a
        ld      (soundLoop_opB2), a
        ld      (soundLoop_opB3), a

  IF    _SMS
        ld      a, (hl)                 ;volume
        inc     hl
        rrca
        rrca
        rrca
        rrca
        and     $0f
        ld      (soundLoop_volB0), a
        ld      (soundLoop_volB1), a
        ld      (soundLoop_volB2), a
        ld      (soundLoop_volB3), a
  ELSE
        ld      c, (hl)                 ;volume
        inc     hl
        ld      b, 18                   ;out mask - new test
        ld      a, c
        and     b
        ld      (soundLoop_volB0), a
        rr      c
        ld      a, c
        and     b
        ld      (soundLoop_volB1), a
        rr      c
        ld      a, c
        and     b
        ld      (soundLoop_volB2), a
        rr      c
        ld      a, c
        and     b
        ld      (soundLoop_volB3), a
  ENDIF

        ld      a, (hl)                 ;phase slide speed
        inc     hl
        ld      (soundLoop_phaseSlideSpeedB), a

        or      a
        jr      z, $+4
        ld      a, soundLoop_phaseSlideB2-soundLoop_phaseSlideB0
        xor     soundLoop_phaseSlideB2-soundLoop_phaseSlideB0
        ld      (soundLoop_phaseSlideEnableB), a

        ld      bc, 0
        ld      (soundLoop_cntB0Slide+0), bc
        ld      (soundLoop_cntB0Slide+2), bc
        ld      (soundLoop_cntB1Slide+0), bc
        ld      (soundLoop_cntB1Slide+2), bc

        ld      a, (hl)                 ;generator 1 slide
        inc     hl
        ld      c, a
        or      a
        jr      z, ch1noslide0
        and     $0f
        or      OP_INCBC&$f0
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB0Slide+0), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB0Slide+1), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB0Slide+2), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB0Slide+3), a

ch1noslide0:

        ld      a, (hl)                 ;generator 2 slide
        ld      c, a
        or      a
        jr      z, ch1noslide1
        and     $0f
        or      OP_INCDE&$f0
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB1Slide+0), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB1Slide+1), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB1Slide+2), a
        rl      c
        jr      nc, $+5
        ld      (soundLoop_cntB1Slide+3), a

ch1noslide1:

        ex      de, hl
        ld      a, (hl)
        inc     hl
        add     a, a

note1:

        jp      z, ch1skip
        cp      2
        jp      z, ch1mute
        ex      de, hl
        ld      l, a

phasereset1 equ $+1
        jr      $+2                     ;$+2 to reset, $+12 to skip

        ld      iy, (readRow_ch1cnt0)
readRow_ch1pha  equ $+1
        ld      a, 0
        add     a, iyh
        ld      iyh, a

ch1phaseresetskip:

        ld      h, noteTable/256
        ld      c, (hl)
        inc     l
        ld      b, (hl)
        ld      (readRow_ch1add0), bc
readRow_ch1int  equ $+1
        ld      a, 0
        add     a, l
        ld      l, a
        ld      b, (hl)
        dec     l
        ld      c, (hl)
readRow_ch1det  equ $+1
        ld      hl, 0
        add     hl, bc
        ld      (readRow_ch1add1), hl
        ex      de, hl
        exx
readRow_ch1cnt0 equ $+1
        ld      hl, 0
readRow_ch1add1 equ $+1
        ld      de, 0
readRow_ch1add0 equ $+1
        ld      bc, 0
        exx

ch1skip:

        ld      (readRow_pos), hl

        xor     a
        in      a, (keyPort)
        or      $e0
        inc     a
        jp      z, soundInit

stopPlayer:

stopPlayer_oldSP    equ $+1
        ld      sp, 0
        pop     hl
        exx
        pop     iy
        ei
        ret



soundInit:

soundInit_skip  equ $+1
        ld      d, 0                    ;drum length to compensate
soundInit_len   equ $+1
        ld      a, 100                  ;speed
        sub     d
        jp      nc, $+5
        ld      a, 1
        or      a
        jp      nz, $+5
        ld      a, 1
        ld      d, a
        xor     a
        ld      (soundInit_skip), a

soundInit_ch0cnt0   equ $+1
        ld      hl, 0
soundInit_ch0add0   equ $+1
        ld      bc, 200

soundLoopH:

        ld      e, 64                   ;4*64 loop repeats, ~85 hz

soundLoop:

        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     ix, sp                  ;15
soundLoop_opA0  equ $+1
        xor     ixh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volA0 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel0|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4
        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     iy, de                  ;15
soundLoop_opB0  equ $+1
        xor     iyh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volB0 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel2|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4

  IF    !_SMS
        nop                             ;4
        jr      $+2                     ;12=152
  ENDIF

        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     ix, sp                  ;15
soundLoop_opA1  equ $+1
        xor     ixh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volA1 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel0|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4
        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     iy, de                  ;15
soundLoop_opB1  equ $+1
        xor     iyh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volB1 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel2|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4

  IF    !_SMS
        nop                             ;4
        jr      $+2                     ;12=152
  ENDIF

        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     ix, sp                  ;15
soundLoop_opA2  equ $+1
        xor     ixh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volA2 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel0|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4
        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     iy, de                  ;15
soundLoop_opB2  equ $+1
        xor     iyh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volB2 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel2|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4

  IF    !_SMS
        nop                             ;4
        jr      $+2                     ;12=152
  ENDIF

        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     ix, sp                  ;15
soundLoop_opA3  equ $+1
        xor     ixh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volA3 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel0|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4
        add     hl, bc                  ;11
        ld      a, h                    ;4
        add     iy, de                  ;15
soundLoop_opB3  equ $+1
        xor     iyh                     ;8
        rla                             ;4
        sbc     a, a                    ;4
soundLoop_volB3 equ $+1
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel2|PSGVolumeData ;7
  ELSE
        and     16                      ;7
  ENDIF
        out     (PSGDataPort), a        ;11
        exx                             ;4

        dec     e                       ;4
        jp      nz, soundLoop           ;12=152

soundLoop_phaseSlideEnableA equ $+1
        jr      $+2

soundLoop_phaseSlideA0:
soundLoop_phaseSlideDivA    equ $+1
        ld      a, 0
        inc     a
soundLoop_phaseSlideSpeedA  equ $+1
        cp      1
        jr      c, $+3
        xor     a
        ld      (soundLoop_phaseSlideDivA), a
        jr      c, soundLoop_phaseSlideA1

        ld      a, ixh
        cp      h
        jr      z, soundLoop_phaseSlideA1
        inc     h
        ld      a, ixl
        ld      l, a
soundLoop_phaseSlideA1:

soundLoop_phaseSlideEnableB equ $+1
        jr      $+2

soundLoop_phaseSlideB0:
soundLoop_phaseSlideDivB    equ $+1
        ld      a, 0
        inc     a
soundLoop_phaseSlideSpeedB  equ $+1
        cp      1
        jr      c, $+3
        xor     a
        ld      (soundLoop_phaseSlideDivB), a
        jr      c, soundLoop_phaseSlideB2

        exx
        ld      a, iyh
        cp      h
        jr      z, phaseSlideB1
        inc     h
        ld      a, iyl
        ld      l, a
phaseSlideB1:
        exx
soundLoop_phaseSlideB2:

soundLoop_cntA0Slide    equ $
        nop                             ;bc
        nop
        nop
        nop

soundLoop_cntA1Slide    equ $
        nop                             ;sp
        nop
        nop
        nop

        exx

soundLoop_cntB0Slide    equ $
        nop                             ;bc
        nop
        nop
        nop

soundLoop_cntB1Slide    equ $
        nop                             ;de
        nop
        nop
        nop

        exx

        dec     d
        jp      nz, soundLoopH

        ld      (soundInit_ch0cnt0), hl

        jp      readRow



playDrumSample:

        ld      l, a
        ld      h, 0
        add     hl, hl
        add     hl, hl
playDrumSample_drumList equ $+1
        ld      bc, 0
        add     hl, bc

        ld      a, (hl)                 ;length in 256-sample blocks
        ld      b, a
        inc     hl
        inc     hl
        ld      (soundInit_skip), a
        ld      a, (hl)
        inc     hl
        ld      h, (hl)                 ;sample data
        ld      l, a

        ld      a, 1
        ld      (mask), a

        ld      c, 0
loop0:
        ld      a, (hl)                 ;7
mask    equ     $+1
        and     0                       ;7
        sub     1                       ;7
        sbc     a, a                    ;4
  IF    _SMS
        and     PSG_VOL                 ;7
        or      PSGLatch|PSGChannel1|PSGVolumeData ;7
  ELSE
        and     16                      ;7 (out mask) - drums
  ENDIF
        out     (PSGDataPort), a        ;11
        ld      a, (mask)               ;13
        rlc     a                       ;8
        ld      (mask), a               ;13
        jr      nc, $+3                 ;7/12
        inc     hl                      ;6

        dec     hl                      ;6
        inc     hl                      ;6
        dec     hl                      ;6
        inc     hl                      ;6
        dec     hl                      ;6
        inc     hl                      ;6
        ; Remove 12 cycles for SMS to compensate for
        ; 14 cycles added above by XOR & OR
  IF    !_SMS
        dec     hl                      ;6
        inc     hl                      ;6
  ENDIF
        ld      a, 0                    ;7

        dec     c                       ;4
        jr      nz, loop0               ;7/12=105t
        dec     b
        jp      nz, loop0

        jp      readRow


        section rodata_user
        align   256

noteTable:

        dw      $0000, $0000
        dw      $0030, $0033, $0036, $003a, $003d, $0041, $0045, $0049, $004d, $0052, $0057, $005c
        dw      $0061, $0067, $006d, $0074, $007b, $0082, $008a, $0092, $009b, $00a4, $00ae, $00b8
        dw      $00c3, $00cf, $00db, $00e9, $00f6, $0105, $0115, $0125, $0137, $0149, $015d, $0171
        dw      $0187, $019f, $01b7, $01d2, $01ed, $020b, $022a, $024b, $026e, $0293, $02ba, $02e3
        dw      $030f, $033e, $036f, $03a4, $03db, $0416, $0454, $0496, $04dc, $0526, $0574, $05c7
        dw      $061f, $067c, $06df, $0748, $07b7, $082c, $08a8, $092c, $09b8, $0a4c, $0ae9, $0b8f
        dw      $0c3f, $0cf9, $0dbf, $0e90, $0f6e, $1059, $1151, $1259, $1370, $1498, $15d2, $171e
        dw      $187e, $19f3, $1b7e, $1d20, $1edc, $20b2, $22a3, $24b3, $26e1, $2931, $2ba4, $2e3c
        dw      $30fc, $33e6, $36fc, $3a41, $3db8, $4164, $4547, $4966, $4dc3, $5263, $5748, $5c79
        dw      $61f9, $67cc, $6df8, $7483, $7b71, $82c8, $8a8f, $92cc, $9b86, $a4c6, $ae91, $b8f3

        align   256
musicData:
        dw      sequence
        dw      insList
drums:
        dw      2, drum0
        dw      4, drum1
        dw      1, drum2
        dw      12, drum3
        dw      10, drum4
        dw      9, drum5
        dw      11, drum6
        dw      7, drum7
drum0:
        db      0, 0, 0, 0, 0, 0, 0, 8, 126, 127, 255, 255, 255, 255, 143, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 71, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
drum1:
        db      0, 0, 248, 255, 255, 15, 0, 0, 0, 0, 0, 0, 192, 255, 255, 255, 255, 255, 4, 0, 0, 0, 0, 240, 255, 255, 255, 127, 43, 9, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 23, 0, 0, 0, 0, 0, 0, 126, 252, 255, 253, 79, 1, 0, 0, 0, 0, 0, 64, 82, 230, 191, 251, 223, 38, 0, 0, 0, 0, 0, 0, 128, 232, 255, 253, 207, 110, 0, 0, 0, 0, 0, 0, 0, 0, 105, 211, 54, 47, 0, 0, 0, 4, 0, 0, 0, 0, 0, 188, 60, 216, 22, 154, 0, 0, 0, 0, 0, 0, 0, 1, 34, 201, 196, 67, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0
drum2:
        db      132, 2, 170, 132, 82, 85, 42, 160, 16, 10, 41, 0, 2, 84, 2, 5, 4, 0, 128, 0, 130, 96, 4, 40, 0, 80, 8, 84, 128, 0, 4, 0
drum3:
        db      199, 63, 0, 248, 248, 224, 255, 248, 7, 0, 227, 0, 252, 3, 227, 156, 131, 131, 227, 99, 140, 115, 140, 115, 252, 15, 0, 128, 255, 255, 49, 192, 1, 192, 255, 63, 254
        db      255, 255, 7, 0, 0, 0, 0, 0, 231, 248, 255, 255, 255, 31, 31, 227, 3, 0, 156, 3, 28, 128, 255, 255, 255, 255, 143, 243, 129, 129, 113, 0, 14, 192, 49, 240, 255, 241, 7, 254
        db      255, 193, 57, 192, 192, 0, 192, 224, 31, 0, 7, 255, 31, 28, 255, 227, 227, 3, 124, 252, 31, 156, 255, 131, 3, 128, 243, 15, 142, 241, 255, 129, 193, 193, 49, 192, 207
        db      249, 193, 1, 198, 193, 7, 192, 248, 248, 248, 224, 248, 231, 231, 0, 31, 252, 252, 0, 252, 224, 127, 0, 0, 252, 115, 0, 0, 240, 127, 0, 112, 254, 255, 113, 14, 254, 207, 15, 240
        db      193, 63, 248, 1, 198, 7, 56, 255, 56, 56, 248, 31, 224, 7, 31, 255, 31, 0, 255, 99, 28, 252, 131, 255, 3, 128, 243, 115, 128, 127, 240, 15, 128, 255, 49, 0, 192, 63, 240, 63, 248, 63, 62, 6
        db      248, 63, 255, 0, 56, 31, 231, 7, 224, 0, 248, 3, 0, 227, 252, 227, 99, 128, 127, 96, 0, 128, 255, 115, 0, 240, 127, 14, 14, 142, 207, 63, 0, 240, 15, 62, 198, 199, 193, 199, 192, 199, 192, 56, 199
        db      231, 7, 224, 248, 31, 28, 3, 224, 252, 127, 0, 124, 124, 252, 3, 252, 127, 124, 12, 112, 254, 127, 0, 142, 63, 206, 1, 48, 206, 63, 0, 248, 199, 255, 1, 192, 255, 63, 192, 31, 248, 24, 24, 7, 255, 3
        db      252, 0, 252, 128, 31, 128, 127, 0, 140, 243, 15, 128, 15, 254, 15, 142, 129, 255, 207, 15, 192, 255, 193, 57, 192, 199, 249, 1, 192, 7, 255, 0, 24, 224, 248, 224, 231, 0, 255, 224, 28, 224, 28, 224
        db      127, 128, 127, 0, 124, 0, 12, 252, 15, 254, 127, 142, 255, 15, 192, 63
        db      192, 255, 193, 7, 248, 7, 248, 7, 248, 7, 248, 0, 248, 7, 255, 0, 255, 224, 31, 224, 31, 252, 31, 96, 0, 252, 3, 112, 140, 255, 3, 12, 128, 255, 1
drum4:
        db      0, 0, 0, 7, 63, 0, 24, 248, 248, 0, 0, 0, 3, 0, 0, 128, 3, 28, 0, 96, 128, 3, 0, 140, 3, 112, 14, 0
        db      112, 14, 48, 48, 206, 1, 0, 0, 0, 0, 192, 199, 248, 0, 7, 0, 0, 0, 0, 224, 255, 255, 255, 3, 0, 0, 131, 31, 0, 0, 224, 255, 255, 127
        db      0, 0, 128, 255, 255, 129, 143, 15, 14, 0, 192, 255, 255, 63, 0, 0, 0, 248, 255, 63, 248, 192, 0, 0, 0, 248, 255, 255
        db      31, 0, 0, 224, 252, 255, 31, 124, 224, 131, 3, 0, 240, 255, 255, 15, 0, 0, 128, 255, 255, 63, 192, 193
        db      7, 6, 0, 192, 255, 255, 255, 0, 0, 0, 248, 255, 31, 0, 0, 252, 227, 0, 0, 224, 255, 255, 127, 0, 0, 128, 255
        db      255, 3, 0, 254, 255, 15, 0, 0, 240, 255, 255, 63, 0, 0, 0, 254, 255, 63, 192, 255, 255, 0, 0, 0, 255, 255, 255, 7, 0, 0
        db      0, 255, 255, 159, 255, 255, 3, 0, 0, 240, 255, 255, 127, 0, 0, 0, 128, 255, 255, 63, 62, 0, 0, 0, 0, 254, 255, 255, 63
        db      0, 0, 0, 224, 255, 255, 255, 255, 7, 0, 0, 0, 255, 255, 255, 127, 0, 0, 0, 128, 255, 255, 255, 255, 1, 0, 0, 0
        db      254, 255, 255, 63, 0, 0, 0, 0, 254, 255, 255, 63, 0, 0, 0, 0, 255, 255, 255, 255, 0, 0, 0, 0, 252, 255, 255, 255, 3, 0, 0, 0
        db      240, 255, 255, 255, 1, 0, 0, 0, 192, 255, 255, 255, 63, 0, 0, 0, 0, 192, 255, 255, 255, 0, 0, 0, 0, 0, 248, 255
        db      255, 3, 0, 0, 0, 128, 255, 255, 31, 0, 0, 0, 0, 0, 0, 240, 255, 127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
drum5:
        db      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 224, 224, 3, 0, 0, 224, 255, 127, 0, 0, 0, 0, 0, 0, 240, 255, 255
        db      15, 112, 14, 240, 1, 0, 0, 248, 255, 63, 0, 0, 63, 0, 192, 192, 255, 0, 0, 0, 255, 255, 0, 252, 255, 0, 0, 224
        db      255, 31, 252, 255, 3, 0, 252, 255, 3, 240, 255, 1, 0, 240, 63, 0, 254, 207, 63, 0, 0, 0, 254, 255, 0, 255, 63
        db      0, 224, 248, 0, 0, 255, 231, 31, 31, 0, 0, 255, 127, 128, 255, 31, 0, 112, 12, 0, 240, 255
        db      129, 255, 15, 0, 192, 255, 63, 192, 255, 63, 0, 0, 6, 0, 192, 255, 199, 63, 63, 0, 0, 255, 255, 0, 255, 31
        db      0, 0, 31, 0, 224, 255, 131, 255, 127, 0, 128, 255, 127, 128, 255, 127, 0, 0, 62, 0, 192, 255
        db      207, 63, 56, 0, 0, 254, 255, 0, 255, 255, 0, 0, 31, 0, 0, 248, 31, 255, 224, 0, 0, 252, 255, 3, 252, 255
        db      3, 0, 0, 112, 0, 240, 127, 254, 241, 1, 0, 240, 255, 15, 14, 254, 199, 1, 0, 248, 0, 192, 255, 248
        db      231, 7, 0, 224, 255, 31, 28, 252, 255, 3, 0, 0, 0, 128, 255, 243, 15, 12, 0, 128, 255, 255, 113, 240
        db      255, 15, 0, 0, 0, 0, 254, 199, 255, 57, 0, 0, 255, 255, 199, 199, 255, 31, 0, 0, 0, 0, 252, 255, 227, 31
        db      0, 0, 128, 255, 255, 255, 255, 131, 15, 0, 0, 0, 254, 255, 255, 207, 15, 0, 0, 192, 255, 255, 255, 255
        db      199, 7, 0, 0, 192, 231, 31, 255, 224, 0, 0
drum6:
        db      0, 7, 0, 63, 0, 224, 224, 0, 7, 24, 252, 224, 3, 28, 224, 131, 131, 31, 28, 28, 112, 0, 0, 112, 112, 128
        db      1, 128, 143, 15, 254, 193, 15, 14, 48, 192, 199, 255, 249, 63, 0, 192, 7, 192, 192, 31, 0
        db      224, 224, 31, 255, 252, 252, 3, 128, 31, 96, 252, 131, 127, 124, 128, 3, 124, 252, 241, 255, 15
        db      14, 62, 48, 240, 207, 15, 254, 57, 0, 6, 62, 192, 199, 63, 63, 248, 224, 0, 0, 255, 24, 248
        db      227, 0, 28, 252, 131, 159, 127, 96, 128, 131, 3, 0, 252, 243, 131, 15, 14, 240, 129, 15, 62, 254
        db      193, 15, 62, 62, 0, 248, 63, 62, 255, 248, 0, 7, 255, 224, 231, 31, 24, 224, 255, 0, 0, 255
        db      131, 131, 127, 28, 128, 131, 15, 252, 255, 131, 15, 126, 126, 0, 128, 63, 48, 240, 207, 1, 56, 248
        db      193, 255, 255, 248, 192, 7, 7, 0, 248, 31, 7, 255, 248, 0, 3, 31, 252, 255, 255, 31, 224, 227
        db      3, 128, 255, 131, 131, 127, 14, 112, 240, 15, 254, 255, 241, 15, 254, 49, 0, 192, 255, 249, 249
        db      199, 7, 0, 248, 7, 31, 255, 255, 0, 255, 28, 0, 224, 255, 96, 224, 159, 31, 0, 240, 131, 143, 255
        db      255, 1, 240, 1, 0, 112, 254, 193, 63, 254, 49, 0, 192, 255, 255, 255, 255, 63, 0, 0, 0, 0, 224, 255
        db      255, 224, 31, 3, 0, 28, 252, 255, 255, 255, 3, 0, 0, 0, 0, 252, 255, 15, 254, 113, 0, 192, 193, 255
        db      255, 255, 63, 0, 0, 0, 0, 192, 255, 255, 255, 63, 0, 0, 0, 255, 255, 255, 255, 3, 3, 0, 0, 0, 252, 255
        db      255, 131, 15, 0, 0, 112, 254, 255, 255, 255, 15, 0, 0, 0, 0, 254, 255, 255, 7, 0, 0, 0, 0, 199, 255, 255
        db      31, 0, 0, 0, 0, 0, 255, 255, 255, 3, 0, 0, 128, 3, 12, 252, 255, 115, 240, 3, 0, 0, 0, 128, 255, 63, 62, 0, 0, 0
drum7:
        db      199, 199, 199, 192, 0, 0, 0, 0, 224, 224, 255, 255, 31, 31, 3, 0, 0, 0, 0, 0, 128, 243, 243, 255
        db      255, 255, 127, 14, 14, 0, 0, 0, 0, 0, 254, 255, 255, 255, 63, 192, 0, 0, 0, 0, 0, 31, 31, 255, 255, 255
        db      255, 224, 0, 0, 28, 28, 128, 159, 255, 255, 255, 143, 3, 0, 12, 0, 0, 128, 129, 241, 241, 255, 255
        db      63, 62, 6, 6, 0, 192, 193, 255, 255, 255, 255, 255, 255, 224, 224, 0, 0, 0, 0, 224, 255, 255, 255
        db      255, 159, 3, 0, 0, 112, 252, 255, 255, 255, 255, 241, 255, 255, 15, 62, 0, 0, 0, 248, 249, 255
        db      255, 255, 63, 248, 0, 63, 248, 255, 255, 255, 7, 31, 252, 0, 31, 255, 255, 131, 3, 0, 0, 12, 252, 255
        db      255, 255, 1, 0, 0, 14, 254, 193, 255, 255, 255, 255, 255, 255, 1, 0, 0, 0, 7, 255, 255, 255, 31, 224
        db      0, 255, 255, 255, 31, 0, 0, 224, 255, 255, 255, 3, 128, 255, 3, 0, 0, 0, 254, 255, 127, 0, 0, 192, 255
        db      255, 255, 1, 0, 0, 254, 255, 255, 63, 0, 255, 63, 0, 0, 0, 248, 255, 31, 3, 0, 0, 255, 255, 31, 0, 0, 224
        db      255, 255, 255, 3, 240, 255
insList:
        db      0, 64, 1, 172, 240, 0, 0, 0
        db      0, 8, 0, 172, 240, 1, 0, 0
        db      0, 8, 0, 172, 48, 1, 0, 0
        db      0, 64, 1, 172, 240, 0, 139, 139
        db      0, 255, 4, 172, 240, 0, 139, 139
        db      0, 255, 4, 172, 240, 0, 0, 0
        db      0, 255, 4, 172, 240, 0, 0, 0
sequence:
        db      $f5, 4
        db      $f5, 11
        db      246, 128, 23, 128, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 21
        db      246, 0, 0
        db      129, 21, 0
        db      0, 0
        db      247, 128, 28, 16
        db      0, 0
        db      23, 11
        db      247, 26, 14
        db      0, 0
        db      246, 23, 11
        db      0, 0
        db      130, 1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      129, 1, 0
        db      23, 1
        db      23, 11
        db      246, 23, 11
        db      247, 128, 23, 11
        db      28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 21
        db      246, 0, 0
        db      129, 21, 0
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      25, 13
        db      26, 14
        db      246, 23, 11
        db      0, 0
        db      130, 11, 0
        db      1, 0
        db      247, 11, 0
        db      1, 0
        db      11, 0
        db      0, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      23, 11
        db      246, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      $fe
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 131, 21
        db      246, 0, 0
        db      129, 33, 0
        db      0, 0
        db      128, 28, 128, 16
        db      247, 0, 0
        db      23, 11
        db      246, 131, 26, 14
        db      0, 0
        db      246, 128, 23, 11
        db      0, 0
        db      130, 1, 0
        db      1, 0
        db      247, 1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      23, 11
        db      246, 128, 23, 11
        db      28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 21
        db      246, 0, 0
        db      130, 21, 0
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      25, 13
        db      26, 14
        db      247, 23, 11
        db      0, 0
        db      130, 11, 0
        db      1, 0
        db      247, 11, 0
        db      1, 0
        db      11, 0
        db      246, 0, 0
        db      247, 11, 0
        db      129, 23, 1
        db      23, 11
        db      246, 23, 11
        db      247, 128, 23, 131, 59
        db      247, 28, 0
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 128, 11
        db      1, 0
        db      23, 11
        db      9, 129, 21
        db      247, 23, 33
        db      129, 23, 33
        db      9, 33
        db      246, 128, 21, 33
        db      246, 11, 35
        db      129, 33, 128, 21
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      247, 26, 14
        db      0, 0
        db      246, 23, 11
        db      0, 0
        db      130, 1, 0
        db      128, 9, 129, 21
        db      247, 130, 1, 33
        db      128, 9, 33
        db      130, 1, 33
        db      128, 9, 33
        db      246, 129, 1, 35
        db      23, 30
        db      23, 128, 11
        db      246, 23, 129, 35
        db      247, 128, 23, 128, 11
        db      28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      9, 129, 33
        db      247, 23, 33
        db      129, 23, 33
        db      9, 33
        db      128, 9, 33
        db      246, 9, 33
        db      129, 33, 128, 21
        db      0, 0
        db      128, 28, 129, 35
        db      247, 129, 23, 0
        db      23, 128, 11
        db      25, 13
        db      26, 14
        db      246, 23, 11
        db      0, 0
        db      130, 11, 11
        db      1, 129, 33
        db      247, 11, 33
        db      1, 33
        db      11, 33
        db      0, 33
        db      246, 133, 42, 133, 45
        db      129, 23, 128, 11
        db      38, 129, 45
        db      23, 128, 11
        db      247, 38, 130, 45
        db      247, 128, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      249, 23, 11
        db      248, 1, 0
        db      248, 23, 11
        db      248, 9, 129, 21
        db      247, 23, 33
        db      248, 129, 23, 33
        db      248, 9, 33
        db      246, 128, 21, 33
        db      246, 11, 35
        db      248, 129, 33, 128, 21
        db      248, 0, 0
        db      248, 128, 28, 16
        db      247, 0, 0
        db      248, 23, 11
        db      247, 26, 14
        db      248, 0, 0
        db      246, 23, 11
        db      248, 0, 0
        db      248, 130, 1, 0
        db      248, 128, 9, 129, 21
        db      247, 130, 1, 33
        db      248, 128, 9, 33
        db      248, 130, 1, 33
        db      248, 128, 9, 33
        db      246, 129, 1, 35
        db      248, 23, 30
        db      248, 23, 128, 11
        db      246, 128, 16, 129, 35
        db      247, 129, 23, 0
        db      248, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 128, 23, 11
        db      248, 1, 0
        db      248, 23, 11
        db      248, 9, 129, 33
        db      247, 23, 33
        db      248, 129, 23, 33
        db      248, 9, 33
        db      246, 128, 9, 33
        db      246, 9, 33
        db      248, 129, 33, 128, 21
        db      248, 0, 0
        db      248, 128, 28, 129, 35
        db      247, 0, 23
        db      248, 23, 128, 11
        db      248, 25, 13
        db      248, 26, 14
        db      246, 23, 11
        db      248, 0, 0
        db      248, 130, 11, 0
        db      248, 1, 0
        db      247, 11, 0
        db      248, 1, 0
        db      248, 11, 0
        db      248, 0, 0
        db      246, 129, 1, 0
        db      248, 23, 1
        db      248, 23, 11
        db      248, 23, 11
        db      246, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 35
        db      248, 1, 0
        db      248, 23, 133, 33
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      246, 128, 33, 21
        db      246, 0, 132, 35
        db      248, 129, 33, 0
        db      248, 0, 133, 33
        db      248, 128, 28, 0
        db      247, 23, 28
        db      248, 0, 0
        db      247, 26, 131, 26
        db      248, 0, 0
        db      246, 23, 133, 35
        db      248, 0, 0
        db      248, 11, 0
        db      248, 0, 1
        db      247, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      246, 0, 0
        db      248, 129, 23, 1
        db      248, 23, 130, 11
        db      246, 23, 11
        db      247, 128, 23, 11
        db      248, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 47
        db      248, 1, 0
        db      248, 23, 133, 45
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      246, 128, 33, 21
        db      246, 0, 132, 47
        db      248, 129, 33, 0
        db      248, 0, 133, 45
        db      248, 128, 28, 0
        db      247, 35, 128, 40
        db      248, 23, 0
        db      247, 26, 131, 38
        db      248, 0, 0
        db      246, 23, 133, 47
        db      248, 0, 0
        db      248, 11, 130, 23
        db      248, 0, 0
        db      247, 0, 11
        db      248, 0, 1
        db      248, 0, 11
        db      248, 0, 1
        db      246, 0, 11
        db      248, 129, 23, 1
        db      248, 23, 11
        db      246, 23, 11
        db      249, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 35
        db      248, 1, 0
        db      248, 23, 133, 33
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      246, 128, 33, 21
        db      246, 0, 132, 35
        db      248, 129, 33, 0
        db      248, 0, 133, 33
        db      248, 128, 28, 0
        db      247, 23, 28
        db      248, 0, 0
        db      247, 26, 131, 26
        db      248, 0, 0
        db      246, 23, 133, 35
        db      248, 0, 0
        db      248, 11, 0
        db      248, 0, 1
        db      247, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      246, 0, 0
        db      248, 129, 23, 1
        db      248, 23, 130, 11
        db      246, 23, 11
        db      247, 128, 23, 11
        db      248, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 47
        db      248, 1, 0
        db      248, 23, 133, 45
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      248, 128, 33, 21
        db      246, 0, 132, 47
        db      248, 129, 33, 0
        db      248, 0, 133, 45
        db      248, 128, 28, 0
        db      247, 35, 128, 40
        db      248, 23, 0
        db      248, 26, 131, 38
        db      248, 0, 0
        db      247, 23, 132, 47
        db      0, 0
        db      11, 0
        db      0, 0
        db      247, 0, 130, 11
        db      0, 1
        db      0, 11
        db      246, 0, 1
        db      247, 0, 11
        db      129, 23, 1
        db      23, 11
        db      246, 23, 11
        db      247, 128, 1, 131, 59
        db      247, 1, 0
        db      247, 1, 0
        db      247, 0, 0
        db      246, 23, 128, 7
        db      130, 19, 0
        db      128, 23, 0
        db      130, 19, 0
        db      247, 128, 35, 0
        db      129, 35, 0
        db      130, 19, 0
        db      129, 19, 0
        db      246, 130, 19, 0
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      247, 130, 17, 5
        db      17, 0
        db      17, 0
        db      17, 0
        db      246, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 17, 5
        db      1, 0
        db      247, 0, 0
        db      0, 0
        db      246, 133, 42, 133, 45
        db      130, 19, 129, 35
        db      128, 23, 128, 11
        db      129, 38, 129, 45
        db      247, 128, 35, 128, 23
        db      129, 35, 23
        db      38, 130, 45
        db      128, 33, 131, 21
        db      247, 0, 0
        db      129, 33, 0
        db      130, 19, 0
        db      128, 28, 128, 16
        db      247, 0, 0
        db      23, 11
        db      247, 131, 26, 14
        db      247, 0, 0
        db      249, 130, 23, 7
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      247, 130, 19, 0
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      246, 130, 19, 0
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      247, 130, 17, 5
        db      17, 0
        db      17, 0
        db      17, 0
        db      246, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 17, 5
        db      17, 0
        db      247, 17, 0
        db      247, 17, 0
        db      246, 128, 7, 133, 35
        db      0, 130, 23
        db      0, 19
        db      0, 19
        db      247, 0, 19
        db      0, 19
        db      0, 133, 35
        db      0, 130, 23
        db      246, 0, 133, 35
        db      0, 130, 23
        db      0, 19
        db      0, 133, 36
        db      247, 5, 36
        db      0, 131, 36
        db      247, 0, 133, 35
        db      247, 0, 0
        db      246, 7, 33
        db      0, 0
        db      0, 0
        db      0, 0
        db      247, 0, 0
        db      0, 130, 19
        db      0, 19
        db      246, 0, 19
        db      246, 0, 19
        db      0, 19
        db      0, 19
        db      0, 19
        db      247, 5, 128, 33
        db      0, 0
        db      247, 0, 35
        db      0, 0
        db      246, 7, 133, 36
        db      0, 0
        db      0, 0
        db      0, 0
        db      247, 0, 35
        db      0, 0
        db      0, 0
        db      0, 0
        db      246, 0, 33
        db      0, 0
        db      0, 0
        db      0, 0
        db      247, 5, 29
        db      0, 0
        db      247, 0, 131, 29
        db      0, 0
        db      246, 19, 133, 36
        db      129, 19, 0
        db      130, 19, 0
        db      128, 19, 0
        db      247, 129, 19, 35
        db      130, 19, 0
        db      128, 19, 0
        db      129, 19, 0
        db      246, 130, 19, 33
        db      128, 19, 0
        db      134, 19, 0
        db      130, 19, 0
        db      247, 131, 17, 128, 29
        db      0, 0
        db      247, 0, 0
        db      247, 0, 0
        db      246, 130, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 17, 5
        db      129, 17, 0
        db      128, 17, 0
        db      129, 17, 0
        db      246, 130, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      247, 19, 0
        db      19, 0
        db      246, 19, 0
        db      246, 19, 0
        db      247, 131, 17, 17
        db      0, 0
        db      247, 0, 0
        db      0, 0
        db      250, 130, 19, 7
        db      19, 0
        db      19, 0
        db      251, 19, 0
        db      247, 19, 0
        db      19, 0
        db      252, 19, 0
        db      19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      247, 17, 5
        db      17, 0
        db      250, 17, 0
        db      250, 17, 0
        db      250, 19, 7
        db      19, 0
        db      19, 0
        db      251, 19, 0
        db      247, 19, 0
        db      19, 0
        db      252, 19, 0
        db      246, 19, 0
        db      247, 19, 0
        db      19, 0
        db      246, 19, 0
        db      247, 19, 0
        db      249, 17, 5
        db      247, 17, 0
        db      247, 17, 0
        db      247, 17, 0
        db      246, 128, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      246, 128, 33, 21
        db      246, 0, 0
        db      129, 21, 0
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      247, 26, 14
        db      0, 0
        db      246, 23, 11
        db      0, 0
        db      130, 1, 0
        db      1, 0
        db      247, 1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      246, 23, 11
        db      253, 128, 23, 11
        db      28, 16
        db      253, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 21
        db      246, 0, 0
        db      129, 21, 0
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      25, 13
        db      26, 14
        db      246, 23, 11
        db      0, 0
        db      130, 11, 0
        db      1, 0
        db      247, 11, 0
        db      1, 0
        db      11, 0
        db      246, 0, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      23, 11
        db      249, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 131, 21
        db      246, 0, 0
        db      129, 33, 0
        db      0, 0
        db      128, 28, 128, 16
        db      247, 0, 0
        db      23, 11
        db      247, 131, 26, 14
        db      0, 0
        db      246, 128, 23, 11
        db      0, 0
        db      130, 1, 0
        db      1, 0
        db      247, 1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      23, 11
        db      246, 128, 23, 11
        db      28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 21
        db      246, 0, 0
        db      130, 21, 0
        db      0, 0
        db      246, 128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      25, 13
        db      26, 14
        db      247, 23, 11
        db      0, 0
        db      130, 11, 0
        db      1, 0
        db      247, 11, 0
        db      1, 0
        db      11, 0
        db      246, 0, 0
        db      247, 11, 0
        db      129, 23, 1
        db      23, 11
        db      246, 23, 11
        db      247, 128, 23, 131, 59
        db      247, 28, 0
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 128, 11
        db      1, 0
        db      23, 11
        db      9, 129, 21
        db      247, 129, 38, 133, 45
        db      38, 129, 45
        db      9, 45
        db      246, 42, 45
        db      246, 11, 47
        db      33, 128, 21
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      26, 14
        db      0, 0
        db      246, 23, 11
        db      0, 0
        db      130, 1, 0
        db      128, 9, 129, 21
        db      247, 129, 42, 133, 45
        db      128, 9, 129, 45
        db      130, 42, 45
        db      246, 128, 9, 45
        db      246, 1, 47
        db      129, 23, 42
        db      23, 128, 11
        db      246, 23, 129, 35
        db      247, 128, 23, 128, 11
        db      28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      9, 129, 33
        db      247, 129, 42, 133, 45
        db      23, 129, 45
        db      9, 45
        db      246, 133, 42, 45
        db      246, 129, 9, 45
        db      33, 128, 21
        db      0, 0
        db      128, 28, 129, 35
        db      247, 129, 23, 0
        db      23, 128, 11
        db      25, 13
        db      26, 14
        db      246, 23, 11
        db      0, 0
        db      130, 11, 11
        db      128, 9, 129, 21
        db      247, 129, 42, 133, 45
        db      128, 9, 129, 45
        db      130, 42, 45
        db      246, 128, 9, 45
        db      246, 133, 42, 133, 45
        db      129, 23, 128, 11
        db      38, 129, 45
        db      23, 128, 11
        db      247, 38, 130, 45
        db      247, 128, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      249, 23, 11
        db      248, 1, 0
        db      248, 23, 11
        db      248, 9, 129, 21
        db      247, 23, 33
        db      248, 129, 23, 33
        db      248, 9, 33
        db      246, 128, 21, 33
        db      246, 11, 35
        db      248, 129, 33, 128, 21
        db      248, 0, 0
        db      248, 128, 28, 16
        db      247, 0, 0
        db      248, 23, 11
        db      247, 26, 14
        db      248, 0, 0
        db      246, 23, 11
        db      248, 0, 0
        db      248, 130, 1, 0
        db      248, 128, 9, 129, 21
        db      247, 130, 1, 33
        db      248, 128, 9, 33
        db      248, 130, 1, 33
        db      246, 128, 9, 33
        db      246, 129, 1, 35
        db      248, 23, 30
        db      248, 23, 128, 11
        db      246, 128, 16, 129, 35
        db      247, 129, 23, 0
        db      248, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 128, 23, 11
        db      248, 1, 0
        db      248, 23, 11
        db      248, 9, 129, 33
        db      247, 23, 33
        db      248, 129, 23, 33
        db      248, 9, 33
        db      246, 128, 9, 33
        db      246, 9, 33
        db      248, 129, 33, 128, 21
        db      248, 0, 0
        db      248, 128, 28, 129, 35
        db      247, 0, 23
        db      248, 23, 128, 11
        db      247, 25, 13
        db      248, 26, 14
        db      246, 23, 11
        db      248, 0, 0
        db      248, 130, 11, 0
        db      248, 1, 0
        db      247, 11, 0
        db      248, 1, 0
        db      248, 11, 0
        db      246, 0, 0
        db      247, 129, 1, 0
        db      248, 23, 1
        db      247, 23, 11
        db      248, 23, 11
        db      247, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 35
        db      248, 1, 0
        db      248, 23, 133, 33
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      246, 128, 33, 21
        db      246, 0, 132, 35
        db      248, 129, 33, 0
        db      248, 0, 133, 33
        db      248, 128, 28, 0
        db      247, 23, 28
        db      248, 0, 0
        db      247, 26, 131, 26
        db      248, 0, 0
        db      246, 23, 133, 35
        db      248, 0, 0
        db      248, 11, 0
        db      248, 0, 1
        db      247, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      246, 0, 0
        db      248, 129, 23, 1
        db      248, 23, 130, 11
        db      246, 23, 11
        db      247, 128, 23, 11
        db      248, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 47
        db      248, 1, 0
        db      248, 23, 133, 45
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      246, 128, 33, 21
        db      246, 0, 132, 47
        db      248, 129, 33, 0
        db      248, 0, 133, 45
        db      248, 128, 28, 0
        db      247, 35, 128, 40
        db      248, 23, 0
        db      247, 26, 131, 38
        db      248, 0, 0
        db      246, 23, 133, 47
        db      248, 0, 0
        db      248, 11, 130, 23
        db      248, 0, 0
        db      247, 0, 11
        db      248, 0, 1
        db      248, 0, 11
        db      248, 0, 1
        db      246, 0, 11
        db      248, 129, 23, 1
        db      248, 23, 11
        db      246, 23, 11
        db      249, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 35
        db      248, 1, 0
        db      248, 23, 133, 33
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      246, 128, 33, 21
        db      246, 0, 132, 35
        db      248, 129, 33, 0
        db      248, 0, 133, 33
        db      248, 128, 28, 0
        db      247, 23, 28
        db      248, 0, 0
        db      247, 26, 131, 26
        db      248, 0, 0
        db      246, 23, 133, 35
        db      248, 0, 0
        db      248, 11, 0
        db      248, 0, 1
        db      247, 0, 0
        db      248, 0, 0
        db      248, 0, 0
        db      246, 0, 0
        db      246, 0, 0
        db      248, 129, 23, 1
        db      248, 23, 130, 11
        db      246, 23, 11
        db      247, 128, 23, 11
        db      248, 28, 128, 16
        db      247, 0, 0
        db      247, 0, 0
        db      246, 23, 132, 47
        db      248, 1, 0
        db      248, 23, 133, 45
        db      248, 1, 0
        db      247, 35, 128, 11
        db      248, 129, 35, 23
        db      248, 0, 0
        db      248, 128, 33, 21
        db      246, 0, 132, 47
        db      248, 129, 33, 0
        db      248, 0, 133, 45
        db      248, 128, 28, 0
        db      247, 35, 128, 40
        db      248, 23, 0
        db      247, 26, 131, 38
        db      248, 0, 0
        db      247, 23, 132, 47
        db      0, 0
        db      11, 0
        db      0, 0
        db      247, 0, 130, 11
        db      0, 1
        db      0, 11
        db      246, 0, 1
        db      247, 0, 11
        db      129, 23, 1
        db      23, 11
        db      246, 23, 11
        db      247, 128, 1, 131, 59
        db      247, 1, 0
        db      247, 1, 0
        db      247, 0, 0
        db      246, 23, 128, 7
        db      130, 19, 0
        db      128, 23, 0
        db      130, 19, 0
        db      247, 128, 35, 0
        db      129, 35, 0
        db      130, 19, 0
        db      246, 129, 19, 0
        db      246, 130, 19, 0
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      247, 130, 17, 5
        db      17, 0
        db      17, 0
        db      17, 0
        db      246, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 17, 5
        db      1, 0
        db      247, 0, 0
        db      0, 0
        db      250, 133, 42, 133, 45
        db      130, 19, 129, 35
        db      128, 23, 128, 11
        db      251, 129, 38, 129, 45
        db      247, 128, 35, 128, 23
        db      129, 35, 23
        db      252, 38, 130, 45
        db      246, 128, 33, 131, 21
        db      247, 0, 0
        db      129, 33, 0
        db      130, 19, 0
        db      128, 28, 128, 16
        db      247, 0, 0
        db      23, 11
        db      247, 131, 26, 14
        db      247, 0, 0
        db      249, 130, 23, 7
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      247, 130, 19, 0
        db      129, 19, 0
        db      130, 19, 0
        db      246, 129, 19, 0
        db      246, 130, 19, 0
        db      129, 19, 0
        db      130, 19, 0
        db      129, 19, 0
        db      247, 130, 17, 5
        db      17, 0
        db      247, 17, 0
        db      17, 0
        db      246, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 17, 5
        db      247, 17, 0
        db      247, 17, 0
        db      247, 17, 0
        db      246, 128, 7, 133, 35
        db      0, 130, 23
        db      0, 19
        db      0, 19
        db      247, 0, 19
        db      0, 19
        db      0, 133, 35
        db      246, 0, 130, 23
        db      246, 0, 133, 35
        db      0, 130, 23
        db      0, 19
        db      0, 133, 36
        db      247, 5, 36
        db      0, 131, 36
        db      0, 133, 35
        db      0, 0
        db      246, 7, 33
        db      0, 0
        db      0, 0
        db      0, 0
        db      247, 0, 0
        db      0, 130, 19
        db      0, 19
        db      0, 19
        db      246, 0, 19
        db      0, 19
        db      0, 19
        db      0, 19
        db      247, 5, 128, 33
        db      0, 0
        db      247, 0, 35
        db      247, 0, 0
        db      246, 7, 133, 36
        db      0, 0
        db      0, 0
        db      0, 0
        db      247, 0, 35
        db      0, 0
        db      0, 0
        db      0, 0
        db      246, 0, 33
        db      0, 0
        db      0, 0
        db      0, 0
        db      247, 5, 29
        db      0, 0
        db      247, 0, 131, 29
        db      0, 0
        db      246, 19, 133, 36
        db      129, 19, 0
        db      130, 19, 0
        db      128, 19, 0
        db      247, 129, 19, 35
        db      130, 19, 0
        db      128, 19, 0
        db      246, 129, 19, 0
        db      246, 130, 19, 33
        db      128, 19, 0
        db      134, 19, 0
        db      130, 19, 0
        db      247, 131, 17, 128, 29
        db      0, 0
        db      0, 0
        db      0, 0
        db      246, 130, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      249, 17, 5
        db      247, 17, 0
        db      247, 17, 0
        db      247, 17, 0
        db      246, 19, 7
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      247, 131, 17, 17
        db      0, 0
        db      247, 0, 0
        db      0, 0
        db      250, 130, 19, 7
        db      19, 0
        db      19, 0
        db      251, 19, 0
        db      247, 19, 0
        db      19, 0
        db      252, 19, 0
        db      19, 0
        db      246, 19, 0
        db      19, 0
        db      19, 0
        db      19, 0
        db      247, 17, 5
        db      17, 0
        db      250, 17, 0
        db      250, 17, 0
        db      250, 19, 7
        db      19, 0
        db      19, 0
        db      251, 19, 0
        db      19, 0
        db      19, 0
        db      252, 19, 0
        db      246, 19, 0
        db      247, 19, 0
        db      19, 0
        db      19, 0
        db      246, 19, 0
        db      249, 17, 5
        db      247, 17, 0
        db      247, 17, 0
        db      247, 17, 0
        db      246, 128, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      246, 128, 33, 21
        db      246, 0, 0
        db      129, 21, 0
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      247, 26, 14
        db      0, 0
        db      246, 23, 11
        db      0, 0
        db      130, 1, 0
        db      1, 0
        db      247, 1, 0
        db      1, 0
        db      1, 0
        db      1, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      246, 23, 11
        db      253, 128, 23, 11
        db      28, 16
        db      253, 0, 0
        db      247, 0, 0
        db      246, 23, 11
        db      1, 0
        db      23, 11
        db      1, 0
        db      247, 35, 23
        db      129, 35, 23
        db      0, 0
        db      128, 33, 21
        db      246, 0, 0
        db      129, 21, 0
        db      0, 0
        db      128, 28, 16
        db      247, 0, 0
        db      23, 11
        db      247, 25, 13
        db      26, 14
        db      246, 23, 11
        db      0, 0
        db      130, 11, 0
        db      1, 0
        db      247, 11, 0
        db      1, 0
        db      11, 0
        db      0, 0
        db      246, 129, 1, 0
        db      23, 1
        db      23, 11
        db      246, 23, 11
        db      249, 128, 23, 11
        db      247, 28, 16
        db      247, 0, 0
        db      247, 0, 0
        db      $ff
