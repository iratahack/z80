.PHONY: all clean run dis

A_SRC:= $(wildcard *.asm)

all: loader.bin

clean:
	rm -rf *.aqx *.scr *.zx0 *.map *.bin

run: all
	aquarius_emu -u . -t "\nrun loader.aqx\n"

dis: all
	z88dk-dis -x loader.map -o CRT_ORG_CODE loader.bin | less

%.bin: $(A_SRC) loading_screen.scr.zx0
	zcc +aquarius -pragma-include:zpragma.inc -clib=aqplus $(A_SRC) -m -o $@ -create-app -subtype=aqx

%.scr: %.png
	./png2bm.py $< $@

%.scr.zx0: %.scr
	z88dk-zx0 -f $<
