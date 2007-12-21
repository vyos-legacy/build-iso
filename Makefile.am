## Top level autoMakefile for Vyatta System Build
## Process this file with automake or autoreconf to produce Makefile.in

export MAKEFLAGS

BUILD_PKGS	 = @BUILD_PKGS@
EXCLUDE_PKGS	 = @EXCLUDE_PKGS@
FETCH_PKGS	 = @FETCH_PKGS@
STAMPFILE	 = @STAMPFILE@
PKG_STAMPS	 = @PKG_STAMPS@
VYATTA_LINUX_PKG = @VYATTA_LINUX_PKG@

op_hyphen_all	 = configure-all
op_hyphen_all	+= clean-all
op_hyphen_all	+= cleanpkg-all
op_hyphen_all	+= mkdist-all
op_hyphen_all	+= mkdist_sign-all

.PHONY : all
all: livecd/binary.iso

# env var PKG_OP_ARG: target name.
# XXX kernel.configure will fail (no target).
define pkg_dot_op
	( \
	OP=$${PKG_OP_ARG##*.} ; \
	PKG=$${PKG_OP_ARG%.*} ; \
	cd $$PKG/$$PKG && \
	case "$$OP" in \
		deb) \
			debuild -i -uc -us -b -nc && \
			touch ../$(STAMPFILE);; \
		clean) \
			debuild clean && \
			rm -f ../*.deb ../$(STAMPFILE);; \
		cleanpkg) \
			rm -f ../*.deb ../$(STAMPFILE);; \
		configure) \
			$(MAKE) -f debian/rules configure;; \
		mkdist) \
			git-buildpackage -uc -us && \
			touch ../$(STAMPFILE);; \
		mkdist_sign) \
			if [ -n "$$VYATTA_DIST_KEY_ID" ]; then \
				git-buildpackage -k\'$$VYATTA_DIST_KEY_ID\'; \
			else \
				git-buildpackage; \
			fi && \
			touch ../$(STAMPFILE);; \
		*) \
			echo nothing to do for $$PKG_OP_ARG.;; \
	esac ; \
	cd ../..; \
	)
endef

define mk_iso
	cd livecd ; \
	if [ `id -u` -eq 0 ] ; then \
		./mk.livecd ; \
	else \
		touch .permissions ; \
		fakeroot -i .permissions -s .permissions fakechroot \
			./mk.livecd ; \
	fi
endef

livecd/binary.iso : $(PKG_STAMPS)
	@$(mk_iso)

.PHONY : iso.fast
iso.fast : $(PKG_STAMPS)
	@export ISO_FAST=yes; $(mk_iso)

.PHONY : iso.clean
iso.clean :
	@rm -rf livecd/{.permissions,.stage,binary,binary.iso,chroot,config,.lock,deb-install,deb-install.iso}

.PHONY : iso.cleanstage
iso.cleanstage : iso.clean
	@rm -rf livecd/cache/stage*

.PHONY : iso.cleanmsgq
iso.cleanmsgq :
	@ipcs -q | awk '{print $$2}' | egrep [0-9] \
	 	| xargs -L 1 ipcrm -q >& /dev/null || /bin/true

.PHONY : iso.cleanall
iso.cleanall : iso.cleanstage iso.cleanmsgq iso.clean
	@rm -rf livecd/cache

$(PKG_STAMPS) :
	@PKG_OP_ARG=$(@D).deb; $(pkg_dot_op)

.PHONY : deb-all
deb-all : $(PKG_STAMPS)

.PHONY : upload-all
upload-all : $(PKG_STAMPS)
	@export VYATTA_LINUX_PKG="$(VYATTA_LINUX_PKG)" ;\
	./tools/pkg-upload `git-branch|grep '^\*'|sed 's/..//'` $(BUILD_PKGS)

.PHONY : $(op_hyphen_all)
$(op_hyphen_all) :
	@OP_ALL=$@ ; OP=$${OP_ALL%-all} ; \
	for pkg in $(BUILD_PKGS); do \
		PKG_OP_ARG=$$pkg.$$OP; \
		$(pkg_dot_op) || exit $$?; \
	done

.PHONY : @PKG_DOT_DEB@ @PKG_DOT_CLEAN@ @PKG_DOT_CONFIGURE@ @PKG_DOT_CLEANPKG@ @PKG_DOT_MKDIST@ @PKG_DOT_MKDIST_SIGN@
@PKG_DOT_DEB@ @PKG_DOT_CLEAN@ @PKG_DOT_CONFIGURE@ @PKG_DOT_CLEANPKG@ @PKG_DOT_MKDIST@ @PKG_DOT_MKDIST_SIGN@ :
	@PKG_OP_ARG=$@; $(pkg_dot_op)

.PHONY : git-branch git-branch-av git-clean git-clean-n git-fetch git-lsmods git-merge git-pull git-status git-push git-diff git-diff-cached
git-branch git-branch-av git-clean git-clean-n git-fetch git-lsmods git-merge git-pull git-status git-push git-diff git-diff-cached:
	@for g in ./.git */*/.git; do \
		d=$${g/\/.git/}; \
		if [ -d "$$d" ]; then \
			echo ========= $${d/./\/} =============; \
			( \
				cd "$$d"; \
			 	case "$@" in \
					git-branch-av ) eval "git-branch -a -v";; \
					git-clean-n ) eval "git-clean -n";; \
					git-lsmods ) eval "git-ls-files -m";; \
					git-fetch )	git-fetch -q 2>/dev/null; \
							branch=`git-branch|grep '^\* '|sed 's/..//'`; \
							git-branch -a -v|grep "$$branch[ 	]"; \
							;; \
					git-diff-cached )	eval "git-diff --cached";; \
					* ) eval "$@";; \
				esac; \
			); \
		fi; \
	done || true
