#!/usr/bin/make
## Top level Makefile for Vyatta System Build

export MAKEFLAGS
export NETSNMP_DONT_CHECK_VERSION=1

PACKAGE_DEBS := $(subst /debian,,$(wildcard pkgs/*/debian))
CLEAN_DEBS := $(subst pkgs/,clean-pkgs/,$(PACKAGE_DEBS))
BUILD_PKGS := $(subst pkgs/,,$(PACKAGE_DEBS))
CLEAN_PKGS := $(subst pkgs/,clean-,$(PACKAGE_DEBS))
RELEASE_PKGS := $(subst pkgs/,release-,$(PACKAGE_DEBS))

UID := $(shell id -u)
ifneq ($(UID),0)
FAKEROOT = fakeroot
FAKEPERMISSIONS = -i .permissions -s .permissions
FAKECHROOT = fakechroot
endif

define mk_iso
@v=$$(mksquashfs -version | awk '/^mksquashfs/ { print $$3 }' ) ; \
if dpkg --compare-versions $$v '<' "4.1" ; \
then echo "Need squashfs tools 4.1 (or later)"; exit 1; fi
@rm -rf livecd/.lock livecd/.permissions
cd livecd && $(FAKEROOT) $(FAKECHROOT) ./mk.livecd
endef

all : package_debuilds
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
		| xargs -L 1 ipcrm -q >/dev/null 2>&1 || /bin/true

.PHONY : clean
clean :
	@$(MAKE) mostlyclean
	@tools/submod-clean
	@rm -rf livecd/cache/stage*

.PHONY : distclean
distclean :
	@$(MAKE) clean
	@rm -rf livecd/{cache,version}

# building kernel modules depends on kernel
pkgs/open-vm-tools: pkgs/linux-image/debian/stamps/build-base

# mysterious dependency
pkgs/net-snmp: pkgs/linux-image/debian/stamps/build-base

pkgs/linux-image/debian/stamps/build-base: pkgs/linux-image

.PHONY: package_debuilds
package_debuilds: $(PACKAGE_DEBS)
	@echo DONE

.PHONY: clean_debuilds
clean_debuilds: $(CLEAN_DEBS)
	@echo DONE

.PHONY: $(PACKAGE_DEBS)
$(PACKAGE_DEBS):
	@case "$@" in pkgs/installer*|pkgs/linux-kernel-di*|"" )  true;; *) echo !!!!!$@!!!!!!!; cd $@; debuild -i -b -uc -us -nc;; esac

.PHONY: $(CLEAN_DEBS)
$(CLEAN_DEBS):
	@d=$$(echo $@ | sed 's/^clean-//'); case "$$d" in pkgs/installer*|pkgs/linux-kernel-di*|"" ) echo !!!!!$$d!!!!!!!;; *) cd $$d; debuild clean;; esac

.PHONY: $(BUILD_PKGS)
$(BUILD_PKGS):
	@cd pkgs/$@; debuild -i -b -uc -us -nc

.PHONY: $(CLEAN_PKGS)
$(CLEAN_PKGS):
	@d=$$(echo $@ | sed 's/^clean-//'); cd pkgs/$$d; debuild clean

.PHONY: $(RELEASE_PKGS)
$(RELEASE_PKGS):
	@d=$$(echo $@ | sed 's/^release-//'); cd pkgs/$$d; ../../tools/pkg-release -p

.PHONY: show_unreleased
show_unreleased:
	@./tools/show-unreleased

.PHONY: show_unreleased_all
show_unreleased_all:
	@./tools/show-unreleased -a

