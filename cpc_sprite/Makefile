AS=z88dk-asmpp
LD=zcc
PROJ=sprite
PRAGMA_FILE=zpragma.inc
DSKTOOL=/home/devel/sector-cpc/build/sector-cpc

ASMSRC=$(wildcard *.asm)
OBJECTS=$(ASMSRC:.asm=.o)

LDFLAGS= +cpc -crt0 crt/crt.asm -m -pragma-include:$(PRAGMA_FILE)

# Default to the CODE bank if no other is specified
BANK ?= BANK_0
# Find the start addres of the BANK and replace $ with 0x
HEAD=$(shell grep __$(BANK)_head *.map | awk '{gsub("^.", "0x", $$3); print $$3}')

BANKS= $(PROJ)_CODE.bin \
		$(PROJ)_BANK_0.bin \
		$(PROJ)_BANK_1.bin

.PHONY: all clean run dis

all: $(PROJ).dsk

clean:
	rm -f *.[io] *.dsk *.bin *.cpc *.map *.sym *.com *.b?
 
dis: $(PROJ).dsk
	z88dk-dis -o $(HEAD) -x sprite.map sprite_$(BANK).bin | less

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).cpc

$(PROJ).dsk: $(BANKS)
	cp $(PROJ)_CODE.bin $(PROJ).cpc
	cp $(PROJ)_BANK_0.bin $(PROJ).b0
	cp $(PROJ)_BANK_1.bin $(PROJ).b1
	$(DSKTOOL) --file $(PROJ).dsk new insert $(PROJ).cpc 0x200 0x200
	$(DSKTOOL) --file $(PROJ).dsk insert $(PROJ).b0 0x300 0x300
	$(DSKTOOL) --file $(PROJ).dsk insert $(PROJ).b1 0x4000 0x4000

%.bin: $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $(PROJ)

%.o: %.asm
	$(AS) $(ASFLAGS) $<
