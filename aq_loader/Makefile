.PHONY: all clean

all: loader.aqx

clean:
	rm -rf *.bas *.aqx *.scr

loader.aqx: loader.asm loader.bas loading_screen.scr
	zcc +aquarius --no-crt $< -o $@

%.bas: %.txt
	./txt2bas.py $< $@

%.scr: %.png
	./png2bm.py $< $@
