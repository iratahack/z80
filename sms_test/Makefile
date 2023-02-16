ifeq ($(OS),Windows_NT)
SUFFIX=.exe
else
SUFFIX=
endif

PROJ:=test

CC:=zcc
AS:=zcc
LD:=zcc

ASFLAGS:=
CFLAGS:=-O2 -Wall
LDFLAGS:=-m
TARGET?= +sms
ASMSRC:=$(wildcard *.asm)
CSRC:=$(wildcard *.c)
OBJS:=$(CSRC:.c=.o) $(ASMSRC:.asm=.o)

.PHONY: all clean run dis
.PRECIOUS: %.o

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

ifeq (,$(findstring $(MAKECMDGOALS),clean))
%.d: %.asm
	@./mkdep.sh $< > $@
endif

SMS_Sprites.nxt: SMS_Sprites.png Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -map-none -tile-y -pal-none -tile-planar4 $<

SMS_Sprites.nxp: SMS_Sprites.png Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -tile-none -map-none -tile-y -pal-bgr222 $<

tilesheet.nxt: tilesheet.png Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -map-none -pal-none -tile-planar4 $<

tilesheet.nxp: tilesheet.png Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -tile-none -map-none -pal-bgr222 $<

title2.nxt: title2.png Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -map-sms -pal-none -tile-nomirror -tile-planar4 $<

title2.nxp: title2.png Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -map-none -tile-none -pal-bgr222 $<

levels.nxm: levels.tmx Gfx2Next/bin/gfx2next$(SUFFIX)
	./Gfx2Next/bin/gfx2next -tiled -pal-none -tile-none -tiled-blank=11 $<

Gfx2Next/bin/gfx2next$(SUFFIX): Gfx2Next
	make -C Gfx2Next CC=clang

Gfx2Next:
	git clone --depth=1 https://github.com/headkaze/Gfx2Next.git

clean:
	rm -f *.[od] *.map *.bin *.sms *.nxp *.nxt *.nxm

-include $(ASMSRC:.asm=.d)
