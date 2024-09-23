CC=zcc
CFLAGS=+aquarius -compiler=sdcc -clib=aqplus -m -pragma-include:zpragma.inc
PROJECT_NAME:=main
CSRC=$(wildcard *.c)

.PHONY: all clean run dis

all: $(PROJECT_NAME).aqex

clean:
	rm -f *.aqex *.map *.bin *.o

dis: all
	z88dk-dis -x $(PROJECT_NAME).map -o CRT_ORG_CODE $(PROJECT_NAME).bin | less

run: all
	aquarius_emu -u . -t "\nrun $(PROJECT_NAME).aqex\n"

%.aqex: $(CSRC)
	$(CC) $(CFLAGS) $^ -o$(PROJECT_NAME).bin -create-app -subtype=aqex

