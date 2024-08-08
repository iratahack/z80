.PHONY: all clean

all: loader.aqx

clean:
	rm -rf *.bas *.aqx *.scr *.map *.bin

loader.aqx: loader.asm vectors.asm loader.bas loading_screen.scr
	zcc +aquarius -crt0 crt.asm vectors.asm -m $< -o $@

%.bas: %.txt
	./txt2bas.py $< $@

%.scr: %.png
	./png2bm.py $< $@
