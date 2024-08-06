.PHONY: all clean

all: loader.aqx

clean:
	rm -rf *.bas *.aqx

loader.aqx: loader.asm loader.bas
	zcc +aquarius --no-crt $< -o $@

%.bas: %.txt
	./txt2bas.py $< $@
