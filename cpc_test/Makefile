PROJ=test

.PHONY: all clean

all: $(PROJ).dsk

%.dsk: %.c title.scr.zx0
	zcc +cpc -lndos -subtype=dsk -o $@ $< -create-app -m

clean:
	rm -f *.bin *.dsk *.cpc *.wav *.map *.zx0 *.b?

title.scr.zx0: title.scr
	z88dk-zx0 -f -q $<

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).cpc
