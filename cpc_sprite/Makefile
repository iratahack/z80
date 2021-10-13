AS=z88dk-asmpp

ASMSRC=$(wildcard *.asm)
OBJECTS=$(ASMSRC:.asm=.o)

.PHONY: all clean run dis

all: sprite.dsk

clean:
	rm -f *.[io] *.dsk *.bin *.cpc *.map *.sym *.com
 
dis: sprite.bin
	z88dk-dis -o 0x1200 -x sprite.map sprite.bin | less

run: sprite.dsk
	caprice32.launcher sprite.dsk -a run\"sprite.cpc

sprite.dsk: $(OBJECTS)
	zcc +cpc -m -subtype=dsk -create-app -o $@ $(OBJECTS)

sprite.bin: $(OBJECTS)
	zcc +cpc -m -create-app -o $@ $(OBJECTS)

%.o: %.asm
	$(AS) $(ASFLAGS) $<
