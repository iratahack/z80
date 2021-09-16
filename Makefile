
.PHONE: all clean gb cpc

all: gb cpc

gb: test.gb

cpc:test.dsk

%.dsk: %.c
	zcc +cpc -lcpcfs -lm -subtype=dsk -create-app -o test.bin test.c

%.gb: %.c
	zcc +gb $< -o $@ -create-app

clean:
	rm -f *.bin *.tap *.gb
	rm -f *.dsk *.com *.cpc
