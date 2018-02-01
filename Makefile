NAME=wbinvd
PROCFILE_NAME=${NAME}
SUDO=sudo
obj-m += ${NAME}.o
CFLAGS_${NAME}.o += -DPROCFILE_NAME=\"${PROCFILE_NAME}\"

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

install-bdep:
	${SUDO} apt-get install build-essential linux-headers-$(shell uname -r)
test: 
	${SUDO} modinfo ${NAME}.ko
	-@ 2>/dev/null ${SUDO} rmmod ${NAME}.ko || true
	${SUDO} insmod ${NAME}.ko
	${SUDO} cat /proc/${PROCFILE_NAME}
	${SUDO} rmmod ${NAME}.ko
