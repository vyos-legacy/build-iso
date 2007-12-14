# Process this file with autoconf to produce a configure script.
AC_PREREQ(2.59)

AC_INIT([ofr], [2.4], [vyatta-support@vyatta.com])

AC_CONFIG_AUX_DIR([config])
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([gnu no-dist-gzip dist-bzip2 subdir-objects])

AC_PREFIX_DEFAULT([/opt/vyatta])

# Checks for programs.
AC_PROG_LN_S
AC_PROG_CC
AM_PROG_AS
AM_PROG_CC_C_O
AC_PROG_LIBTOOL
AC_PROG_LEX
AC_PROG_YACC

# Checks for libraries.
AC_CHECK_LIB(crypt, crypt, [ LIBS="$LIBS -lcrypt" ])

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# process argument variables
test "X$LH_APT" = "X" && LH_APT=apt
AC_ARG_VAR(LH_APT, [default: apt])

test "X$LH_BOOTAPPEND_LIVE" = "X" && \
     LH_BOOTAPPEND_LIVE="console=tty0 console=ttyS0,9600 noautologin nonetworking nouser"
AC_ARG_VAR(LH_BOOTAPPEND_LIVE, [default: console=tty0 console=ttyS0,9600 noautologin nonetworking nouser])

test "X$LH_BOOTLOADER" = "X" && LH_BOOTLOADER=grub
AC_ARG_VAR(LH_BOOTLOADER, [default: grub])

test "X$LH_BOOTSTRAP" = "X" && LH_BOOTSTRAP=debootstrap
AC_ARG_VAR(LH_BOOTSTRAP, [default: debootstrap])

test "X$LH_BOOTSTRAP_FLAVOUR" = "X" && LH_BOOTSTRAP_FLAVOUR="minimal"
AC_ARG_VAR(LH_BOOTSTRAP_FLAVOUR, [default: minimal])

test "X$LH_CHROOT_FILESYSTEM" = "X" && LH_CHROOT_FILESYSTEM=squashfs
AC_ARG_VAR(LH_CHROOT_FILESYSTEM, [default: squashfs])

test "X$LH_HOSTNAME" = "X" && LH_HOSTNAME=vyatta
AC_ARG_VAR(LH_HOSTNAME, [default: vyatta])

test "X$LH_INITRAMFS" = "X" && LH_INITRAMFS=live-initramfs
AC_ARG_VAR(LH_INITRAMFS, [default: live-initramfs])

test "X$LH_ISO_APPLICATION" = "X" && LH_ISO_APPLICATION="Vyatta OFR"
AC_ARG_VAR(LH_ISO_APPLICATION, [default: Vyatta OFR])

test "X$LH_ISO_PUBLISHER" = "X" && LH_ISO_PUBLISHER="Vyatta Inc.; http://www.vyatta.com/;"
AC_ARG_VAR(LH_ISO_PUBLISHER, [default: Vyatta, Inc.])

test "X$LH_ISO_VOLUME" = "X" && LH_ISO_VOLUME='Vyatta OFR Live $(date +%Y%m%d-%H:%M)'
AC_ARG_VAR(LH_ISO_VOLUME, [default: build date])

test "X$LH_MEMTEST" = "X" && LH_MEMTEST=disabled
AC_ARG_VAR(LH_MEMTEST, [default: disabled])

test "X$LH_PACKAGES_LISTS" = "X" && LH_PACKAGES_LISTS=none
AC_ARG_VAR(LH_PACKAGES_LISTS, [default: none])

# process --with[out] arguments
AC_ARG_WITH(target-dist,
	[AS_HELP_STRING([--with-target-dist=<dist>],
	  [Target distribution (e.g., "lenny"), default to the host distribution])],
	[],
	[with_target_dist=$(lsb_release -c -s)])

LH_DISTRIBUTION="$with_target_dist"

# quagga 0.99.9 is available on lenny
# AC_ARG_WITH(quagga,
# [AS_HELP_STRING([--with-quagga],
#   [ fetch (default) or build named package])]
# [AS_HELP_STRING([--without-quagga],
#   [exclude named package])],
# [],
# [with_quagga=fetch])

