PROJ:=test

CC:=zcc
AS:=zcc
LD:=zcc

ASFLAGS:=
CFLAGS:=-O2
LDFLAGS:=-m
TARGET?= +sms
ASMSRC:=$(wildcard *.asm)
CSRC:=$(wildcard *.c)
OBJS:=$(CSRC:.c=.o) $(ASMSRC:.asm=.o)

.PHONY: all clean run dis

all: Gfx2Next $(PROJ).sms

%.sms: $(OBJS) Makefile tilesheet.nxt title2.nxt SMS_Sprites.nxt levels.nxm
	@echo "Linking $@"
	@$(LD) $(TARGET) $(LDFLAGS) -o $(PROJ).bin $(OBJS) -create-app

run: all
	blastem -m sms test.sms

dis: all
	z88dk-dis -mz80 -x $(PROJ).map $(PROJ).bin | less

%.o: %.asm
	@echo "Assembling $<"
	@$(AS) $(TARGET) $(ASFLAGS) -c $<

%.o: %.c
	@echo "Compiling $<"
	@$(CC) $(TARGET) $(CFLAGS) -c $<

SMS_Sprites.nxt: SMS_Sprites.png Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -map-none -tile-y -pal-bgr222 -tile-planar4 $<

tilesheet.nxt: tilesheet.png Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -map-none -pal-bgr222 -tile-planar4 $<

title2.nxt: title2.png Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -map-sms -pal-bgr222 -tile-nomirror -tile-planar4 $<

levels.nxm: levels.tmx Gfx2Next/bin/gfx2next
	./Gfx2Next/bin/gfx2next -tiled -pal-none -tile-none -tiled-blank=11 $<

Gfx2Next:
	git clone --depth=1 https://github.com/headkaze/Gfx2Next.git

Gfx2Next/bin/gfx2next: Gfx2Next
	make -C Gfx2Next

clean:
	rm -f *.map *.bin *.sms *.nxp *.nxt *.nxm
