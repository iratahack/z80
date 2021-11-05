        ;
        ; Table of songs...
        ;
TABLA_SONG:
        dw      SONG_0, SONG_1, SONG_2

        ;
        ; Instrument configuration exported from WYZTracker
        ;
        include "music/CastleEscape.mus.inc"

        ;
        ; Songs exported from WYZTracker
        ;
SONG_0:
        binary  "music/gothic.mus"
SONG_1:
        binary  "music/jinj_med.mus"
SONG_2:
        binary  "music/death.wyz.mus"
