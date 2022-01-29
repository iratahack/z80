PROJ=test
SUFFIX=.exe

.PHONY: all clean run dis

all: $(PROJ).sms

%.sms: %.c vdp.asm Makefile tilesheet.nxt title2.nxt SMS_Sprites.nxt
	zcc +sms -O2 -m -o $(PROJ).bin $< vdp.asm -create-app

run: all
	blastem$(SUFFIX) -m sms test.sms

dis: all
	z88dk-dis -mz80 -x $(PROJ).map $(PROJ).bin | less

SMS_Sprites.nxt: SMS_Sprites.png
	gfx2next -map-none -tile-y -pal-bgr222 -tile-planar4 $<

tilesheet.nxt: tilesheet.png
	gfx2next -map-none -pal-bgr222 -tile-planar4 $<

title2.nxt: title2.png
	gfx2next -map-sms -pal-bgr222 -tile-nomirror -tile-planar4 $<

clean:
	rm -f *.map *.bin *.sms *.nxp *.nxt *.nxm