AC_ARG_WITH(aufs,
[AS_HELP_STRING([--with-aufs],
  [use aufs instead of unionfs])])

if test "X$with_aufs" = Xyes ; then
	LH_UNION_FILESYSTEM=aufs
else
	LH_UNION_FILESYSTEM=unionfs
fi

AC_ARG_WITH(exposed-root,
[AS_HELP_STRING([--with-exposed-root], [enable livecd exposed root feature])])

if test X$with_exposed_root = Xyes ; then
   LH_EXPOSED_ROOT=enabled
else
   LH_EXPOSED_ROOT=disabled
fi

AC_ARG_WITH(vyatta-op,
[AS_HELP_STRING([--with-vyatta-op],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-op],
  [exclude named package])],
[],
[with_vyatta_op=fetch])

AC_ARG_WITH(vyatta-op-quagga,
[AS_HELP_STRING([--with-vyatta-op-quagga],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-op-quagga],
  [exclude named package])],
[],
[with_vyatta_op_quagga=fetch])

AC_ARG_WITH(any-vyatta-cfg,
[AS_HELP_STRING([--without-any-vyatta-cfg],
  [exclude all vyatta config packages])])

if test X$with_any_vyatta_cfg = Xno ; then
    default_vyatta_cfg=no
else
    default_vyatta_cfg=fetch ;
fi

AC_ARG_WITH(vyatta-cfg,
[AS_HELP_STRING([--with-vyatta-cfg],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-cfg],
  [exclude named package])],
[],
[with_vyatta_cfg=$default_vyatta_cfg])

AC_ARG_WITH(vyatta-cfg-quagga,
[AS_HELP_STRING([--with-vyatta-cfg-quagga],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-cfg-quagga],
  [exclude named package])],
[],
[with_vyatta_cfg_quagga=$default_vyatta_cfg])

AC_ARG_WITH(vyatta-cfg-system,
[AS_HELP_STRING([--with-vyatta-cfg-system],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-cfg-system],
  [exclude named package])],
[],
[with_vyatta_cfg_system=$default_vyatta_cfg])

AC_ARG_WITH(vyatta-config-migrate,
[AS_HELP_STRING([--with-vyatta-config-migrate],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-config-migrate],
  [exclude named package])],
[],
[with_vyatta_config_migrate=$default_vyatta_cfg])

AC_ARG_WITH(vyatta-bash,
[AS_HELP_STRING([--with-vyatta-bash],
  [ fetch (default) or build named package])]
[AS_HELP_STRING([--without-vyatta-bash],
  [exclude named package])],
[],
[with_vyatta_bash=fetch])

AC_ARG_WITH(kernel,
[AS_HELP_STRING([--with-kernel],
  [ fetch (default) or vyatta kernel])]
[AS_HELP_STRING([--without-kernel],
  [fetch appropriate distro kernel])],
[],
[with_kernel=fetch])

AC_ARG_WITH(xen,
[AS_HELP_STRING([--with-xen], [Xen DomU target])])

if test X$with_xen = Xyes ; then
   use_xen=true
else
   use_xen=false
fi

# with all vyatta packages (except kernel)
AC_ARG_WITH(all,
[AS_HELP_STRING([--with-all],
  [build all vyatta packages locally (except kernel)])],
[ if test X$with_all = Xyes ; then
     with_vyatta_cfg=yes;
     with_vyatta_op=yes;
     with_vyatta_cfg_quagga=yes;
     with_vyatta_op_quagga=yes;
     with_vyatta_cfg_system=yes;
     with_vyatta_config_migrate=yes;
     with_vyatta_bash=yes;
  fi ],
[])

# FIXME! fetch version from source
VYATTA_LINUX_PKG=linux-image-2.6.23-1-486-vyatta
LH_LINUX_FLAVOURS="486-vyatta"
LH_LINUX_PACKAGES=none
BUILD_PKGS=
EXCLUDE_PKGS=
FETCH_PKGS=

