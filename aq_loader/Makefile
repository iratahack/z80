.PHONY: all clean run

A_SRC:= loader.asm vectors.asm phaser1.asm

all: loader.aqx

clean:
	rm -rf *.bas *.aqx *.scr *.map *.bin

run:
	aquarius_emu -u . -t "\nrun loader.aqx\n"

loader.aqx: $(A_SRC) loader.bas loading_screen.scr
	zcc +aquarius -crt0 crt.asm $(A_SRC) -m $< -o $@

%.bas: %.txt
	./txt2bas.py $< $@

%.scr: %.png
	./png2bm.py $< $@
