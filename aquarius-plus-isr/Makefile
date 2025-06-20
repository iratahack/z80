PROJECT_NAME := isr

CC	:= zcc
CFLAGS	:= +aquarius -clib=aqplus -m -pragma-include:zpragma.inc -create-app -subtype=aqex

CSRC=$(wildcard *.c)
ASSRC=$(wildcard *.asm)

.PHONY: all clean run dis

all: $(PROJECT_NAME).aqex

clean:
	rm -f *.aqex *.map *.bin *.o

dis: all
	z88dk-dis -x $(PROJECT_NAME).map -o CRT_ORG_CODE $(PROJECT_NAME).bin | less

run: all
	aqplus-emu -u . -t "\nrun $(PROJECT_NAME).aqex\n"

%.aqex: $(CSRC) $(ASSRC)
	$(CC) $(CFLAGS) $^ -o$(PROJECT_NAME).bin
