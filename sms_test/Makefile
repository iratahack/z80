PROJ=test
SUFFIX=.exe

.PHONY: all clean run dis

all: $(PROJ).sms

%.sms: %.c vdp.asm tilesheet.nxp tilesheet.nxt title2.nxp title2.nxt title2.nxm
	zcc +sms -O2 -m -o $(PROJ).bin $< vdp.asm -create-app

run: all
	blastem$(SUFFIX) -m sms test.sms

dis: all
	z88dk-dis -mz80 -x $(PROJ).map $(PROJ).bin | less


clean:
	rm -f *.map *.bin *.sms
