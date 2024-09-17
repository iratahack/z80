PROJ=main

.PHONY: all clean

all: $(PROJ).bas $(PROJ).bin

%.bin: %.c
	zcc +aquarius -compiler=sdcc -m -clib=aqplus $< -o $@

%.bas: %.txt
	./txt2bas.py $< $@

clean:
	rm -f *.bin *.bas *.map

