
.PHONY: all clean

all: test.gb

%.gb: %.c
	zcc +gb $< -o $@ -create-app -DGB

clean:
	rm -f *.bin *.gb
