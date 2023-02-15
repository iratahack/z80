
        public  _main

_main:
        ld      de, evillaughend-evillaugh
                                        ; Length
        ld      hl, evillaugh
        ld      a, 2                    ; 0/1/2 = 1/2/4 bits per sample
        ld      b, 70                   ; delay
        call    ChibiWave
        ret

ChibiWave:
        push    hl
        ld      c, 8                    ;1 Bit settings
        ld      hl, Do1BitWav
        or      a
        jr      z, ChibiWaveBitSet
        ld      c, 4                    ;2 Bit settings
        ld      hl, Do2BitWav
        dec     a
        jr      z, ChibiWaveBitSet
        ld      c, 2                    ;4 Bit settings
        ld      hl, Do4BitWav
ChibiWaveBitSet:
        ;Selfmod the settings in for the settings
        ld      (PlayWaveCallSelfMod_Plus2-2), hl
        pop     hl
        ld      a, c
        ld      (PlayWaveBitdepthSelfMod_Plus1-1), a
        ld      a, b
        ld      (PlayWaveRateSelfMod_Plus1-1), a

        ld      ixh, d                  ;Move Length into IX
        ld      ixl, e

        di
        ld      a, 7                    ;Mixer  --NNNTTT (1=off) --CBACBA
        ld      c, %00111111
        call    AYRegWrite

        ld      c, 0
        ld      a, 2                    ;TTTTTTTT Tone Lower 8 bits A
        call    AYRegWrite

        ld      c, %00000000
        ld      a, 3                    ;----TTTT Tone Upper 4 bits+
        call    AYRegWrite

        ld      c, 0
        ld      a, 9                    ;4-bit Volume / 2-bit Envelope Select for channel A ---EVVVV
        call    AYRegWrite

    ; Sending a value

Waveagain:
        ld      d, (hl)                 ;Load in sample
        ld      e, 2                    ;Samples per byte
PlayWaveBitdepthSelfMod_Plus1:
WaveNextBit:
        xor     a                       ;Shift first bit into D
        rl      d
        rla

        call    Do4BitWav               ;Call correct wave function
PlayWaveCallSelfMod_Plus2:              ;This is Self-Modified depending
                                    ;on bit depth

        ld      b, 1                    ;WaveDelay
PlayWaveRateSelfMod_Plus1:
Wavedelay:                              ;Wait for next sample
        djnz    Wavedelay

        dec     e
        jr      nz, WaveNextBit         ;Process any remaining bits
        inc     hl

        dec     ix
        ld      a, ixh
        or      ixl
        jr      nz, Waveagain           ;Repeat until there are no more bytes

        ld      c, 0
        ld      a, 9
        jp      AYRegWriteQuick         ;Turn off sound
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Do4BitWav:
        rl      d                       ;Shift 4 bits in
        rla
        rl      d
        rla
        rl      d
        rla
        jr      Do1BitWavc
Do2BitWav:
        rl      d                       ;Shift 2 bits in
        rla
        jr      Do1BitWavb
Do1BitWav:
        rlca                            ;Move bits into correct pos
Do1BitWavb:
        rlca
        rlca
Do1BitWavc:
        ld      c, a
        ld      a, 9
        jp      AYRegWriteQuick         ;Send the new volume level


AYRegWrite:
        push    bc
        ld      bc, $FFFD
        out     (c), a                  ;Regnum
        pop     bc
AYRegWriteQuick:
        ld      a, c
        ld      bc, $BFFD
        out     (c), a                  ;Value
        ret

evillaugh:
        binary  "evillaugh4-8.raw"
evillaughend:
