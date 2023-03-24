PROJECT_NAME:=tune



all: $(PROJECT_NAME).sms

clean:
	rm -f *.bin *.map *.sms *.tap

run: all
	Gearsystem.exe $(PROJECT_NAME).sms

$(PROJECT_NAME).sms: $(PROJECT_NAME).asm
	zcc +sms -m -Ca-D_SMS $(PROJECT_NAME).asm -o $(PROJECT_NAME).bin -create-app

$(PROJECT_NAME).tap: $(PROJECT_NAME).asm
	zcc +zx -m $(PROJECT_NAME).asm -o $(PROJECT_NAME).bin -create-app
