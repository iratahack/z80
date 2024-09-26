PROJECT_NAME:=main
ASMSRC:=$(wildcard *.asm)

.PHONY: all clean run dis

all: $(PROJECT_NAME).bin

clean:
	rm -f *.aqx *.map *.bin *.o

dis: $(PROJECT_NAME).bin
	z88dk-dis -x $(PROJECT_NAME).map -o CRT_ORG_CODE $(PROJECT_NAME).bin | less

run: all
	aquarius_emu -u . -t "\nrun $(PROJECT_NAME).aqx\n"

%.bin: $(ASMSRC)
	zcc +aquarius --no-crt -m $^ -o$(PROJECT_NAME).bin -create-app -subtype=aqx

