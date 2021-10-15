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
		$(PROJ)_BANK_0.bin

.PHONY: all clean run dis distclean

all: $(PROJ).dsk

clean:
	rm -f *.[io] *.dsk *.bin *.me *.map *.sym *.com *.b?
 
distclean: clean
	rm -rf sector-cpc
	rm -rf tools

dis: $(PROJ).dsk
	z88dk-dis -o $(HEAD) -x $(PROJ).map $(PROJ)_$(BANK).bin | less

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"run.me

$(PROJ).dsk: $(BANKS) $(DSKTOOL)
	@echo "Creating $@"
	# Add the boot loader to the disk image
	@cp $(PROJ)_CODE.bin run.me
	@$(DSKTOOL) --file $@ new insert run.me 0x100 0x100
	# Add the banks to the disk image
	@ls $(PROJ)_BANK_?.bin | sed -e 's/\(.*\)\(_BANK_\)\(.\).bin/\1\2\3.bin \1.b\3/g' | xargs -L 1 cp
	@ls *.b? | xargs -L 1 $(DSKTOOL) --file $@ insert

%.bin: $(OBJECTS)
	@echo "Linking $@"
	@$(LD) $(LDFLAGS) $(OBJECTS) -o $(PROJ)

%.o: %.asm
	@$(AS) $(ASFLAGS) $<

sector-cpc:
	@git clone --depth=1 https://github.com/neuro-sys/sector-cpc.git

$(DSKTOOL): sector-cpc
	@mkdir -p sector-cpc/build
	@mkdir -p tools
	@cmake -S sector-cpc -B sector-cpc/build
	@cmake --build sector-cpc/build
	@install -v sector-cpc/build/sector-cpc tools
