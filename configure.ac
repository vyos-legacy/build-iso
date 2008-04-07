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

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# process argument variables
test "X$LH_ARCHITECTURE" = "X" && LH_ARCHITECTURE=`dpkg --print-architecture`
AC_ARG_VAR(LH_ARCHITECTURE, [default: dpkg --print-architecture])

test "X$LH_APT" = "X" && LH_APT=apt
AC_ARG_VAR(LH_APT, [default: apt])

test ! "$LH_BOOTAPPEND_LIVE" && LH_BOOTAPPEND_LIVE=""
AC_ARG_VAR(LH_BOOTAPPEND_LIVE,
	[empty by default since bypassed with custom config file])

test ! "$LH_BOOTAPPEND_INSTALL" && LH_BOOTAPPEND_INSTALL=""
AC_ARG_VAR(LH_BOOTAPPEND_INSTALL,
	[empty by default since bypassed with custom config file])

test ! "$LH_BOOTLOADER" && LH_BOOTLOADER=syslinux
AC_ARG_VAR(LH_BOOTLOADER, [default: syslinux])

test "X$LH_BOOTSTRAP" = "X" && LH_BOOTSTRAP=debootstrap
AC_ARG_VAR(LH_BOOTSTRAP, [default: debootstrap])

test "X$LH_BOOTSTRAP_FLAVOUR" = "X" && LH_BOOTSTRAP_FLAVOUR="minimal"
AC_ARG_VAR(LH_BOOTSTRAP_FLAVOUR, [default: minimal])

test "X$LH_CHROOT_FILESYSTEM" = "X" && LH_CHROOT_FILESYSTEM=squashfs
AC_ARG_VAR(LH_CHROOT_FILESYSTEM, [default: squashfs])

test "X$LH_DEBIAN_INSTALLER" = "X" && LH_DEBIAN_INSTALLER=cdrom
AC_ARG_VAR(LH_DEBIAN_INSTALLER, [default: cdrom])

test "X$LH_DEBIAN_INSTALLER_DAILY" = "X" && LH_DEBIAN_INSTALLER_DAILY=enabled
AC_ARG_VAR(LH_DEBIAN_INSTALLER_DAILY, [default: enabled])

test "X$LH_HOSTNAME" = "X" && LH_HOSTNAME=vyatta
AC_ARG_VAR(LH_HOSTNAME, [default: vyatta])

test "X$LH_INITRAMFS" = "X" && LH_INITRAMFS=live-initramfs
AC_ARG_VAR(LH_INITRAMFS, [default: live-initramfs])

test "X$LH_ISO_APPLICATION" = "X" && LH_ISO_APPLICATION="Vyatta OFR"
AC_ARG_VAR(LH_ISO_APPLICATION, [default: Vyatta OFR])

test "X$LH_ISO_PUBLISHER" = "X" && LH_ISO_PUBLISHER="Vyatta Inc.; http://www.vyatta.com/;"
AC_ARG_VAR(LH_ISO_PUBLISHER, [default: Vyatta, Inc.])

test "X$LH_ISO_VOLUME" = "X" && LH_ISO_VOLUME='Vyatta OFR'
AC_ARG_VAR(LH_ISO_VOLUME, [default: Vyatta OFR])

test "X$LH_LANGUANGE" = "X" && LH_LANGUAGE=en
AC_ARG_VAR(LH_LANGUAGE, [default: en])

test "X$LH_MEMTEST" = "X" && LH_MEMTEST=disabled
AC_ARG_VAR(LH_MEMTEST, [default: disabled])

test "X$LH_PACKAGES_LISTS" = "X" && LH_PACKAGES_LISTS=none
AC_ARG_VAR(LH_PACKAGES_LISTS, [default: none])

test "X$LH_QUIET" = "X" && LH_QUIET=enabled
AC_ARG_VAR(LH_QUIET, [default: enabled])

test "X$LH_VERBOSE" = "X" && LH_VERBOSE=disabled
AC_ARG_VAR(LH_VERBOSE, [default: disabled])

