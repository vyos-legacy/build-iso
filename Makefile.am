## Top level autoMakefile for Vyatta System Build
## Process this file with automake or autoreconf to produce Makefile.in

export MAKEFLAGS

FETCH_PKGS = @FETCH_PKGS@
BUILD_PKGS = @BUILD_PKGS@
STAMPFILE	= @STAMPFILE@
PKG_STAMPS	= @PKG_STAMPS@
VYATTA_LINUX_VERSION = 2.6.20-2
VYATTA_LINUX_FLAVOR = 486
VYATTA_LINUX_PKG = linux-image-$(VYATTA_LINUX_VERSION)-$(VYATTA_LINUX_FLAVOR)
TARGET_DIST = lenny

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
			debuild clean;; \
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
	FETCH_PKGS="$(FETCH_PKGS)" && \
	export FETCH_PKGS="$${FETCH_PKGS//kernel/$(VYATTA_LINUX_PKG)}" && \
	BUILD_PKGS="$(BUILD_PKGS)" && \
	export BUILD_PKGS="$${BUILD_PKGS//kernel/$(VYATTA_LINUX_PKG)}" && \
	export VYATTA_LINUX_VERSION="$(VYATTA_LINUX_VERSION)" && \
	export VYATTA_LINUX_FLAVOR="$(VYATTA_LINUX_FLAVOR)" && \
	export TARGET_DIST="$(TARGET_DIST)" && \
	cd livecd && fakeroot fakechroot ./mk.livecd
endef

livecd/binary.iso : $(PKG_STAMPS)
	@$(mk_iso)

.PHONY : iso.clean
iso.clean :
	@rm -rf livecd/{.stage,binary,binary.iso,chroot,config}

.PHONY : iso.cleanall
iso.cleanall : iso.clean
	@rm -rf livecd/cache

$(PKG_STAMPS) :
	@PKG_OP_ARG=$(@D).deb; $(pkg_dot_op)

.PHONY : deb-all
deb-all : $(PKG_STAMPS)

.PHONY : upload-all
upload-all : $(PKG_STAMPS)
	@export VYATTA_LINUX_PKG="$(VYATTA_LINUX_PKG)" && \
	export TARGET_DIST="$(TARGET_DIST)" && \
	./tools/pkg-upload $(BUILD_PKGS)

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

.PHONY : git-branch git-branch-av git-clean git-clean-n git-fetch git-lsmods git-merge git-pull
git-branch git-branch-av git-clean git-clean-n git-fetch git-lsmods git-merge git-pull :
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
					* ) eval "$@";; \
				esac; \
			); \
		fi; \
	done
	

