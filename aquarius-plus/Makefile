PROJ=main

.PHONY: all clean

all: $(PROJ).bin

%.bin: %.c
	zcc +aquarius -m -clib=aqplus $< -o $@  -create-app

clean:
	rm -f *.bin *.caq *.rom *.map