test "X$LH_SYSLINUX_CFG" = "X" && LH_SYSLINUX_CFG=d-i/isolinux/isolinux.cfg
AC_ARG_VAR(LH_SYSLINUX_CFG, [default: d-i/isolinux/isolinux.cfg])

test "X$LH_SYSLINUX_MENU" = "X" && LH_SYSLINUX_MENU=disable
AC_ARG_VAR(LH_SYSLINUX_MENU, [default: disable])

test "X$LH_SYSLINUX_SPLASH" = "X" && LH_SYSLINUX_SPLASH=
AC_ARG_VAR(LH_SYSLINUX_SPALSH, \
	[default: none, overridden with binary_local-includes])

test "X$LH_SYSLINUX_TIMEOUT" = "X" && LH_SYSLINUX_TIMEOUT=50
AC_ARG_VAR(LH_SYSLINUX_TIMEOUT, [default: 50, 1/10 seconds])

test "X$VYATTA_POOL" = "X" && \
     VYATTA_POOL="rsync://packages.vyatta.com/vyatta-dev/pool/hollywood/main"
AC_ARG_VAR(VYATTA_POOL, [default: Vyatta nightly build])

# process --with[out] arguments
AC_ARG_WITH(exclude,
[AS_HELP_STRING([--with-exclude],
  [comma separated package list to exclude from iso])])

EXCLUDE_PKGS=
for p in `echo "$with_exclude" | tr , ' '` ; do
    EXCLUDE_PKGS+=" $p"
done

AC_ARG_WITH(target-dist,
	[AS_HELP_STRING([--with-target-dist=<dist>],
	  [Target distribution (e.g., "lenny"), default to the host distribution])],
	[],
	[with_target_dist=$(lsb_release -c -s)])

if test "$with_target_dist" = "n/a"; then
  LH_DISTRIBUTION=lenny
else
  LH_DISTRIBUTION="$with_target_dist"
fi

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

AC_ARG_WITH(kernel,
[AS_HELP_STRING([--with-kernel],
  [ fetch (default) or vyatta kernel])]
[AS_HELP_STRING([--without-kernel],
  [do not fetch appropriate distro kernel])],
[],
[with_kernel=fetch])

AC_ARG_WITH(xen,
[AS_HELP_STRING([--with-xen], [Xen DomU target])])

if test X$with_xen = Xyes ; then
   use_xen=true
else
   use_xen=false
fi

AC_ARG_WITH(deb-install,
[AS_HELP_STRING([--with-deb-install],
[build Debian installer CD])])

if test "$with_deb_install" = yes ; then
   BUILD_DEB_INSTALL=yes
else
   BUILD_DEB_INSTALL=no
fi

# FIXME! fetch version from source
VYATTA_LINUX_PKG=linux-image-2.6.23-1-486-vyatta
LH_LINUX_FLAVOURS="486-vyatta"
LH_LINUX_PACKAGES=none
BUILD_PKGS=
FETCH_PKGS=

case "$LH_DISTRIBUTION" in
gutsy | hardy )
	LH_BOOTSTRAP_INCLUDE="less,gnupg,rsync"
	LH_MIRROR_BINARY="http://us.archive.ubuntu.com/ubuntu"
	LH_MIRROR_BINARY_SECURITY="http://security.ubuntu.com/ubuntu"
	LH_MIRROR_BOOTSTRAP="http://us.archive.ubuntu.com/ubuntu"
	LH_MIRROR_BOOTSTRAP_SECURITY="http://security.ubuntu.com/ubuntu"
	# FIXME! /usr/bin/lh_chroot_sources currently uses
	# LH_DISTRIBUTION/updates but the ubuntu archive is
	# LH_DISTRIBUTION-updates
	LH_SECURITY="disabled"
	LH_SECTIONS="main restricted universe multiverse"
	EXCLUDE_PKGS+=" mailx"
	EXCLUDE_PKGS+=" dash"
	EXCLUDE_PKGS+=" openhpid"
	LH_BOOTSTRAP_EXCLUDE="dhcp3-common,dhcp3-client"
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
	LH_BOOTSTRAP_INCLUDE="locales,less,initramfs-tools,libmagic1,rsync"
	EXCLUDE_PKGS+=" openhpid"
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
	LH_MIRROR_BINARY="http://packages.vyatta.com/debian"
