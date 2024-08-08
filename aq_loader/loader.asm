str_tempdesc    equ $2115
aux_call    equ $2100                   ; Call routine in auxillary ROM
file_load_binary    equ $C042
file_load_paged equ $C048
IO_BANK0    equ $f0
IO_BANK1    equ $f1
IO_BANK2    equ $f2
IO_BANK3    equ $f3
IO_VPALSEL  equ $EA
IO_VPALDATA equ $EB
IO_VCTRL    equ $e0

        extern  __BANK_1_head
        org     $38E1
basicLoader:
        binary  "loader.bas"
init:
	; Set the border color
        xor     a
        out     (IO_VPALSEL), a
        out     (IO_VPALDATA), a        ; G/B
        inc     a
        out     (IO_VPALSEL), a
        xor     a
        out     (IO_VPALDATA), a        ; R

        call    displayLoadingScreen

        ; Load page for bank 0
        ld      a, 40
        out     (IO_BANK1), a
        ; Clear it
        ld      hl, __BANK_1_head
        ld      de, __BANK_1_head+1
        ld      (hl), 0
        ld      bc, $3fff
        ldir

        ; Copy loader
        ld      hl, init
        ld      de, init+__BANK_1_head
        ld      bc, loaderEnd-init
        ldir

        ld      de, bank0_filename      ; DE = Filename address
        call    str_tempdesc            ; Build string descriptor for save
        ld      de, __BANK_1_head       ; DE = Data start address
        ld      bc, $3800               ; BC = Max data length
        ld      iy, file_load_binary    ; Call load routine
        call    aux_call                ; in auxillary ROM
initMemmap:
        ld      a, 40
        out     (IO_BANK0), a
        inc     a
        out     (IO_BANK1), a
        inc     a
        out     (IO_BANK2), a
        inc     a
        out     (IO_BANK3), a

        rst     0                       ; Hit the reset vector
displayLoadingScreen:
        ld      a, 20                   ; VRAM
        out     (IO_BANK1), a

        ld      de, filename            ; DE = Filename address
        call    str_tempdesc            ; Build string descriptor for save
        ld      de, __BANK_1_head       ; DE = Data start address
        ld      bc, $4000               ; BC = Max data length
        ld      iy, file_load_binary    ; Call load routine
        call    aux_call                ; in auxillary ROM

        ld      hl, __BANK_1_head+(40*200)
        ld      b, 32
        ld      a, b
setPal:
        out     (IO_VPALSEL), a
        inc     a

        ex      af, af'
        ld      a, (hl)
        inc     hl
        out     (IO_VPALDATA), a
        ex      af, af'

        djnz    setPal

        ld      a, 2<<1
        out     (IO_VCTRL), a
        ret

filename:
        db      "loading_screen.scr", 0
bank0_filename:
        db      "loader_BANK_0.bin", 0
loaderEnd:
