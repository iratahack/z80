;
; All of the following code and data is disposeable. Meaning it is only used once.
; To save memory the code is stored in the level buffer and the data
; is stored in the heap of bank 2. Once the title screen has been displayed
; this memory is reused.
;

        public  _titleMusic

        defc    AQ_PLUS=1

  IFDEF AQ_PLUS
        defc    keyPort=$ff
        defc    PSGDataPort=$ec
        defc    VOLUME_ENABLE=$80
  ELSE
        defc    keyPort=$fe
        defc    PSGDataPort=$fe
        defc    VOLUME_ENABLE=$10
  ENDIF

        ;
        ; Code in this module is self modifying.
        ; For this reason it must be executed from RAM.
        ; It is placed in the data_user section and the
        ; CRT code copies it from ROM to RAM during boot.
        ;

        section CODE_0

; *****************************************************************************
; * Phaser1 Engine, With Digital Drum Samples
; *
; * Original code by Shiru - http://shiru.untergrund.net/
; * Modified by Chris Cowley
; *
; * Produced by Beepola v1.08.01
; ******************************************************************************
_titleMusic:
START:
        LD      HL, MUSICDATA           ;  <- Pointer to Music Data. Change
                                        ;     this to play a different song
        LD      A, (HL)                 ; Get the loop start pointer
        LD      (PATTERN_LOOP_BEGIN), A
        INC     HL
        LD      A, (HL)                 ; Get the song end pointer
        LD      (PATTERN_LOOP_END), A
        INC     HL
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
        INC     HL
        LD      (INSTRUM_TBL), HL
        LD      (CURRENT_INST), HL
        ADD     HL, DE
        LD      (PATTERN_ADDR), HL
        XOR     A
        LD      (PATTERN_PTR), A        ; Set the pattern pointer to zero
        LD      H, A
        LD      L, A
        LD      (NOTE_PTR), HL          ; Set the note offset (within this pattern) to 0

PLAYER:
        DI
        PUSH    IY
  IFDEF AQ_PLUS
        xor     a
  ELSE
        LD      A, BORDER_COL
  ENDIF
        LD      H, $00
        LD      L, A
        LD      (CNT_1A), HL
        LD      (CNT_1B), HL
        LD      (DIV_1A), HL
        LD      (DIV_1B), HL
        LD      (CNT_2), HL
        LD      (DIV_2), HL
        LD      (OUT_1), A
        LD      (OUT_2), A
        JR      MAIN_LOOP

