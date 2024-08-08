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
        di
        ld      sp, loaderEnd           ; New stack

	; Set the border color
        xor     a
        out     (IO_VPALSEL), a
        out     (IO_VPALDATA), a        ; G/B
        inc     a
        out     (IO_VPALSEL), a
        xor     a
        out     (IO_VPALDATA), a        ; R

        call    displayLoadingScreen

        call    clearMemory

        ; Copy loader to page 40 which
        ; will be mapped in at bank 0
        ld      a, 40
        out     (IO_BANK1), a
        ld      hl, init
        ld      de, init+__BANK_1_head
        ld      bc, loaderEnd-init
        ldir

        ; Load the banks
        ld      de, bank0_filename      ; DE = Filename address
        call    loadBank

        ; Update filename for next bank
;        ld      hl, bank
;        inc     (hl)
;        ld      a, <bank #>
;        out     (IO_BANK1), a
;        ld      de, bank0_filename      ; DE = Filename address
;        call    loadBank
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

loadBank:
        call    str_tempdesc            ; Build string descriptor for save
        ld      de, __BANK_1_head       ; DE = Data start address
        ld      bc, $4000               ; BC = Max data length
        ld      iy, file_load_binary    ; Call load routine
        call    aux_call                ; in auxillary ROM
        ret

clearMemory:
        in      a, (IO_BANK1)
        push    af

        ld      a, 40
clearNextBank:
        out     (IO_BANK1), a
        ; Clear it
        ld      hl, __BANK_1_head
        ld      de, __BANK_1_head+1
        ld      (hl), 0
        ld      bc, $3fff
        ldir

        inc     a
        cp      44
        jr      nz, clearNextBank

        pop     af
        out     (IO_BANK1), a
        ret

displayLoadingScreen:
        ld      a, 20                   ; VRAM
        out     (IO_BANK1), a

        ld      de, filename            ; DE = Filename address
        call    loadBank

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
        db      "loader_BANK_"
bank:
        db      "0"
        db      ".bin", 0

        ds      $20, $aa                ; Stack
loaderEnd:
