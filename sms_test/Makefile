PROJ=test
SUFFIX=.exe

.PHONY: all clean run dis

all: $(PROJ).sms

%.sms: %.c tiles.inc tilemap.inc title_pal.inc tilesheet.nxp tilesheet.nxt
	zcc +sms -m -o $(PROJ).bin $< -create-app

run: all
	blastem$(SUFFIX) -m sms test.sms

dis: all
	z88dk-dis -mz80 -x $(PROJ).map $(PROJ).bin | less


clean:
	rm -f *.map *.bin *.sms
