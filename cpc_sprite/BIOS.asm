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

        section BSS_0
ticks:
        ds      1
lastKeyPoll:
        defs    10
