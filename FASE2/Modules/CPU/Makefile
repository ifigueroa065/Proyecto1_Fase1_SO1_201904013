obj-m += cpu_201904013.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean

load:
	sudo insmod cpu_201904013.ko

unload:
	sudo rmmod cpu_201904013

show:
	cat /proc/cpu_201904013
