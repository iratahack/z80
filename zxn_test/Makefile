
all: sprite.tap

clean:
	rm -f *.bin *.tap *.map

run: sprite.tap
	zesarux --machine TBBlue --tape sprite.tap --configfile .zesaruxrc --tbblue-fast-boot-mode  --nosplash --nowelcomemessage --quickexit

sprite.tap: sprite.asm
	zcc +zxn -m sprite.asm -o sprite -create-app

dis: sprite.tap
	z88dk-dis -mz80n -o 0x8000 -x sprite.map sprite_CODE.bin | less
