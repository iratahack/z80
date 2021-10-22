AS=z88dk-asmpp
LD=zcc
PROJ=sprite
PRAGMA_FILE=zpragma.inc
DSKTOOL=tools/sector-cpc

ASMSRC=$(wildcard *.asm) $(wildcard BIOS/*.asm)
OBJECTS=$(ASMSRC:.asm=.o)

LDFLAGS= +cpc -crt0 crt/crt.asm -m -pragma-include:$(PRAGMA_FILE)

# Default to the CODE bank if no other is specified
BANK ?= BANK_0

# Find the start addres of the BANK and replace $ with 0x
HEAD=$(shell grep __$(BANK)_head *.map | awk '{gsub("^.", "0x", $$3); print $$3}')

.PHONY: all clean run dis

all: $(PROJ).dsk

clean:
	rm -f *.[iod] *.dsk *.bin *.cpc *.map *.err *.b? *.wav
	rm -f BIOS/*.[iod] BIOS/*.err
 
dis: $(PROJ).dsk
	z88dk-dis -o $(HEAD) -x $(PROJ).map $(PROJ)_$(BANK).bin | less

run: $(PROJ).dsk
	caprice32.launcher $(PROJ).dsk -a run\"$(PROJ).cpc

ifeq (,$(findstring $(MAKECMDGOALS),clean))
%.d: %.asm
	@./mkdep.sh $< > $@
endif

%.dsk: $(OBJECTS)
	@echo "Creating $@"
	@$(LD) $(LDFLAGS) $(OBJECTS) -o $(PROJ) -create-app -subtype=dsk

%.o: %.asm
	@$(AS) $(ASFLAGS) $<

-include $(ASMSRC:.asm=.d)

