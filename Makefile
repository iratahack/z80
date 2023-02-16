APPS:=cpc_sprite  cpc_test  gb_test  msx_test  sms_test  zxn_test zx_chibiwave

.PHONY: $(APPS) all run clean

all:
	@for d in $(APPS); do echo "Building $$d"; make -C $$d ; done

run:
	@for d in $(APPS); do echo "Building $$d"; make -C $$d run ; done

clean:
	@for d in $(APPS); do echo "Building $$d"; make -C $$d clean ; done
