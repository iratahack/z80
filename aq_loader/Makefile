.PHONY: all clean run

A_SRC:= loader.asm vectors.asm phaser1.asm

all: loader.aqx

clean:
	rm -rf *.baq *.aqx *.scr *.map *.bin

run: all
	aquarius_emu -u . -t "\nrun loader.aqx\n"

loader.aqx: $(A_SRC) loader.baq loading_screen.scr
	zcc +aquarius -crt0 crt.asm $(A_SRC) -m $< -o $@

%.baq: %.bas
	./bas2baq.py $< $@

%.scr: %.png
	./png2bm.py $< $@
