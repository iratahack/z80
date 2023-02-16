ifeq ($(OS),Windows_NT)
SUFFIX=.exe
else
SUFFIX=
endif

AS=z88dk-z80asm
LD=z88dk-z80asm

PROJECT_NAME=sprite
ASMSRC=sprite.asm tiles.asm levels.asm knight.asm
EMUFLAGS= --machine TBBlue --configfile .zesaruxrc --tbblue-fast-boot-mode  --nosplash --nowelcomemessage --quickexit
ZXSTLC=./tools/zxstlc$(SUFFIX)


LDFLAGS=-mz80n -m -b
ASFLAGS=-mz80n
DISFLAGS=-mz80n
OBJECTS=$(ASMSRC:.asm=.o)

# Default to the CODE bank if no other is specified
BANK ?= BANK_5
# Find the start addres of the BANK and replace $ with 0x
HEAD=$(shell grep __$(BANK)_head *.map | awk '{gsub("^.", "0x", $$3); print $$3}')

.PHONY: all clean run dis

all: $(PROJECT_NAME).bin

clean:
	rm -f *.[oid] *.tap *.bin *.map *.dsk

run: $(PROJECT_NAME).tap
	zesarux $(EMUFLAGS) $<

rundsk: $(PROJECT_NAME).dsk
	fuse $<

dis: $(PROJECT_NAME).bin
	z88dk-dis $(DISFLAGS) -o $(HEAD) -x $(PROJECT_NAME).map $(PROJECT_NAME).bin | less

ifeq (,$(findstring $(MAKECMDGOALS),clean))
%.d: %.asm
	@./mkdep.sh $< > $@

%.d: %.c
	@./mkdep.sh $< > $@
endif

%.o: %.c
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) -o $@ $<

%.o: %.asm
	@echo "Assembling $<"
	@$(AS) $(ASFLAGS) $<

$(PROJECT_NAME)_BANK_2.bin: $(OBJECTS)
	@echo "Linking $@"
	$(LD) $(LDFLAGS) -o$(PROJECT_NAME) $(OBJECTS)

$(PROJECT_NAME).bin: $(PROJECT_NAME)_BANK_2.bin
	@echo "Creating $@"
	@cp ${PROJECT_NAME}_BANK_5.bin ${PROJECT_NAME}.bin
	@dd if=/dev/null of=${PROJECT_NAME}.bin bs=1 count=1 seek=8K
	@cat ${PROJECT_NAME}_BANK_2.bin >> ${PROJECT_NAME}.bin
	@dd if=/dev/null of=${PROJECT_NAME}.bin bs=1 count=1 seek=24K
	@cat ${PROJECT_NAME}_BANK_0.bin >> ${PROJECT_NAME}.bin

$(PROJECT_NAME).tap: $(PROJECT_NAME).bin
	@echo "Creating $@"
	$(ZXSTLC) -t $(PROJECT_NAME).bin 24576 33156 -e

-include $(ASMSRC:.asm=.d) $(CSRC:.c=.d)
