PROJECT_NAME=sprite

all: ${PROJECT_NAME}.bin

clean:
	rm -f *.bin *.tap *.map *.[io]

run: ${PROJECT_NAME}.tap
	zesarux --machine TBBlue --tape sprite.tap --configfile .zesaruxrc --tbblue-fast-boot-mode  --nosplash --nowelcomemessage --quickexit

sprite_BANK_2.bin: sprite.asm defines.inc tiles.inc setPorts.inc
	z88dk-asmpp -mz80n -m -b sprite.asm

${PROJECT_NAME}.bin: ${PROJECT_NAME}_BANK_2.bin
	@echo "Creating $@"
	@cp ${PROJECT_NAME}_BANK_5.bin ${PROJECT_NAME}.bin
	@dd if=/dev/null of=${PROJECT_NAME}.bin bs=1 count=1 seek=8K
	@cat ${PROJECT_NAME}_BANK_2.bin >> ${PROJECT_NAME}.bin
	@dd if=/dev/null of=${PROJECT_NAME}.bin bs=1 count=1 seek=24K
	@cat ${PROJECT_NAME}_BANK_0.bin >> ${PROJECT_NAME}.bin

sprite.tap: ${PROJECT_NAME}.bin
	./tools/zxstlc_linux -t ${PROJECT_NAME}.bin 24576 33156 -e

dis: ${PROJECT_NAME}.bin
	z88dk-dis -mz80n -o 0x6000 -x ${PROJECT_NAME}.map ${PROJECT_NAME}.bin | less
