NAME=wbinvd
PROCFILE_NAME=${NAME}
SUDO=sudo
KVER:=$(shell uname -r)

ifneq ($(KERNELRELEASE),)
	obj-m += ${NAME}.o
	CFLAGS_${NAME}.o += -DPROCFILE_NAME=\"${PROCFILE_NAME}\"
	# simple heuristic
	KVER_S:=$(subst ., ,$(KVER))
	KMAJ:=$(word 1, $(KVER_S))
	KMIN:=$(word 2, $(KVER_S))
	ifeq ($(shell expr ${KMAJ} \>= 5 \& ${KMIN} \>= 6),1)
		CFLAGS_${NAME}.o += -DHAVE_PROC_OPS
	endif

else

all:
	make -C /lib/modules/$(KVER)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(KVER)/build M=$(PWD) clean
install:
	make -C /lib/modules/$(KVER)/build M=$(PWD) modules_install
install-bdep:
	${SUDO} apt-get install -y gcc make linux-headers-$(KVER)
test: 
	${SUDO} modinfo ${NAME}.ko
	-@ 2>/dev/null ${SUDO} rmmod ${NAME}.ko || true
	${SUDO} insmod ${NAME}.ko
	${SUDO} cat /proc/${PROCFILE_NAME} | grep executed
	${SUDO} rmmod ${NAME}.ko

deb: dkms.conf
	${SUDO} dkms mkdeb -m $(NAME) -v 1.0 --source-only

endif
