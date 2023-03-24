PROJECT_NAME:=tune



all:
	zcc +sms -m -Ca-D_SMS $(PROJECT_NAME).asm -o $(PROJECT_NAME).bin -create-app

#all:
#	zcc +zx -m tune.asm -o tune.bin -create-app

#run: all
#	fuse $(PROJECT_NAME).tap

clean:
	rm -f *.bin *.map *.sms

run: all
	Gearsystem.exe $(PROJECT_NAME).sms
