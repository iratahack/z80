PROJ=main

.PHONY: all clean

all: $(PROJ).bin

%.bin: %.c
	zcc +aquarius -m -clib=ansi $< -o $@  -create-app -subtype=rom

clean:
	rm -f *.bin *.caq *.rom *.map

dis: all
	z88dk-dis -x $(PROJ).map -o CRT_ORG_CODE $(PROJ).bin | less
