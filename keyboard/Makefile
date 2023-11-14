PROJ=keyboard

.PHONY: all clean

all: $(PROJ).tap

%.tap: %.asm
	zcc +zx -lndos -o $(PROJ).bin $< -create-app -m

clean:
	rm -f *.bin *.tap *.map

run: $(PROJ).tap
	fuse $(PROJ).tap