#	LH_MIRROR_BINARY="http://ftp.us.debian.org/debian"
	LH_MIRROR_BINARY_SECURITY="http://packages.vyatta.com/debian-security"
	LH_MIRROR_BOOTSTRAP="http://packages.vyatta.com/debian"
#	LH_MIRROR_BOOTSTRAP="http://ftp.us.debian.org/debian"
	LH_MIRROR_BOOTSTRAP_SECURITY="http://packages.vyatta.com/debian-security"
	LH_SECURITY="enabled"
	LH_SECTIONS="main"
	LH_BOOTSTRAP_EXCLUDE="dhcp3-common,dhcp3-client"
	;;
esac


AC_CONFIG_FILES([Makefile livecd/mk.livecd.conf])

AC_SUBST(ARCH)
AC_SUBST(CONFIG_BUILD)
AC_SUBST(CONFIG_HOST)
AC_SUBST(CONFIG_TARGET)
AC_SUBST(MACHINE_CFLAG)
AC_SUBST(MACHINE_PREFIX)
AC_SUBST(NOSTRIP)

AC_SUBST(EXCLUDE_PKGS)

AC_SUBST(LH_APT)
AC_SUBST(LH_ARCHITECTURE)
AC_SUBST(LH_BOOTAPPEND_LIVE)
AC_SUBST(LH_BOOTAPPEND_INSTALL)
AC_SUBST(LH_BOOTLOADER)
AC_SUBST(LH_BOOTSTRAP)
AC_SUBST(LH_BOOTSTRAP_EXCLUDE)
AC_SUBST(LH_BOOTSTRAP_FLAVOUR)
AC_SUBST(LH_BOOTSTRAP_INCLUDE)
AC_SUBST(LH_CHROOT_FILESYSTEM)
AC_SUBST(LH_DEBIAN_INSTALLER)
AC_SUBST(LH_DEBIAN_INSTALLER_DAILY)
AC_SUBST(LH_DISTRIBUTION)
AC_SUBST(LH_EXPOSED_ROOT)
AC_SUBST(LH_HOSTNAME)
AC_SUBST(LH_INITRAMFS)
AC_SUBST(LH_ISO_APPLICATION)
AC_SUBST(LH_ISO_PUBLISHER)
AC_SUBST(LH_ISO_VOLUME)
AC_SUBST(LH_LANGUAGE)
AC_SUBST(LH_LINUX_PACKAGES)
AC_SUBST(LH_LINUX_FLAVOURS)
AC_SUBST(LH_MEMTEST)
AC_SUBST(LH_MIRROR_BINARY)
AC_SUBST(LH_MIRROR_BINARY_SECURITY)
AC_SUBST(LH_MIRROR_BOOTSTRAP)
AC_SUBST(LH_MIRROR_BOOTSTRAP_SECURITY)
AC_SUBST(LH_PACKAGES_LISTS)
AC_SUBST(LH_QUIET)
AC_SUBST(LH_SECTIONS)
AC_SUBST(LH_SECURITY)
AC_SUBST(LH_SYSLINUX_CFG)
AC_SUBST(LH_SYSLINUX_MENU)
AC_SUBST(LH_SYSLINUX_SPLASH)
AC_SUBST(LH_SYSLINUX_TIMEOUT)
AC_SUBST(LH_UNION_FILESYSTEM)
AC_SUBST(LH_VERBOSE)

AC_SUBST(use_xen)

AC_SUBST(VYATTA_POOL)
AC_SUBST(VYATTA_LINUX_PKG)

AC_OUTPUT

