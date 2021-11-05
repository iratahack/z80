PROJ=test

.PHONY: all clean

all: $(PROJ).img

%.img: %.c wyzproplay_msx.asm
	zcc +msx -m -subtype=disk -o $@ $+ -create-app 

clean:
	rm -f *.map *.msx *.img
