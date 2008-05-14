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

have_linux_kernel_di := $(shell test -e pkgs/linux-kernel-di-i386-2.6/debian/rules && echo -n true)
ifeq ($(have_linux_kernel_di),true)

define clean_udebs
rm -f pkgs/*.udebs
endef

define mk_udebs
cd pkgs/linux-kernel-di-i386-2.6 ; \
$(FAKEROOT) debuild -e SOURCEDIR=../../livecd/chroot -d -us -uc
endef

endif

have_installer := $(shell test -e pkgs/installer/build/Makefile && echo -n true)
ifeq ($(have_installer),true)

define clean_installer
$(FAKEROOT) make -C pkgs/installer/build clean_netboot clean_netboot-gtk
endef

define mk_installer
$(FAKEROOT) make -C pkgs/installer/build \
	SECOPTS="--allow-unauthenticated --force-yes" \
	CONSOLE="console=ttyS0 DEBIAN_FRONTEND=text" \
	build_netboot
$(FAKEROOT) make -C pkgs/installer/build \
	SECOPTS="--allow-unauthenticated --force-yes" \
	build_netboot-gtk
endef

endif

all :
	tools/submod-mk
	$(mk_iso)

.PHONY : udebs
udebs :
	$(mk_udebs)

.PHONY : installer
installer :
	$(mk_installer)

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
	@$(clean_udebs)
	@$(clean_installer)
	@rm -rf livecd/cache/stage*

.PHONY : distclean
distclean :
	@$(MAKE) clean
	@rm -rf livecd/{cache,deb-install,deb-install.tar}
