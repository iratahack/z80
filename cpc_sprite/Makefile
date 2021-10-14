AS=z88dk-asmpp
LD=zcc
PROJ=sprite
PRAGMA_FILE=zpragma.inc
DSKTOOL=tools/sector-cpc

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
	rm -f *.[io] *.dsk *.bin *.run *.map *.sym *.com *.b?
 
dis: $(PROJ).dsk
	z88dk-dis -o $(HEAD) -x $(PROJ).map $(PROJ)_$(BANK).bin | less

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).run

$(PROJ).dsk: $(BANKS) $(DSKTOOL)
	cp $(PROJ)_CODE.bin $(PROJ).run
	cp $(PROJ)_BANK_0.bin $(PROJ).b0
	cp $(PROJ)_BANK_1.bin $(PROJ).b1
	$(DSKTOOL) --file $(PROJ).dsk new insert $(PROJ).run 0x200 0x200
	$(DSKTOOL) --file $(PROJ).dsk insert $(PROJ).b0 0x300 0x300
	$(DSKTOOL) --file $(PROJ).dsk insert $(PROJ).b1 0x4000 0x4000

%.bin: $(OBJECTS)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $(PROJ)

%.o: %.asm
	$(AS) $(ASFLAGS) $<

sector-cpc:
	@git clone --depth=1 https://github.com/neuro-sys/sector-cpc.git

$(DSKTOOL): sector-cpc
	@mkdir -p sector-cpc/build
	@mkdir -p tools
	@cmake -S sector-cpc -B sector-cpc/build
	@cmake --build sector-cpc/build
	@install -v sector-cpc/build/sector-cpc tools