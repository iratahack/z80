
.PHONY: all clean

all: test.dsk

%.dsk: %.c
	zcc +cpc -lcpcfs -subtype=dsk -create-app -o test.bin test.c -DCPC -m
	#zcc +cpc -lcpcfs -lm -subtype=dsk -create-app -o test.bin test.c -DCPC -m

clean:
	rm -f *.bin *.dsk *.cpc *.wav *.map
