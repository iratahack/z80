PROJ=main

.PHONY: all clean

all: $(PROJ).bas $(PROJ).bin

%.bin: %.asm
	zcc +aquarius -m -clib=aqplus $< -o $@

%.bas: %.txt
	./txt2bas.py $< $@

clean:
	rm -f *.bin *.bas *.map

