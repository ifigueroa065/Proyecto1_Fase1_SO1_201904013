obj-m += ram_201904013.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean

load:
	sudo insmod ram_201904013.ko

unload:
	sudo rmmod ram_201904013

show:
	cat /proc/ram_201904013
