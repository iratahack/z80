
all: sprite.tap

clean:
	rm -f *.bin *.tap *.map *.[io]

run: sprite.tap
	zesarux --machine TBBlue --tape sprite.tap --configfile .zesaruxrc --tbblue-fast-boot-mode  --nosplash --nowelcomemessage --quickexit

sprite.bin: sprite.asm
	z88dk-asmpp -mz80n -m -b sprite.asm

sprite.tap: sprite.bin
	z88dk-appmake +zxn --crt0file sprite --org 0x8000 -b sprite.bin

dis: sprite.bin
	z88dk-dis -mz80n -o 0x8000 -x sprite.map sprite.bin | less
