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

kernelname = $(notdir $(lastword $(wildcard livecd/chroot/boot/vmlinuz-*-vyatta)))
kernelversion = $(subst vmlinuz-,,$(kernelname))

define clean_installer
$(FAKEROOT) make -C pkgs/installer/build clean_netboot clean_netboot-gtk
rm -f	pkgs/installer/build/config/local \
	pkgs/installer/build/pkg-lists/netboot/local
endef

define mk_installer
@printf "%s %s %s\n" \
	KERNELNAME = $(kernelname) \
	KERNELVERSION = $(kernelversion) \
	VERSIONED_SYSTEM_MAP = t \
	PRESEED = boot/x86/vyatta_preseed.cfg \
	SPLASH_RLE = boot/x86/pics/vyatta.rle \
	EXTRAFILES += usr/share/graphics/logo_debian.png \
	EXTRAFILES += usr/share/themes/vyatta/gtk-2.0/gtkrc \
	> pkgs/installer/build/config/local
@printf "%s\n" \
	'# kvm-qemu' \
	'ata-modules-$${kernel:Version}' \
	'sata-modules-$${kernel:Version}' \
	'scsi-modules-$${kernel:Version}' \
	'scsi-core-modules-$${kernel:Version}' \
	'cdrom-core-modules-$${kernel:Version}' \
	'usb-storage-modules-$${kernel:Version}' \
	'fat-modules-$${kernel:Version}' \
	'ext3-modules-$${kernel:Version}' \
	'' \
	'# serial console' \
	'serial-modules-$${kernel:Version}' \
	> pkgs/installer/build/pkg-lists/netboot/local
$(FAKEROOT) make -C pkgs/installer/build \
	SECOPTS="--allow-unauthenticated --force-yes" \
	CONSOLE="console=ttyS0 DEBIAN_FRONTEND=text" \
	build_netboot
$(FAKEROOT) make -C pkgs/installer/build \
	SECOPTS="--allow-unauthenticated --force-yes" \
	CONSOLE="theme=vyatta" \
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
