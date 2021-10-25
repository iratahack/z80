PROJ=test

.PHONY: all clean

all: $(PROJ).gb

%.gb: %.c
	zcc +gb $< -o $@ -create-app -DGB

clean:
	rm -f *.bin *.gb

run: $(PROJ).gb
	vba -T 100 $(PROJ).gb
	