AS=z88dk-asmpp
LD=zcc
PROJ=sprite
PRAGMA_FILE=zpragma.inc

ASMSRC=$(wildcard *.asm)
OBJECTS=$(ASMSRC:.asm=.o)

LDFLAGS= +cpc -crt0 crt/crt.asm -m -pragma-include:$(PRAGMA_FILE)

# Default to the CODE bank if no other is specified
BANK ?= BANK_0
# Find the start addres of the BANK and replace $ with 0x
HEAD=$(shell grep __$(BANK)_head *.map | awk '{gsub("^.", "0x", $$3); print $$3}')

.PHONY: all clean run dis

all: $(PROJ).dsk

clean:
	rm -f *.[io] *.dsk *.bin *.cpc *.map *.sym *.com
 
dis: $(PROJ)_BANK_0.bin
	z88dk-dis -o $(HEAD) -x sprite.map sprite_BANK_0.bin | less

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).cpc

$(PROJ).dsk: $(PROJ)_BANK_0.bin
	z88dk-appmake +cpc --disk -b $(PROJ)_BANK_0.bin -o $(PROJ).cpc --org 0x200

$(PROJ)_BANK_0.bin: $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $(PROJ)

%.o: %.asm
	$(AS) $(ASFLAGS) $<
