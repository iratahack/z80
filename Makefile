
.PHONY: all clean gb cpc

all: gb cpc

gb: test.gb

cpc:test.dsk

%.dsk: %.c
	zcc +cpc -lcpcfs -lm -subtype=dsk -create-app -o test.bin test.c -DCPC

%.gb: %.c
	zcc +gb $< -o $@ -O0 -create-app -DGB

clean:
	rm -f *.bin *.tap *.gb
	rm -f *.dsk *.com *.cpc
