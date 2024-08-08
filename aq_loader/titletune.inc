MUSICDATA:
        DEFB    6                       ; Pattern loop begin * 2
        DEFB    102                     ; Song length * 2
        DEFW    20                      ; Offset to start of song (length of instrument table)
        DEFB    0                       ; Multiple
        DEFW    4                       ; Detune
        DEFB    32                      ; Phase
        DEFB    0                       ; Multiple
        DEFW    1                       ; Detune
        DEFB    8                       ; Phase
        DEFB    1                       ; Multiple
        DEFW    1                       ; Detune
        DEFB    8                       ; Phase
        DEFB    0                       ; Multiple
        DEFW    1                       ; Detune
        DEFB    32                      ; Phase
        DEFB    0                       ; Multiple
        DEFW    2                       ; Detune
        DEFB    32                      ; Phase

PATTERNDATA:
        DEFW    PAT33
        DEFW    PAT1
        DEFW    PAT2
        DEFW    PAT3
        DEFW    PAT4
        DEFW    PAT5
        DEFW    PAT6
        DEFW    PAT11
        DEFW    PAT9
        DEFW    PAT10
        DEFW    PAT12
        DEFW    PAT23
        DEFW    PAT25
        DEFW    PAT24
        DEFW    PAT13
        DEFW    PAT26
        DEFW    PAT27
        DEFW    PAT28
        DEFW    PAT9
        DEFW    PAT10
        DEFW    PAT15
        DEFW    PAT16
        DEFW    PAT17
        DEFW    PAT18
        DEFW    PAT19
        DEFW    PAT20
        DEFW    PAT22
        DEFW    PAT21
        DEFW    PAT21
        DEFW    PAT21
        DEFW    PAT21
        DEFW    PAT21
        DEFW    PAT5
        DEFW    PAT6
        DEFW    PAT11
        DEFW    PAT9
        DEFW    PAT10
        DEFW    PAT30
        DEFW    PAT23
        DEFW    PAT25
        DEFW    PAT24
        DEFW    PAT0
        DEFW    PAT29
        DEFW    PAT18
        DEFW    PAT19
        DEFW    PAT20
        DEFW    PAT31
        DEFW    PAT32
        DEFW    PAT0
        DEFW    PAT1
        DEFW    PAT34

; *** Pattern data - $00 marks the end of a pattern ***
PAT0:
        DEFB    $BD, 0
        DEFB    144
        DEFB    144
        DEFB    120
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    144
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $00
PAT1:
        DEFB    139
        DEFB    139
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $BD, 0
        DEFB    139
        DEFB    139
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $00
PAT2:
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    3
        DEFB    $00
PAT3:
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $00
PAT4:
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $00
PAT5:
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    148
        DEFB    120
        DEFB    1
        DEFB    149
        DEFB    120
        DEFB    3
        DEFB    151
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT6:
        DEFB    151
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    153
        DEFB    6
        DEFB    151
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    149
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    148
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    3
        DEFB    $00
PAT9:
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    3
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    $00
PAT10:
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT11:
        DEFB    146
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    148
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    6
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT12:
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    151
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    154
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 6
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 8
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    4
        DEFB    $00
PAT13:
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $BD, 0
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    144
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $BD, 0
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 6
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $00
PAT15:
        DEFB    190
        DEFB    144
        DEFB    120
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    151
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    154
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    158
        DEFB    2
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    158
        DEFB    2
        DEFB    154
        DEFB    4
        DEFB    $00
PAT16:
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    151
        DEFB    120
        DEFB    1
        DEFB    152
        DEFB    2
        DEFB    $00
PAT17:
        DEFB    153
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    151
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    150
        DEFB    2
        DEFB    149
        DEFB    2
        DEFB    148
        DEFB    2
        DEFB    $00
PAT18:
        DEFB    $BD, 0
        DEFB    156
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 2
        DEFB    156
        DEFB    2
        DEFB    $BD, 0
        DEFB    156
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    144
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    2
        DEFB    $00
PAT19:
        DEFB    $BD, 0
        DEFB    154
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    144
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    144
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    160
        DEFB    2
        DEFB    $00
