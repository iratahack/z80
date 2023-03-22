



all:
	zcc +zx tune.asm -o tune.bin -create-app

run: all
	fuse tune.tap

clean:
	rm -f *.bin *.map *.tap
