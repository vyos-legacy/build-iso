# Process this file with autoconf to produce a configure script.
AC_PREREQ(2.59)

AC_INIT([ofr], [2.4], [vyatta-support@vyatta.com])

# Checks for programs.
AC_PROG_LN_S

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# process argument variables
test "X$LH_ARCHITECTURE" = "X" && LH_ARCHITECTURE=`dpkg --print-architecture`
AC_ARG_VAR(LH_ARCHITECTURE, [default: dpkg --print-architecture])

test "X$LH_APT" = "X" && LH_APT=aptitude
AC_ARG_VAR(LH_APT, [default: aptitude])

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

test "X$LH_HOSTNAME" = "X" && LH_HOSTNAME=vyatta
AC_ARG_VAR(LH_HOSTNAME, [default: vyatta])

test "X$LH_INITRAMFS" = "X" && LH_INITRAMFS=live-initramfs
AC_ARG_VAR(LH_INITRAMFS, [default: live-initramfs])

test "X$LH_ISO_APPLICATION" = "X" && LH_ISO_APPLICATION="Vyatta"
AC_ARG_VAR(LH_ISO_APPLICATION, [default: Vyatta])

test "X$LH_ISO_PUBLISHER" = "X" && LH_ISO_PUBLISHER="Vyatta Inc.; http://www.vyatta.com/;"
AC_ARG_VAR(LH_ISO_PUBLISHER, [default: Vyatta, Inc.])

test "X$LH_ISO_VOLUME" = "X" && LH_ISO_VOLUME='Vyatta '
AC_ARG_VAR(LH_ISO_VOLUME, [default: Vyatta])

test "X$LH_LANGUANGE" = "X" && LH_LANGUAGE=en
AC_ARG_VAR(LH_LANGUAGE, [default: en])

test "X$LH_MEMTEST" = "X" && LH_MEMTEST=disabled
AC_ARG_VAR(LH_MEMTEST, [default: disabled])

test "X$LH_PACKAGES" = "X" && LH_PACKAGES=none
AC_ARG_VAR(LH_PACKAGES, [default: none])

test "X$LH_QUIET" = "X" && LH_QUIET=enabled
AC_ARG_VAR(LH_QUIET, [default: enabled])

test "X$LH_VERBOSE" = "X" && LH_VERBOSE=disabled
AC_ARG_VAR(LH_VERBOSE, [default: disabled])

test "X$LH_SYSLINUX_CFG" = "X" && LH_SYSLINUX_CFG=templates/isolinux.cfg
AC_ARG_VAR(LH_SYSLINUX_CFG, [default: isolinux.cfg])

test "X$LH_SYSLINUX_MENU" = "X" && LH_SYSLINUX_MENU=disabled
AC_ARG_VAR(LH_SYSLINUX_MENU, [default: disabled])

test "X$LH_SYSLINUX_SPLASH" = "X" && LH_SYSLINUX_SPLASH=none
AC_ARG_VAR(LH_SYSLINUX_SPALSH, \
	[default: none, overridden with binary_local-includes])

test "X$LH_SYSLINUX_TIMEOUT" = "X" && LH_SYSLINUX_TIMEOUT=50
AC_ARG_VAR(LH_SYSLINUX_TIMEOUT, [default: 50, 1/10 seconds])

# process --with[out] arguments
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

AC_ARG_WITH(devbuild,
	[AS_HELP_STRING([--without-devbuild],
	  [disable development build])],
	[],
	[with_devbuild=yes])

if test "X$with_devbuild" = Xyes ; then
  VYATTA_DEV_BUILD=true
else
  VYATTA_DEV_BUILD=false
fi

AC_ARG_WITH(community-build,
	[AS_HELP_STRING([--with-community-build],
	  [enable community build])],
	[],
	[with_community_build=no])
if test "X$with_community_build" = Xyes ; then
  VYATTA_COMMUNITY_BUILD=true
  VYATTA_DEV_BUILD=false
else
  VYATTA_COMMUNITY_BUILD=false
fi

AC_ARG_WITH(supported-build,
	[AS_HELP_STRING([--with-supported-build],
	  [enable supported build])],
	[],
	[with_supported_build=no])
if test "X$with_supported_build" = Xyes ; then
  VYATTA_SUPPORTED_BUILD=true
  VYATTA_DEV_BUILD=false
else
  VYATTA_SUPPORTED_BUILD=false
fi

if eval "$VYATTA_DEV_BUILD"; then
  touch pkgs/.VYATTA_DEV_BUILD
else
  rm -f pkgs/.VYATTA_DEV_BUILD
fi

