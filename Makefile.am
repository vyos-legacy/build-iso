## Top level autoMakefile for Vyatta System Build
## Process this file with automake or autoreconf to produce Makefile.in

export MAKEFLAGS
export ISO_FAST

# build missing .deb for updated pkgs
# (i.e. those that have had: git-submodule update pkgs/PKG)
define debuild_pkgs
    shopt -s nullglob ; \
    declare -a debs ; \
    for debian in pkgs/*/debian ; do \
	pkg=$${debian%/*} ; \
	debs=( $${pkg}_*.deb ) ; \
	if [ $${#debs[@]} -eq 0 ] ; then \
	    echo P: \($${pkg}\) debuild... ; \
	    ( cd $${pkg} ; debuild -i -b -nc -uc -us ) ; \
	fi ; \
    done
endef

define op_pkg
    if [ -z "$(PKG)" ] ; then \
	echo E: must set PKG make variable ; \
	echo E: \(i.e. \"make PKG=foo OP-pkg\"\) ; \
	false ; \
    elif [ ! -d pkgs/$(PKG) ] ; then \
	echo E: no such PKG: $(PKG) ; \
	false ; \
    elif [ ! -d pkgs/$(PKG)/debian ] ; then \
	echo E: you must: git-submodule update pkg/$(PKG) ; \
	false ; \
    else \
	echo P: \(pkgs/$(PKG)\) $$op... ; \
	cd pkgs/$(PKG) ; $$op ; \
    fi
endef

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
	@$(debuild_pkgs)
	@$(mk_iso)

.PHONY : all-debs
all-debs :
	@$(debuild_pkgs)

.PHONY : iso
iso :
	@$(mk_iso)

.PHONY : debuild-pkg
build-pkg :
	@op="debuild -i -b -nc -uc -us" ; $(op_pkg)

.PHONY : build-spkg
build-spkg :
	@op="git-buildpackage -nc -uc -us" ; $(op_pkg)

.PHONY : build-signed-pkg
build-signed-pkg :
	@op="git-buildpackage -nc" ; $(op_pkg)

.PHONY : clean-pkg
clean-pkg :
	@op="debuild clean" ; $(op_pkg)
	rm -f pkgs/$(PKG)_*.{build,changes,deb,tar.gz}
	if [[ "$(PKG)" == linux-* ]] ; then rm -f pkgs/linux-*.{build,changes,deb,tar.gz} ; fi

mostlyclean-local : iso.cleanmsgq
	@if grep -q proc-live /proc/mounts ; then umount proc-live ; fi
	@if grep -q sysfs-live /proc/mounts ; then umount sysfs-live ; fi
	@rm -rf livecd/{.permissions,.stage,binary,*.iso,chroot,config,.lock,deb-install.iso}

clean-local : iso.cleanstage
	@rm -f pkgs/*.{build,changes,deb,tar.gz,udeb}
	@shopt -s nullglob ; \
	for debian in pkgs/*/debian ; do \
	    echo P: \($${debian%/*}\) debuild clean ... ; \
	  ( cd $${debian%/*} ; debuild clean ) ; \
	done

distclean-local :
	@rm -rf livecd/{cache,deb-install,deb-install.tar}

.PHONY : iso.cleanstage
iso.cleanstage :
	@rm -rf livecd/cache/stage*

.PHONY : iso.cleanmsgq
iso.cleanmsgq :
	@ipcs -q | awk '{print $$2}' | egrep [0-9] \
	 	| xargs -L 1 ipcrm -q >& /dev/null || /bin/true

.PHONY : git-branch git-branch-av git-clean git-clean-n git-fetch git-lsmods git-merge git-pull git-status git-push git-diff git-diff-cached
git-branch git-branch-av git-clean git-clean-n git-fetch git-lsmods git-merge git-pull git-status git-push git-diff git-diff-cached:
	@for g in ./.git pkgs/*/.git; do \
	 d=$${g/\/.git/}; \
	 if [ -d "$$d" ]; then \
	   echo ========= $${d/./\/} =============; \
	   ( \
	     cd "$$d"; \
	     case "$@" in \
	       git-branch-av ) git-branch -a -v;; \
	       git-clean-n ) git-clean -n;; \
	       git-lsmods ) git-ls-files -m;; \
	       git-fetch ) git-fetch -q 2>/dev/null; \
	           if ! (git-status|head -3|grep '^nothing to commit' >/dev/null) ; \
	           then \
	             echo There are uncommited changes.; \
	           fi; \
	           branch=`git-branch|grep '^\* '|sed 's/..//'`; \
	           changed=`git-diff "$$branch" origin/"$$branch"|head -1`; \
	           if [ "$$changed" ]; then \
	             echo A local commit is not in the shared repo or visa versa.; \
	           fi; \
	           echo ; \
	           ;; \
	       git-diff-cached ) git-diff --cached;; \
	       * ) eval "$@";; \
	     esac; \
	   ); \
	 fi; \
	done || true