for pkg in kernel vyatta-op vyatta-cfg vyatta-op-quagga vyatta-cfg-quagga \
           vyatta-config-migrate vyatta-cfg-system vyatta-bash
do
  npkg=${pkg//-/_}
  eval with_pkg=\$with_$npkg
  if test "$with_pkg" = fetch; then
    FETCH_PKGS+=" $pkg"
  elif test "$with_pkg" != no; then
    BUILD_PKGS+=" $pkg"
  fi
done

case "$LH_DISTRIBUTION" in
gutsy | hardy )
	LH_BOOTSTRAP_INCLUDE="less,gnupg"
	LH_MIRROR_BINARY="http://us.archive.ubuntu.com/ubuntu/"
	LH_MIRROR_BINARY_SECURITY="http://security.ubuntu.com/ubuntu/"
	LH_MIRROR_BOOTSTRAP="http://us.archive.ubuntu.com/ubuntu/"
	LH_MIRROR_BOOTSTRAP_SECURITY="http://security.ubuntu.com/ubuntu/"
	# FIXME! /usr/bin/lh_chroot_sources currently uses
	# LH_DISTRIBUTION/updates but the ubuntu archive is
	# LH_DISTRIBUTION-updates
	LH_SECURITY="disabled"
	LH_SECTIONS="main restricted universe multiverse"
	EXCLUDE_PKGS+=" mailx"
	EXCLUDE_PKGS+=" dash"
# FIXME! can no longer exlude exim like this...
#	EXCLUDE_PKGS+=" exim4-daemon-light"
#	EXCLUDE_PKGS+=" exim4-config"
#	EXCLUDE_PKGS+=" exim4-base"
#	EXCLUDE_PKGS+=" exim4"
#	EXCLUDE_PKGS+=" ubuntu-minimal"
	if eval "$use_xen" ; then
	    VYATTA_LINUX_PKG=""
	    LH_LINUX_PACKAGES=linux-image
	    LH_LINUX_FLAVOURS="xen"
	    LH_BOOTSTRAP_INCLUDE+=",libc6-xen"
	    EXCLUDE_PKGS+=" alsa-base"
	    EXCLUDE_PKGS+=" alsa-utils"
	    EXCLUDE_PKGS+=" console-setup"
	    EXCLUDE_PKGS+=" console-terminus"
	    EXCLUDE_PKGS+=" console-tools"
	    EXCLUDE_PKGS+=" pciutils"
	    EXCLUDE_PKGS+=" pcmciautils"
	    EXCLUDE_PKGS+=" wireless-tools"
	    EXCLUDE_PKGS+=" wpasupplicant"
	elif test X$with_kernel = Xno ; then
	    VYATTA_LINUX_PKG=""
	    LH_LINUX_PACKAGES=linux-image
	    LH_LINUX_FLAVOURS="server"
	fi
	;;
* )
	LH_BOOTSTRAP_INCLUDE="locales,less,initramfs-tools,libmagic1"
	if test X$with_kernel = Xno ; then
	    VYATTA_LINUX_PKG=""
	    LH_LINUX_PACKAGES=linux-image
	    LH_LINUX_FLAVOURS=
	    # 486 686 686-bigmem amd64
	    for f in 686 ; do
		LH_LINUX_FLAVOURS+=" $f"
		test X$LH_CHROOT_FILESYSTEM = Xsquashfs && \
		    FETCH_PKGS+=" squashfs-modules-2.6-$f"
		test X$LH_UNION_FILESYSTEM = Xaufs && \
		    FETCH_PKGS+=" aufs-modules-2.6-$f"
	    done
	    test X$LH_CHROOT_FILESYSTEM = Xsquashfs && \
		FETCH_PKGS+=" squashfs-tools"
	fi
	LH_MIRROR_BINARY="http://sydney.vyatta.com/debian/"
	LH_MIRROR_BINARY_SECURITY="http://sydney.vyatta.com/debian-security/"
	LH_MIRROR_BOOTSTRAP="http://sydney.vyatta.com/debian/"
	LH_MIRROR_BOOTSTRAP_SECURITY="http://sydney.vyatta.com/debian-security/"
	LH_SECURITY="enabled"
	LH_SECTIONS="main"
	EXCLUDE_PKGS+=" exim4-daemon-light"
	EXCLUDE_PKGS+=" exim4-config"
	EXCLUDE_PKGS+=" exim4-base"
	EXCLUDE_PKGS+=" exim4"
	EXCLUDE_PKGS+=" mailx"
	EXCLUDE_PKGS+=" mail-transport-agent"
	;;
