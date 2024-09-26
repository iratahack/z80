PROJECT_NAME=main

.PHONY: all clean

ASSRC:=$(wildcard *.asm)

all: $(PROJECT_NAME).bin

dis: all
	z88dk-dis -x $(PROJECT_NAME).map -o CRT_ORG_CODE $(PROJECT_NAME).bin | less

run: all
	aquarius_emu -u . -t "\nrun $(PROJECT_NAME).aqx\n"

%.bin: $(ASSRC)
	zcc +aquarius -pragma-include:zpragma.inc -m -clib=aqplus $^ -o $@ -create-app -subtype=aqx

clean:
	rm -f *.bin *.aqx *.map

