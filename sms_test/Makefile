PROJ=test
SUFFIX=.exe

.PHONY: all clean run

all: $(PROJ).sms

%.sms: %.c tiles.inc tilemap.inc title_pal.inc
	zcc +sms -m -o $(PROJ).bin $< -create-app

run: all
	blastem$(SUFFIX) -m sms test.sms

clean:
	rm -f *.map *.bin *.sms
