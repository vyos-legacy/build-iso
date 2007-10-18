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

# Process with-PACKAGE arguments

# quagga 0.99.9 is available on lenny
#AC_ARG_WITH(quagga,
#	[AS_HELP_STRING([--with-quagga=fetch|yes|no (default fetch)],
#	  [Include quagga (fecth: download package)])],
#	[],
#	[with_quagga=fetch])

AC_ARG_WITH(vyatta-cfg,
	[AS_HELP_STRING([--with-vyatta-cfg=fetch|yes|no (default fetch)],
	  [Include vyatta-cfg (fecth: download package)])],
	[],
	[with_vyatta_cfg=fetch])

AC_ARG_WITH(vyatta-op,
	[AS_HELP_STRING([--with-vyatta-op=fetch|yes|no (default fetch)],
	  [Include vyatta-op (fecth: download package)])],
	[],
	[with_vyatta_op=fetch])

AC_ARG_WITH(vyatta-cfg-quagga,
	[AS_HELP_STRING([--with-vyatta-cfg-quagga=fetch|yes|no (default fetch)],
	  [Include vyatta-cfg-quagga (fecth: download package)])],
	[],
	[with_vyatta_cfg_quagga=fetch])

AC_ARG_WITH(vyatta-op-quagga,
	[AS_HELP_STRING([--with-vyatta-op-quagga=fetch|yes|no (default fetch)],
	  [Include vyatta-op-quagga (fecth: download package)])],
	[],
	[with_vyatta_op_quagga=fetch])

AC_ARG_WITH(vyatta-config-migrate,
	[AS_HELP_STRING([--with-vyatta-config-migrate=fetch|yes|no (default fetch)],
	  [Include vyatta-config-migrate (fecth: download package)])],
	[],
	[with_vyatta_config_migrate=fetch])

# kernel is always included
AC_ARG_WITH(kernel,
	[AS_HELP_STRING([--with-kernel=fetch|yes (default fetch)],
	  [Include kernel (fecth: download package)])],
	[with_kernel=yes],
	[with_kernel=fetch])

AC_ARG_WITH(all,
  [AS_HELP_STRING([--with-all],
    [build all vyatta packages locally])],
  [if test "$with_all" == "yes"; then
     with_kernel=yes;
     with_vyatta_cfg=yes;
     with_vyatta_op=yes;
     with_vyatta_cfg_quagga=yes;
     with_vyatta_op_quagga=yes;
     with_vyatta_config_migrate=yes;
   fi],
  [])

AC_ARG_WITH(target-dist,
	[AS_HELP_STRING([--with-target-dist=<dist>],
	  [Target distribution (e.g., "lenny"), default to the host distribution])],
	[],
	[with_target_dist=$(lsb_release -c -s)])

BUILD_PKGS=
FETCH_PKGS=

for pkg in kernel vyatta-op vyatta-cfg vyatta-op-quagga vyatta-cfg-quagga \
           vyatta-config-migrate
do
  npkg=${pkg//-/_}
  eval with_pkg=\$with_$npkg
  if test "$with_pkg" == fetch; then
    FETCH_PKGS+=" $pkg"
  elif test "$with_pkg" != no; then
	  BUILD_PKGS+=" $pkg"
  fi
done

TARGET_DIST="$with_target_dist"

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

AC_CONFIG_FILES([Makefile])

AC_SUBST(ARCH)
AC_SUBST(CONFIG_BUILD)
AC_SUBST(CONFIG_HOST)
AC_SUBST(CONFIG_TARGET)
AC_SUBST(MACHINE_CFLAG)
AC_SUBST(MACHINE_PREFIX)
AC_SUBST(NOSTRIP)

AC_SUBST(FETCH_PKGS)
AC_SUBST(BUILD_PKGS)
AC_SUBST(STAMPFILE)
AC_SUBST(PKG_STAMPS)
AC_SUBST(TARGET_DIST)

AC_SUBST(PKG_DOT_DEB)
AC_SUBST(PKG_DOT_CLEAN)
AC_SUBST(PKG_DOT_CONFIGURE)
AC_SUBST(PKG_DOT_CLEANPKG)
AC_SUBST(PKG_DOT_MKDIST)
AC_SUBST(PKG_DOT_MKDIST_SIGN)

AC_OUTPUT

