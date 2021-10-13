AS=z88dk-asmpp
LD=zcc
PROJ=sprite

ASMSRC=$(wildcard *.asm)
OBJECTS=$(ASMSRC:.asm=.o)

LDFLAGS= +cpc -crt0 crt/crt.asm -m


.PHONY: all clean run dis

all: $(PROJ).dsk

clean:
	rm -f *.[io] *.dsk *.bin *.cpc *.map *.sym *.com
 
dis: $(PROJ)_code.bin
	z88dk-dis -o 0x1200 -x sprite.map sprite_code.bin | less

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).cpc

$(PROJ).dsk: $(PROJ)_code.bin
	z88dk-appmake +cpc --disk -b $(PROJ)_code.bin -o $(PROJ).cpc --org 0x1200

$(PROJ)_code.bin: $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $(PROJ)

%.o: %.asm
	$(AS) $(ASFLAGS) $<
