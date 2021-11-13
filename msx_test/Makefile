PROJ=test

.PHONY: all clean run

all: $(PROJ).rom

%.rom: %.c wyzproplay_msx.asm
	zcc +msx -m -lmsxbios -subtype=rom -o $(PROJ).bin $+ -create-app

run: all
	openmsx -machine msx1 -carta $(PROJ).rom

clean:
	rm -f *.map *.bin *.rom
