PROJECT_NAME := isr

CC	:= zcc
CFLAGS	:= +aquarius -clib=aqplus -m -pragma-include:zpragma.inc -create-app -subtype=aqx

CSRC=$(wildcard *.c)
ASSRC=$(wildcard *.asm)

.PHONY: all clean run dis

all: $(PROJECT_NAME).aqx

clean:
	rm -f *.aqx *.map *.bin *.o

dis: all
	z88dk-dis -x $(PROJECT_NAME).map -o CRT_ORG_CODE $(PROJECT_NAME).bin | less

run: all
	aquarius_emu -u . -t "\nrun $(PROJECT_NAME).aqx\n"

%.aqx: $(CSRC) $(ASSRC)
	$(CC) $(CFLAGS) $^ -o$(PROJECT_NAME).bin
