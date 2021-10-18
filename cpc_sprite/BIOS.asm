        include "BIOS/macros.inc"

        section CODE_0
        include "BIOS/cls.asm"
        include "BIOS/puts.asm"
        include "BIOS/vsync.asm"
        include "BIOS/border.asm"
        include "BIOS/isr.asm"
        include "BIOS/keyboard.asm"

        section RODATA_0
        include "BIOS/screentab.asm"
        include "BIOS/font.asm"
        include "BIOS/keyTab.asm"
mode1PenMask:
        db      0x00                    ; Pen 0
        db      0x0f                    ; Pen 1
        db      0xf0                    ; Pen 2
        db      0xff                    ; Pen 3

        section BSS_0
ticks:
        ds      1
lastKeyPoll:
        ds      10
cursorPos:
        ds      2
