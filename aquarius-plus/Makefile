AS=z88dk-z80asm
ASFLAGS=-mz80 -m -b
PROJECT_NAME:=main
ASMSRC=$(wildcard *.asm)

.PHONY: all clean run dis

all: $(PROJECT_NAME).aqx

clean:
	$(RM) *.aqx *.map *.bin *.o

dis: $(PROJECT_NAME).bin
	z88dk-dis -x $(PROJECT_NAME).map -o CRT_ORG_CODE $(PROJECT_NAME).bin | less

run: all
	aquarius_emu -u . -t "\nrun $(PROJECT_NAME).aqx\n"

%.bin: $(ASMSRC)
	$(AS) $(ASFLAGS) $^ -o$(PROJECT_NAME).bin

%.aqx: %.bin
	z88dk-appmake +aquarius -b $< --aqx

