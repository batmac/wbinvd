obj-m += wbinvd.o
#CFLAGS_wbinvd.o += -DDEBUG

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

test: 
	sudo modinfo wbinvd.ko
	-@ 2>/dev/null sudo rmmod wbinvd.ko || true
	sudo insmod wbinvd.ko
	sudo cat /proc/wbinvd
	sudo rmmod wbinvd.ko
