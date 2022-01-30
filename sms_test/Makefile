PROJ=test
SUFFIX=.exe

.PHONY: all clean run dis

all: Gfx2Next $(PROJ).sms

%.sms: %.c vdp.asm Makefile tilesheet.nxt title2.nxt SMS_Sprites.nxt
	zcc +sms -O2 -m -o $(PROJ).bin $< vdp.asm -create-app

run: all
	blastem$(SUFFIX) -m sms test.sms

dis: all
	z88dk-dis -mz80 -x $(PROJ).map $(PROJ).bin | less

SMS_Sprites.nxt: SMS_Sprites.png Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -map-none -tile-y -pal-bgr222 -tile-planar4 $<

tilesheet.nxt: tilesheet.png Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -map-none -pal-bgr222 -tile-planar4 $<

title2.nxt: title2.png Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -map-sms -pal-bgr222 -tile-nomirror -tile-planar4 $<

Gfx2Next:
	git clone --depth=1 https://github.com/headkaze/Gfx2Next.git

Gfx2Next/bin/gfx2next: Gfx2Next
	make -C Gfx2Next

clean:
	rm -f *.map *.bin *.sms *.nxp *.nxt *.nxm
