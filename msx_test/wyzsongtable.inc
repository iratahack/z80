        ;
        ; Example song table setup
        ;
TABLA_SONG:
        dw      SONG_0	; , SONG_1, SONG_2

        ;
        ; ASM file exported from WYZTracker
        ;
        include "demo.mus.asm"

        ;
        ; Songs exported from WYZTracker
        ;
SONG_0:
        binary  "demo.mus"
;SONG_1:
;        binary  "song2.mus"
;SONG_2:
;        binary  "song2.mus"

