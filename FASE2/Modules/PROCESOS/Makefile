obj-m += procesos_201904013.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

# Regla por defecto para construir el módulo
all:
	make -C $(KDIR) M=$(PWD) modules

# Limpiar los archivos generados
clean:
	make -C $(KDIR) M=$(PWD) clean

# Cargar el módulo
load:
	sudo insmod procesos_201904013.ko

# Descargar el módulo
unload:
	sudo rmmod procesos_201904013

# Mostrar la salida del módulo en /proc
show:
	cat /proc/procesos_201904013