; ********************************************************************************************************
; * NEXT_PATTERN
; *
; * Select the next pattern in sequence (and handle looping if we've reached PATTERN_LOOP_END
; * Execution falls through to PLAYNOTE to play the first note from our next pattern
; ********************************************************************************************************
NEXT_PATTERN:
        LD      A, (PATTERN_PTR)
        INC     A
        INC     A
        DEFB    $FE                     ; CP n
PATTERN_LOOP_END:
        DEFB    0
        JR      NZ, NO_PATTERN_LOOP
                          ; Handle Pattern Looping at and of song
        DEFB    $3E                     ; LD A,n
PATTERN_LOOP_BEGIN:
        DEFB    0
        JP      EXIT_PLAYER
NO_PATTERN_LOOP:
        LD      (PATTERN_PTR), A
        LD      HL, $0000
        LD      (NOTE_PTR), HL          ; Start of pattern (NOTE_PTR = 0)

MAIN_LOOP:
        LD      IYL, 0                  ; Set channel = 0

READ_LOOP:
        LD      HL, (PATTERN_ADDR)
        LD      A, (PATTERN_PTR)
        LD      E, A
        LD      D, 0
        ADD     HL, DE
        LD      E, (HL)
        INC     HL
        LD      D, (HL)                 ; Now DE = Start of Pattern data
        LD      HL, (NOTE_PTR)
        INC     HL                      ; Increment the note pointer and...
        LD      (NOTE_PTR), HL          ; ..store it
        DEC     HL
        ADD     HL, DE                  ; Now HL = address of note data
        LD      A, (HL)
        OR      A
        JR      Z, NEXT_PATTERN         ; select next pattern

        BIT     7, A
        JP      Z, RENDER               ; Play the currently defined note(S) and drum
        LD      IYH, A
        AND     $3F
        CP      $3C
        JP      NC, OTHER               ; Other parameters
        ADD     A, A
        LD      B, 0
        LD      C, A
        LD      HL, FREQ_TABLE
        ADD     HL, BC
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
        LD      A, IYL                  ; IYL = 0 for channel 1, or = 1 for channel 2
        OR      A
        JR      NZ, SET_NOTE2
        LD      (DIV_1A), DE
        EX      DE, HL

        DEFB    $DD, $21                ; LD IX,nn
CURRENT_INST:
        DEFW    $0000

        LD      A, (IX+$00)
        OR      A
        JR      Z, L809B                ; Original code jumps into byte 2 of the DJNZ (invalid opcode FD)
        LD      B, A
L8098:  ADD     HL, HL
        DJNZ    L8098
L809B:  LD      E, (IX+$01)
        LD      D, (IX+$02)
        ADD     HL, DE
        LD      (DIV_1B), HL
        LD      IYL, 1                  ; Set channel = 1
        LD      A, IYH
        AND     $40
        JR      Z, READ_LOOP            ; No phase reset

        LD      HL, OUT_1               ; Reset phaser
  IFDEF AQ_PLUS
        RES     7, (HL)
  ELSE
        RES     4, (HL)
  ENDIF
        LD      HL, $0000
        LD      (CNT_1A), HL
        LD      H, (IX+$03)
        LD      (CNT_1B), HL
        JR      READ_LOOP

SET_NOTE2:
        LD      (DIV_2), DE
        LD      A, IYH
        LD      HL, OUT_2
  IFDEF AQ_PLUS
        RES     7, (HL)
  ELSE
        RES     4, (HL)
  ENDIF
        LD      HL, $0000
        LD      (CNT_2), HL
        JP      READ_LOOP

SET_STOP:
        LD      HL, $0000
        LD      A, IYL
        OR      A
        JR      NZ, SET_STOP2
             ; Stop channel 1 note
        LD      (DIV_1A), HL
        LD      (DIV_1B), HL
        LD      HL, OUT_1
  IFDEF AQ_PLUS
        RES     7, (HL)
  ELSE
        RES     4, (HL)
  ENDIF
        LD      IYL, 1
        JP      READ_LOOP
SET_STOP2:
             ; Stop channel 2 note
        LD      (DIV_2), HL
        LD      HL, OUT_2
  IFDEF AQ_PLUS
        RES     7, (HL)
  ELSE
        RES     4, (HL)
  ENDIF
        JP      READ_LOOP

OTHER:  CP      $3C
        JR      Z, SET_STOP             ; Stop note
        CP      $3E
        JR      Z, SKIP_CH1             ; No changes to channel 1
        INC     HL                      ; Instrument change
        LD      L, (HL)
        LD      H, $00
        ADD     HL, HL
        LD      DE, (NOTE_PTR)
        INC     DE
        LD      (NOTE_PTR), DE          ; Increment the note pointer

        DEFB    $01                     ; LD BC,nn
INSTRUM_TBL:
        DEFW    $0000

        ADD     HL, BC
        LD      (CURRENT_INST), HL
        JP      READ_LOOP

SKIP_CH1:
        LD      IYL, $01
        JP      READ_LOOP

EXIT_PLAYER:
  IFDEF AQ_PLUS
        xor     a
  ELSE
        LD      A, MIC_OUTPUT|BORDER_COL
  ENDIF
        OUT     (PSGDataPort), A
        EXX
        POP     IY
        EI
        RET

RENDER:
        AND     $7F                     ; L813A
        CP      $76
        JP      NC, DRUM_TYPE_1
        LD      D, A
        EXX
        DEFB    $21                     ; LD HL,nn
CNT_1A: DEFW    $0000
        DEFB    $DD, $21                ; LD IX,nn
CNT_1B: DEFW    $0000
        DEFB    $01                     ; LD BC,nn
DIV_1A: DEFW    $0000
        DEFB    $11                     ; LD DE,nn
DIV_1B: DEFW    $0000
        DEFB    $3E                     ; LD A,n
OUT_1:  DEFB    $0
        EXX
        EX      AF, AF'
        DEFB    $21                     ; LD HL,nn
CNT_2:  DEFW    $0000
        DEFB    $01                     ; LD BC,nn
DIV_2:  DEFW    $0000
        DEFB    $3E                     ; LD A,n
OUT_2:  DEFB    $00

PLAY_NOTE:
             ; Read keyboard
        LD      E, A                    ;4

        XOR     A                       ;4
        IN      A, (keyPort)            ;13
  IFDEF AQ_PLUS
        OR      $00                     ;7
  ELSE
        OR      $E0                     ;7
  ENDIF
        INC     A                       ;4
PLAYER_WAIT_KEY:
        JR      NZ, EXIT_PLAYER         ;7/12
        LD      A, E                    ;4
        LD      E, 0                    ;7=50

soundLoop:
        EXX                             ;4
        EX      AF, AF'                 ;4
        ADD     HL, BC                  ;11
        out     (PSGDataPort), a        ;11
        JP      C, L8171                ;10
        JP      L8173                   ;10
L8171:
        XOR     VOLUME_ENABLE           ;7
L8173:  ADD     IX, DE                  ;15
        JP      C, L8179                ;10
        JP      L817B                   ;10
L8179:
        XOR     VOLUME_ENABLE           ;7
L817B:  EX      AF, AF'                 ;4
        out     (PSGDataPort), a        ;11
        EXX                             ;4
        ADD     HL, BC                  ;11
        JP      C, L8184                ;10
        JP      L8186                   ;10
L8184:
        XOR     VOLUME_ENABLE           ;7
L8186:  NOP                             ;4
        JP      L818A                   ;10=170




L818A:  EXX                             ;4
        EX      AF, AF'                 ;4
        ADD     HL, BC                  ;11
        out     (PSGDataPort), a        ;11
        JP      C, L8193                ;10
        JP      L8195                   ;10
L8193:
        XOR     VOLUME_ENABLE           ;7
L8195:  ADD     IX, DE                  ;15
        JP      C, L819B                ;10
        JP      L819D                   ;10
L819B:
        XOR     VOLUME_ENABLE           ;7
L819D:  EX      AF, AF'                 ;4
        out     (PSGDataPort), a        ;11
        EXX                             ;4
        ADD     HL, BC                  ;11
        JP      C, L81A6                ;10
        JP      L81A8                   ;10
L81A6:
        XOR     VOLUME_ENABLE           ;7
L81A8:  NOP                             ;4
        JP      L81AC                   ;10=170




L81AC:  EXX                             ;4
        EX      AF, AF'                 ;4
        ADD     HL, BC                  ;11
        out     (PSGDataPort), a        ;11
        JP      C, L81B5                ;10
        JP      L81B7                   ;10
L81B5:
        XOR     VOLUME_ENABLE           ;7
L81B7:  ADD     IX, DE                  ;11
        JP      C, L81BD                ;10
        JP      L81BF                   ;10
L81BD:
        XOR     VOLUME_ENABLE           ;7
L81BF:  EX      AF, AF'                 ;4
        out     (PSGDataPort), a        ;11
        EXX                             ;4
        ADD     HL, BC                  ;11
        JP      C, L81C8                ;10
        JP      L81CA                   ;10
L81C8:
        XOR     VOLUME_ENABLE           ;7
L81CA:  NOP                             ;4
        JP      L81CE                   ;10=170




L81CE:  EXX                             ;4
        EX      AF, AF'                 ;4
        ADD     HL, BC                  ;11
        out     (PSGDataPort), a        ;11
        JP      C, L81D7                ;10
        JP      L81D9                   ;10
L81D7:
        XOR     VOLUME_ENABLE           ;7
L81D9:  ADD     IX, DE                  ;11
        JP      C, L81DF                ;10
        JP      L81E1                   ;10
L81DF:
        XOR     VOLUME_ENABLE           ;7
L81E1:  EX      AF, AF'                 ;4
        out     (PSGDataPort), a        ;11
        EXX                             ;4
        ADD     HL, BC                  ;11
        JP      C, L81EA                ;10
        JP      L81EC                   ;10
L81EA:
        XOR     VOLUME_ENABLE           ;7
L81EC:  DEC     E                       ;4
        JP      NZ, soundLoop           ;10=170

        EXX                             ;4
        EX      AF, AF'                 ;4
        ADD     HL, BC                  ;11
        out     (PSGDataPort), a        ;11
        JP      C, L81F9                ;10
        JP      L81FB                   ;10
L81F9:
        XOR     VOLUME_ENABLE           ;7
L81FB:  ADD     IX, DE                  ;11
        JP      C, L8201                ;10
        JP      L8203                   ;10
L8201:
        XOR     VOLUME_ENABLE           ;7
L8203:  EX      AF, AF'                 ;4
        out     (PSGDataPort), a        ;11
        EXX                             ;4
        ADD     HL, BC                  ;11
        JP      C, L820C                ;10
        JP      L820E                   ;10
L820C:
        XOR     VOLUME_ENABLE           ;7
L820E:  DEC     D                       ;4
        JP      NZ, PLAY_NOTE           ;10=170

        LD      (CNT_2), HL             ;16
        LD      (OUT_2), A              ;13
        EXX                             ;4
        EX      AF, AF'                 ;4
        LD      (CNT_1A), HL            ;16
        LD      (CNT_1B), IX            ;20
        LD      (OUT_1), A              ;13
        JP      MAIN_LOOP               ;10=96

; ************************************************************
; * DRUM type 1 - Digital
; ************************************************************
DRUM_TYPE_1:
        SUB     $74                     ; On entry A=$75+Drum number (i.e. $76 to $7D), this makes it $02 to $09
        LD      B, A
        LD      A, $80
L822C:  RLA                             ;
        DJNZ    L822C                   ; Rotates the drum number, giving us the appropriately-set bit in A

DRUM_DIGITAL:
        LD      (DRUM_SAMPLE), A
  IFDEF AQ_PLUS
        ld      a, $00
  ELSE
        LD      A, BORDER_COL
  ENDIF
        LD      D, A
        LD      HL, SAMPLE_DATA
        LD      BC, 1024                ; Drums are all 1024 samples long, and striped into a byte
NEXT_SAMPLE:
        LD      A, (HL)

        DEFB    $E6                     ; AND n
DRUM_SAMPLE:
        DEFB    $08

        LD      A, D                    ; Put border colour bits into A
        JR      NZ, L8247               ; Sample bit set
        JR      Z, L8249                ; Sample bit not set
L8247:
        OR      VOLUME_ENABLE
L8249:
        out     (PSGDataPort), a
        LD      E, $04
L824D:  DEC     E
        JR      NZ, L824D
        INC     HL
        DEC     BC
        LD      A, B
        OR      C
        JR      NZ, NEXT_SAMPLE
        JP      MAIN_LOOP

        section BSS_0
PATTERN_ADDR:
        DEFW    $0000
PATTERN_PTR:
        DEFB    0
NOTE_PTR:
        DEFW    $0000

        section RODATA_0

PSG_REG_SEC:
        db      $00
        db      $00
        db      $00
        db      $00
        db      $00
        db      $00
        db      $00
        db      $3e
        db      $00
        db      $00
        db      $00
        db      $00
        db      $00
        db      $00
        db      $ff
        db      $ff

; **************************************************************
; * Frequency Table
; **************************************************************
FREQ_TABLE:
  IF    1
        DEFW    178, 189, 200, 212, 225, 238, 252, 267, 283, 300, 318, 337
                                        ; Octave 1
        DEFW    357, 378, 401, 425, 450, 477, 505, 535, 567, 601, 637, 675
                                        ; Octave 2
        DEFW    715, 757, 802, 850, 901, 954, 1011, 1071, 1135, 1202, 1274, 1350
                                        ; Octave 3
        DEFW    1430, 1515, 1605, 1701, 1802, 1909, 2023, 2143, 2270, 2405, 2548, 2700
                                        ; Octave 4
        DEFW    2860, 3030, 3211, 3402, 3604, 3818, 4046, 4286, 4541, 4811, 5097, 5400
                                        ; Octave 5
  ELSE
        ; Calculated based on 170 cycle sound loop and CPU @ 3546893Hz
        dw      205, 218, 231, 244, 259, 274, 291, 308, 326, 346, 366, 388
                                        ;1
        dw      411, 435, 461, 489, 518, 548, 581, 616, 652, 691, 732, 776
                                        ;2
        dw      822, 871, 922, 977, 1035, 1097, 1162, 1231, 1305, 1382, 1464, 1551
                                        ;3
        dw      1644, 1741, 1845, 1955, 2071, 2194, 2324, 2463, 2609, 2764, 2929, 3103
                                        ;4
        dw      3287, 3483, 3690, 3909, 4142, 4388, 4649, 4925, 5218, 5528, 5857, 6205
                                        ;5
  ENDIF

; *****************************************************************
; * Digital Drum Samples - 8 * 1024bit samples, striped into bytes
; *****************************************************************
SAMPLE_DATA:
        DEFB    $02, $02, $02, $02, $00, $00, $02, $00, $0E, $00, $00, $00, $00, $00, $00, $00
        DEFB    $0C, $00, $00, $00, $08, $10, $10, $10, $18, $70, $70, $70, $70, $70, $70, $70
        DEFB    $74, $70, $50, $50, $D8, $D0, $D0, $D0, $D4, $D0, $D0, $D0, $D0, $D0, $D0, $D0
        DEFB    $D4, $D1, $D1, $D1, $5D, $41, $41, $41, $41, $41, $41, $41, $4D, $41, $41, $41
        DEFB    $49, $41, $41, $41, $47, $41, $41, $60, $6C, $22, $20, $20, $2E, $22, $20, $20
        DEFB    $22, $22, $22, $22, $26, $32, $32, $32, $36, $32, $32, $32, $36, $B2, $B2, $B2
        DEFB    $B2, $B2, $32, $32, $3E, $32, $32, $B2, $B2, $B2, $B2, $B2, $BE, $12, $12, $11
        DEFB    $17, $13, $93, $93, $97, $83, $83, $C3, $CB, $C3, $C3, $C3, $CB, $C3, $C1, $C1
        DEFB    $C9, $C1, $C1, $C1, $C5, $C1, $C1, $C1, $41, $41, $41, $41, $4D, $41, $41, $41
        DEFB    $41, $40, $40, $40, $6C, $60, $70, $70, $78, $70, $70, $70, $7C, $70, $70, $70
        DEFB    $74, $70, $70, $70, $70, $70, $70, $70, $34, $30, $30, $30, $38, $30, $30, $30
        DEFB    $38, $30, $30, $B0, $B8, $B0, $B0, $B0, $A4, $A0, $A0, $A0, $84, $80, $80, $80
        DEFB    $8C, $80, $80, $80, $8C, $82, $82, $82, $8C, $80, $82, $82, $8E, $83, $81, $83
        DEFB    $8F, $83, $83, $83, $87, $83, $83, $83, $87, $D3, $D3, $D3, $D7, $D3, $D3, $53
        DEFB    $53, $53, $73, $73, $77, $73, $73, $73, $7B, $73, $73, $73, $73, $73, $73, $73
        DEFB    $73, $73, $73, $73, $77, $73, $73, $73, $7D, $73, $73, $71, $6D, $61, $60, $60
        DEFB    $6C, $62, $62, $62, $62, $60, $60, $60, $64, $60, $60, $20, $00, $00, $00, $00
        DEFB    $08, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $04, $00, $90, $90
        DEFB    $1C, $10, $10, $10, $90, $90, $90, $90, $18, $10, $10, $10, $90, $90, $90, $10
        DEFB    $1C, $10, $10, $10, $1C, $30, $30, $30, $34, $B0, $B0, $B0, $34, $30, $F0, $F0
        DEFB    $F4, $F0, $E0, $E0, $E4, $E0, $E0, $60, $68, $E0, $E0, $E0, $E0, $E2, $E2, $E2
        DEFB    $E6, $E0, $E2, $E0, $E6, $E3, $E3, $E3, $E3, $61, $63, $E3, $E7, $E3, $43, $43
        DEFB    $4F, $41, $41, $41, $43, $53, $53, $53, $57, $53, $53, $53, $57, $53, $53, $53
        DEFB    $13, $13, $13, $13, $17, $13, $13, $13, $1B, $13, $13, $11, $19, $13, $13, $11
        DEFB    $11, $11, $13, $11, $11, $11, $11, $13, $1B, $33, $33, $A1, $A3, $A1, $A1, $A1
        DEFB    $21, $21, $A1, $A1, $A9, $A0, $A0, $A0, $A0, $A0, $20, $20, $28, $20, $A0, $A0
        DEFB    $A0, $20, $20, $A0, $E0, $E0, $60, $E0, $E0, $E0, $E0, $E0, $E8, $60, $60, $70
        DEFB    $78, $F0, $F0, $F0, $D8, $50, $50, $50, $58, $50, $50, $50, $50, $50, $50, $50
        DEFB    $50, $50, $50, $50, $58, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50
        DEFB    $5C, $50, $50, $50, $54, $40, $42, $40, $00, $02, $00, $00, $00, $00, $20, $20
        DEFB    $20, $22, $22, $22, $22, $22, $20, $22, $2A, $20, $22, $22, $22, $20, $22, $22
        DEFB    $26, $22, $20, $22, $26, $22, $20, $22, $22, $22, $A2, $B2, $B8, $B0, $B0, $B2
        DEFB    $B2, $B2, $B2, $32, $32, $B2, $B0, $B2, $B0, $B0, $32, $90, $90, $92, $52, $51
        DEFB    $51, $51, $D1, $D1, $D9, $D1, $51, $51, $51, $51, $53, $D1, $D9, $51, $51, $D3
        DEFB    $D3, $51, $41, $C1, $C1, $C1, $C1, $C1, $C9, $C1, $C1, $C1, $41, $41, $C1, $C1
        DEFB    $C9, $C1, $C1, $41, $C9, $C1, $C1, $61, $69, $E1, $E1, $E1, $61, $61, $61, $61
        DEFB    $61, $61, $61, $61, $29, $21, $21, $21, $25, $31, $31, $31, $35, $31, $31, $31
        DEFB    $39, $B1, $B1, $31, $31, $31, $31, $31, $31, $B1, $32, $30, $B0, $B0, $30, $30
        DEFB    $34, $30, $32, $32, $14, $10, $10, $10, $10, $10, $10, $10, $10, $90, $92, $12
        DEFB    $10, $92, $82, $02, $00, $00, $00, $02, $8A, $02, $02, $02, $CE, $40, $40, $40
        DEFB    $40, $42, $40, $42, $4A, $C2, $C2, $42, $40, $40, $40, $40, $48, $C2, $42, $42
        DEFB    $48, $40, $60, $60, $EA, $62, $62, $E2, $EA, $60, $70, $70, $70, $70, $F0, $F0
        DEFB    $70, $70, $72, $70, $7A, $72, $70, $70, $F0, $F0, $70, $F0, $F0, $70, $70, $F0
        DEFB    $F2, $70, $F0, $B0, $3C, $30, $30, $30, $34, $30, $30, $30, $30, $B0, $B0, $30
        DEFB    $B0, $90, $10, $00, $00, $00, $00, $80, $82, $02, $00, $00, $00, $00, $00, $00
        DEFB    $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        DEFB    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50
        DEFB    $58, $72, $70, $70, $70, $70, $70, $70, $70, $70, $70, $72, $7A, $72, $72, $70
        DEFB    $F8, $F0, $F0, $F2, $7A, $70, $70, $70, $F0, $F0, $F0, $70, $70, $70, $72, $F2
        DEFB    $F0, $70, $70, $F2, $F2, $F0, $F0, $E0, $E8, $E2, $60, $60, $E0, $E0, $E2, $E2
        DEFB    $EA, $C0, $C2, $C2, $C2, $42, $00, $82, $82, $82, $80, $82, $80, $80, $80, $80
        DEFB    $80, $80, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        DEFB    $08, $00, $10, $10, $10, $10, $10, $10, $18, $10, $10, $10, $12, $10, $10, $10
        DEFB    $10, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $70
        DEFB    $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $70, $60, $60
        DEFB    $60, $60, $60, $60, $60, $60, $60, $60, $68, $60, $60, $60, $60, $60, $60, $60
        DEFB    $68, $60, $60, $C0, $C8, $C0, $C0, $C0, $C0, $40, $40, $40, $40, $C0, $C0, $40
        DEFB    $40, $42, $40, $C2, $C8, $C0, $40, $42, $C2, $C2, $10, $10, $98, $90, $92, $92
        DEFB    $12, $12, $10, $10, $10, $10, $10, $10, $9A, $92, $90, $90, $98, $90, $90, $90
        DEFB    $12, $12, $92, $90, $B0, $B0, $30, $30, $38, $30, $30, $30, $38, $30, $30, $30
        DEFB    $3A, $30, $32, $30, $30, $30, $20, $22, $20, $A0, $A0, $20, $28, $A0, $A2, $A2
        DEFB    $A0, $20, $20, $20, $20, $60, $60, $60, $60, $60, $62, $60, $68, $E0, $E0, $E0
        DEFB    $E0, $E0, $60, $60, $60, $60, $E0, $E0, $40, $40, $40, $40, $40, $40, $40, $40
        DEFB    $48, $40, $40, $40, $58, $50, $50, $50, $58, $50, $D0, $D0, $50, $50, $50, $50

        #include    "titletune.inc"