# build arch
BARCH=$(dpkg-architecture -qDEB_BUILD_ARCH)

# default flavor for i386 and amd64
LH_LINUX_FLAVOURS="586-vyatta"
VIRT_FLAVOUR="586-vyatta-virt"
if test X$BARCH = Xamd64; then
  LH_LINUX_FLAVOURS="amd64-vyatta"
  VIRT_FLAVOUR="amd64-vyatta-virt"
fi

# user-specified flavor
AC_ARG_WITH(with-kernel-flavor,
[AS_HELP_STRING([--with-kernel-flavor], [Build specified kernel flavor])])

if test X$with_kernel_flavor != X ; then
  LH_LINUX_FLAVOURS=$with_kernel_flavor
fi

AC_ARG_WITH(xensourcevm,
[AS_HELP_STRING([--with-xensourcevm], [Create pv VM for XenSource])])

if test X$with_xensourcevm = Xyes ; then
  # use virt flavor for xensourcevm build
  LH_LINUX_FLAVOURS=$VIRT_FLAVOUR
  create_xensourcevm=true
else
  create_xensourcevm=false
fi

BUILD_TIME=''
AC_ARG_WITH(with-build-time,
[AS_HELP_STRING([--with-build-time], [use specified build time])])
if test X$with_build_time != X; then
  BUILD_TIME=$with_build_time
fi

KERN_SUBMOD_DIR=$(pwd)/pkgs/linux-image
KERN_DEB_ARCHDEF_DIR=$KERN_SUBMOD_DIR/debian/arch
KERN_DEB_ARCH_DIR=$KERN_DEB_ARCHDEF_DIR/$BARCH

# only do these if we are building the kernel locally
if test -d $KERN_SUBMOD_DIR/debian; then
  if test ! -d $KERN_DEB_ARCH_DIR; then
    echo "Cannot build $BARCH kernel."
    exit 1
  fi

  if test ! -f $KERN_DEB_ARCH_DIR/defines.$LH_LINUX_FLAVOURS; then
    echo "Cannot build $BARCH-$LH_LINUX_FLAVOURS kernel."
    exit 1
  else
    cp -f $KERN_DEB_ARCH_DIR/defines.$LH_LINUX_FLAVOURS \
      $KERN_DEB_ARCH_DIR/defines
  fi

  # generate control file
  (
    cd $KERN_SUBMOD_DIR
    rm debian/{control,control.md5sum}
    make -f debian/rules debian/control || true
  )>&/dev/null
fi

LH_LINUX_PACKAGES=none

if test "X$VYATTA_BUILD_BRANCH" == X; then
  VYATTA_BUILD_BRANCH=$(git branch |sed -n 's/^\* \(.*\)$/\1/p')
fi

LH_SECURITY="disabled"
LH_SECTIONS="main"

AC_CONFIG_FILES([livecd/mk.livecd.conf])

AC_SUBST(ARCH)
AC_SUBST(CONFIG_BUILD)
AC_SUBST(CONFIG_HOST)
AC_SUBST(CONFIG_TARGET)
AC_SUBST(MACHINE_CFLAG)
AC_SUBST(MACHINE_PREFIX)
AC_SUBST(NOSTRIP)

AC_SUBST(LH_APT)
AC_SUBST(LH_ARCHITECTURE)
AC_SUBST(LH_BOOTAPPEND_LIVE)
AC_SUBST(LH_BOOTAPPEND_INSTALL)
AC_SUBST(LH_BOOTLOADER)
AC_SUBST(LH_BOOTSTRAP)
AC_SUBST(LH_BOOTSTRAP_FLAVOUR)
AC_SUBST(LH_CHROOT_FILESYSTEM)
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
AC_SUBST(LH_PACKAGES)
AC_SUBST(LH_QUIET)
AC_SUBST(LH_SECTIONS)
AC_SUBST(LH_SECURITY)
AC_SUBST(LH_SYSLINUX_CFG)
AC_SUBST(LH_SYSLINUX_MENU)
AC_SUBST(LH_SYSLINUX_SPLASH)
AC_SUBST(LH_SYSLINUX_TIMEOUT)
AC_SUBST(LH_UNION_FILESYSTEM)
AC_SUBST(LH_VERBOSE)

AC_SUBST(create_xensourcevm)

AC_SUBST(VYATTA_DEV_BUILD)
AC_SUBST(VYATTA_COMMUNITY_BUILD)
AC_SUBST(VYATTA_SUPPORTED_BUILD)
AC_SUBST(VYATTA_BUILD_BRANCH)
AC_SUBST(BUILD_TIME)

AC_OUTPUT
