#!/usr/bin/make
## Top level Makefile for Vyatta System Build

export MAKEFLAGS

UID := $(shell id -u)
ifneq ($(UID),0)
FAKEROOT = fakeroot
FAKEPERMISSIONS = -i .permissions -s .permissions
FAKECHROOT = fakechroot
endif

define mk_iso
@rm -rf livecd/.lock livecd/.permissions
cd livecd && $(FAKEROOT) $(FAKEPERMISSIONS) $(FAKECHROOT) ./mk.livecd
endef

all :
	tools/submod-mk
	$(mk_iso)

.PHONY : iso
iso :
	$(mk_iso)

.PHONY : mostlyclean
mostlyclean :
	@for m in proc-live sysfs-live devpts-live ; do \
		if grep -q $$m /proc/mounts ; then umount $$m ; fi \
	 done
	@rm -rf livecd/{.permissions,.stage,binary,*.iso,chroot,config,.lock}
	@ipcs -q | awk '{print $$2}' | egrep [0-9] \
	 	| xargs -L 1 ipcrm -q >& /dev/null || /bin/true

.PHONY : clean
clean :
	@$(MAKE) mostlyclean
	@tools/submod-clean
	@rm -rf livecd/cache/stage*

.PHONY : distclean
distclean :
	@$(MAKE) clean
	@rm -rf livecd/{cache,deb-install,deb-install.tar}
