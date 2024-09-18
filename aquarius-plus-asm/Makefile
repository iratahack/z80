PROJ=main

.PHONY: all clean

all: $(PROJ).baq $(PROJ).bin

%.bin: %.asm
	zcc +aquarius -m -clib=aqplus $< -o $@

%.baq: %.bas
	./bas2baq.py $< $@

clean:
	rm -f *.bin *.baq *.map

