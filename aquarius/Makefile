PROJ=main

.PHONY: all clean

all: $(PROJ).bin

%.bin: %.c
	zcc +aquarius -clib=ansi -subtype=rom $< -o $@  -create-app

clean:
	rm -f *.bin *.caq *.rom