PAT20:
        DEFB    $BD, 2
        DEFB    158
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    154
        DEFB    2
        DEFB    $BD, 2
        DEFB    151
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    142
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    $BD, 2
        DEFB    146
        DEFB    2
        DEFB    $BD, 0
        DEFB    148
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    146
        DEFB    2
        DEFB    $BD, 0
        DEFB    142
        DEFB    2
        DEFB    $BD, 2
        DEFB    139
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    142
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    $BD, 2
        DEFB    146
        DEFB    2
        DEFB    $BD, 0
        DEFB    148
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    146
        DEFB    144
        DEFB    118
        DEFB    1
        DEFB    $BD, 0
        DEFB    142
        DEFB    2
        DEFB    $BD, 2
        DEFB    139
        DEFB    149
        DEFB    2
        DEFB    $BD, 0
        DEFB    142
        DEFB    150
        DEFB    120
        DEFB    1
        DEFB    $BD, 2
        DEFB    146
        DEFB    151
        DEFB    120
        DEFB    1
        DEFB    $BD, 0
        DEFB    142
        DEFB    152
        DEFB    2
        DEFB    $00
PAT21:
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    190
        DEFB    2
        DEFB    $BD, 0
        DEFB    190
        DEFB    2
        DEFB    $BD, 0
        DEFB    190
        DEFB    2
        DEFB    $00
PAT22:
        DEFB    153
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    151
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    $00
PAT23:
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    142
        DEFB    2
        DEFB    141
        DEFB    2
        DEFB    140
        DEFB    2
        DEFB    $BD, 0
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $00
PAT24:
        DEFB    153
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    151
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    $BD, 0
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $00
PAT25:
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    152
        DEFB    2
        DEFB    $00
PAT26:
        DEFB    $BD, 0
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    160
        DEFB    2
        DEFB    161
        DEFB    4
        DEFB    163
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT27:
        DEFB    163
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    165
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    3
        DEFB    163
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    161
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    160
        DEFB    6
        DEFB    $00
PAT28:
        DEFB    158
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    160
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    156
        DEFB    6
        DEFB    151
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT29:
        DEFB    139
        DEFB    139
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $00
PAT30:
        DEFB    144
        DEFB    144
        DEFB    120
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    151
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    154
        DEFB    144
        DEFB    119
        DEFB    1
        DEFB    $BD, 2
        DEFB    158
        DEFB    2
        DEFB    $BD, 6
        DEFB    160
        DEFB    188
        DEFB    2
        DEFB    $BD, 8
        DEFB    158
        DEFB    2
        DEFB    $BD, 0
        DEFB    154
        DEFB    4
        DEFB    $00
PAT31:
        DEFB    154
        DEFB    139
        DEFB    118
        DEFB    1
        DEFB    158
        DEFB    2
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    160
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    8
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    190
        DEFB    120
        DEFB    1
        DEFB    190
        DEFB    120
        DEFB    3
        DEFB    190
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT32:
        DEFB    $BD, 2
        DEFB    224
        DEFB    144
        DEFB    118
        DEFB    5
        DEFB    254
        DEFB    156
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    254
        DEFB    156
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    254
        DEFB    144
        DEFB    6
        DEFB    254
        DEFB    156
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    254
        DEFB    156
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    254
        DEFB    142
        DEFB    6
        DEFB    254
        DEFB    154
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    254
        DEFB    154
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    217
        DEFB    146
        DEFB    6
        DEFB    254
        DEFB    158
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    254
        DEFB    158
        DEFB    4
        DEFB    190
        DEFB    188
        DEFB    2
        DEFB    $00
PAT33:
        DEFB    $BD, 0
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 2
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    139
        DEFB    139
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    $BD, 0
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $00
PAT34:
        DEFB    144
        DEFB    144
        DEFB    4
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    139
        DEFB    139
        DEFB    118
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    2
        DEFB    144
        DEFB    144
        DEFB    119
        DEFB    3
        DEFB    188
        DEFB    188
        DEFB    8
        DEFB    $00
