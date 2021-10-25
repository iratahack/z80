PROJ=test

.PHONY: all clean

all: $(PROJ).dsk

%.dsk: %.c
	zcc +cpc -lcpcfs -subtype=dsk -o $@ $< -create-app 

clean:
	rm -f *.bin *.dsk *.cpc *.wav *.map

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).cpc
