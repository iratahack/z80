
INTERR: DB      0                       ;INTERRUPTORES 1=ON 0=OFF
 ;BIT 0=CARGA CANCION ON/OFF
 ;BIT 1=PLAYER ON/OFF
 ;BIT 2=EFECTOS ON/OFF
 ;BIT 3=SFX ON/OFF
 ;BIT 4=LOOP
;CONTROL DE LAS INTERRUPCIONES

;HOOK: DB 0

;MUSICA **** EL ORDEN DE LAS VARIABLES ES FIJO ******



SONG:   DB      0                       ;DBN� DE CANCION
TEMPO:  DB      0                       ;DB TEMPO
TTEMPO: DB      0                       ;DB CONTADOR TEMPO

PUNTERO_A:
        DW      0                       ;DW PUNTERO DEL CANAL A
PUNTERO_B:
        DW      0                       ;DW PUNTERO DEL CANAL B
PUNTERO_C:
        DW      0                       ;DW PUNTERO DEL CANAL C

CANAL_A:
        DW      0                       ;DW DIRECION DE INICIO DE LA MUSICA A
CANAL_B:
        DW      0                       ;DW DIRECION DE INICIO DE LA MUSICA B
CANAL_C:
        DW      0                       ;DW DIRECION DE INICIO DE LA MUSICA C

PUNTERO_P_A:
        DW      0                       ;DW PUNTERO PAUTA CANAL A
PUNTERO_P_B:
        DW      0                       ;DW PUNTERO PAUTA CANAL B
PUNTERO_P_C:
        DW      0                       ;DW PUNTERO PAUTA CANAL C

PUNTERO_P_A0:
        DW      0                       ;DW INI PUNTERO PAUTA CANAL A
PUNTERO_P_B0:
        DW      0                       ;DW INI PUNTERO PAUTA CANAL B
PUNTERO_P_C0:
        DW      0                       ;DW INI PUNTERO PAUTA CANAL C

PUNTERO_P_DECA:
        DW      0                       ;DW PUNTERO DE INICIO DEL DECODER CANAL A
PUNTERO_P_DECB:
        DW      0                       ;DW PUNTERO DE INICIO DEL DECODER CANAL B
PUNTERO_P_DECC:
        DW      0                       ;DW PUNTERO DE INICIO DEL DECODER CANAL C

PUNTERO_DECA:
        DW      0                       ;DW PUNTERO DECODER CANAL A
PUNTERO_DECB:
        DW      0                       ;DW PUNTERO DECODER CANAL B
PUNTERO_DECC:
        DW      0                       ;DW PUNTERO DECODER CANAL C

REG_NOTA_A:
        DB      0                       ;DB REGISTRO DE LA NOTA EN EL CANAL A
VOL_INST_A:
        DB      0                       ;DB VOLUMEN RELATIVO DEL INSTRUMENTO DEL CANAL A
REG_NOTA_B:
        DB      0                       ;DB REGISTRO DE LA NOTA EN EL CANAL B
VOL_INST_B:
        DB      0                       ;DB VOLUMEN RELATIVO DEL INSTRUMENTO DEL CANAL B ;VACIO
REG_NOTA_C:
        DB      0                       ;DB REGISTRO DE LA NOTA EN EL CANAL C
VOL_INST_C:
        DB      0                       ;DB VOLUMEN RELATIVO DEL INSTRUMENTO DEL CANAL C

PUNTERO_L_DECA:
        DW      0                       ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL A
PUNTERO_L_DECB:
        DW      0                       ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL B
PUNTERO_L_DECC:
        DW      0                       ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL C

;CANAL DE EFECTOS DE RITMO - ENMASCARA OTRO CANAL

PUNTERO_P:
        DW      0                       ;DW PUNTERO DEL CANAL EFECTOS
CANAL_P:
        DW      0                       ;DW DIRECION DE INICIO DE LOS EFECTOS
PUNTERO_P_DECP:
        DW      0                       ;DW PUNTERO DE INICIO DEL DECODER CANAL P
PUNTERO_DECP:
        DW      0                       ;DW PUNTERO DECODER CANAL P
PUNTERO_L_DECP:
        DW      0                       ;DW PUNTERO DE INICIO DEL LOOP DEL DECODER CANAL P
;SELECT_CANAL_P DB INTERR+$36 ;DB SELECCION DE CANAL DE EFECTOS DE RITMO

SFX_L:  DW      0                       ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO BAJO
SFX_H:  DW      0                       ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO ALTO
SFX_V:  DW      0                       ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO VOLUMEN
SFX_MIX:
        DW      0                       ;DW DIRECCION BUFFER EFECTOS DE RITMO REGISTRO MIXER

;EFECTOS DE SONIDO

N_SONIDO:
        DB      0                       ;DB : NUMERO DE SONIDO
PUNTERO_SONIDO:
        DW      0                       ;DW : PUNTERO DEL SONIDO QUE SE REPRODUCE

; BUFFERs DE REGISTROS DEL PSG

PSG_REG:
        DS      PSG_NUM_REG
PSG_REG_SEC:
        DS      PSG_NUM_REG
ENVOLVENTE:
        DB      0                       ;DB : FORMA DE LA ENVOLVENTE
 ;BIT 0 : FRECUENCIA CANAL ON/OFF
 ;BIT 1-2 : RATIO
 ;BIT 3-3 : FORMA
ENVOLVENTE_BACK:
        DB      0                       ;DB: BACKUP DE LA FORMA DE LA ENVOLENTE
BUFFER_DEC:
        ds      CHANNEL_BUFF_SIZE*4
SONIDO_REGS:
        ds      2
EFECTO_REGS:
        ds      2
PUNTERO_EFECTO:
        ds      2
