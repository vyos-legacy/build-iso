## Top level autoMakefile for Vyatta System Build
## Process this file with automake or autoreconf to produce Makefile.in

export MAKEFLAGS
export ISO_FAST

define mk_iso
    cd livecd ; \
    if [ `id -u` -eq 0 ] ; then \
	./mk.livecd ; \
    else \
	touch .permissions ; \
	fakeroot -i .permissions -s .permissions fakechroot ./mk.livecd ; \
    fi
endef

all-local :
	@tools/submod-mk
	@$(mk_iso)

.PHONY : iso
iso :
	@$(mk_iso)

mostlyclean-local :
	@if grep -q proc-live /proc/mounts ; then umount proc-live ; fi
	@if grep -q sysfs-live /proc/mounts ; then umount sysfs-live ; fi
	@rm -rf livecd/{.permissions,.stage,binary,*.iso,chroot,config,.lock,deb-install.iso}
	@ipcs -q | awk '{print $$2}' | egrep [0-9] \
	 	| xargs -L 1 ipcrm -q >& /dev/null || /bin/true

clean-local :
	@tools/submod-clean
	@rm -rf livecd/cache/stage*

distclean-local :
	@rm -rf livecd/{cache,deb-install,deb-install.tar}
