;       Exported routines
        public  wyz_play_frame
        public  wyz_play_song
        public  wyz_play_fx
        public  wyz_play_sound
        public  wyz_player_init
        public  wyz_player_stop
	public	_music

_music:
	call	wyz_player_init


	ld	a, 0
	call	wyz_play_song

loop:
	halt
	call	wyz_play_frame
	jp	loop


        include "wyzproplay47c_common.inc"

ROUT:   LD      A, (PSG_REG+13)
        AND     A
        JR      Z, NO_BACKUP_ENVOLVENTE
        LD      (ENVOLVENTE_BACK), A
        XOR     A
NO_BACKUP_ENVOLVENTE:
        LD      C, $A0
        LD      HL, PSG_REG_SEC
LOUT:   OUT     (C), A
        INC     C
        OUTI
        DEC     C
        INC     A
        CP      13
        JR      NZ, LOUT
        OUT     (C), A
        LD      A, (HL)
        AND     A
        RET     Z
        INC     C
        OUT     (C), A
        XOR     A
        LD      (PSG_REG_SEC+13), A
        LD      (PSG_REG+13), A
        RET

        ;
        ; Song table setup
        ;
        include "wyzsongtable.inc"

        ;
        ; RAM variables
        ;
        include "wyzproplay_ram.inc"