esac

for pkg in $BUILD_PKGS; do
  PKG_DOT_DEB+=" ${pkg}.deb"
  PKG_DOT_CLEAN+=" ${pkg}.clean"
  PKG_DOT_CONFIGURE+=" ${pkg}.configure"
  PKG_DOT_CLEANPKG+=" ${pkg}.cleanpkg"
  PKG_DOT_MKDIST+=" ${pkg}.mkdist"
  PKG_DOT_MKDIST_SIGN+=" ${pkg}.mkdist_sign"
done

test -z "$STAMPFILE" && STAMPFILE=.pkg_stamp

for pkg in $BUILD_PKGS; do
  PKG_STAMPS+=" ${pkg}/${STAMPFILE}"
done

AC_CONFIG_COMMANDS([configure_clone_packages], [tools/pkg-clone $build_pkgs],
                   [build_pkgs="$BUILD_PKGS"])

AC_CONFIG_FILES([Makefile livecd/mk.livecd.conf])

AC_SUBST(ARCH)
AC_SUBST(CONFIG_BUILD)
AC_SUBST(CONFIG_HOST)
AC_SUBST(CONFIG_TARGET)
AC_SUBST(MACHINE_CFLAG)
AC_SUBST(MACHINE_PREFIX)
AC_SUBST(NOSTRIP)

AC_SUBST(FETCH_PKGS)
AC_SUBST(EXCLUDE_PKGS)
AC_SUBST(BUILD_PKGS)
AC_SUBST(STAMPFILE)
AC_SUBST(PKG_STAMPS)

AC_SUBST(LH_APT)
AC_SUBST(LH_BOOTAPPEND_LIVE)
AC_SUBST(LH_BOOTLOADER)
AC_SUBST(LH_BOOTSTRAP)
AC_SUBST(LH_BOOTSTRAP_EXCLUDE)
AC_SUBST(LH_BOOTSTRAP_FLAVOUR)
AC_SUBST(LH_BOOTSTRAP_INCLUDE)
AC_SUBST(LH_CHROOT_FILESYSTEM)
AC_SUBST(LH_DISTRIBUTION)
AC_SUBST(LH_EXPOSED_ROOT)
AC_SUBST(LH_HOSTNAME)
AC_SUBST(LH_INITRAMFS)
AC_SUBST(LH_ISO_APPLICATION)
AC_SUBST(LH_ISO_PUBLISHER)
AC_SUBST(LH_ISO_VOLUME)
AC_SUBST(LH_LINUX_PACKAGES)
AC_SUBST(LH_LINUX_FLAVOURS)
AC_SUBST(LH_MEMTEST)
AC_SUBST(LH_MIRROR_BINARY)
AC_SUBST(LH_MIRROR_BINARY_SECURITY)
AC_SUBST(LH_MIRROR_BOOTSTRAP)
AC_SUBST(LH_MIRROR_BOOTSTRAP_SECURITY)
AC_SUBST(LH_SECURITY)
AC_SUBST(LH_PACKAGES_LISTS)
AC_SUBST(LH_SECTIONS)
AC_SUBST(LH_UNION_FILESYSTEM)

AC_SUBST(PKG_DOT_DEB)
AC_SUBST(PKG_DOT_CLEAN)
AC_SUBST(PKG_DOT_CONFIGURE)
AC_SUBST(PKG_DOT_CLEANPKG)
AC_SUBST(PKG_DOT_MKDIST)
AC_SUBST(PKG_DOT_MKDIST_SIGN)

AC_SUBST(use_xen)

AC_SUBST(VYATTA_LINUX_PKG)

AC_OUTPUT

