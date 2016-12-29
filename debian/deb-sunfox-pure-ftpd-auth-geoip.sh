#!/bin/sh
#
# $Id$
#
# Debian packaging script.
#

# vlozeni funkci pro vytvareni balicku
source ./deb-include.sh

DEB_PCK_NAME=sunfox-pure-ftpd-auth-geoip
MAINTAINER='Tomas Jacik <tomas.jacik@sunfox.cz>'
DEBIAN_BASE=pkg/$DEB_PCK_NAME
PROJECT_DIR=
WORK_DIR=$DEBIAN_BASE$PROJECT_DIR
SVNVERSION=`svnversion ..`

# create directories
rm -rf $DEBIAN_BASE
mkdir -p ${DEBIAN_BASE}/DEBIAN
mkdir -p ${WORK_DIR}/etc/init.d
mkdir -p ${WORK_DIR}/etc/pure-ftpd/auth
mkdir -p ${WORK_DIR}/etc/pure-ftpd/conf
mkdir -p ${WORK_DIR}/etc/pure-ftpd/db
mkdir -p ${WORK_DIR}/usr/sbin

# copy data
cp ../init.d/*	$WORK_DIR/etc/init.d/
cp ../conf/*	$WORK_DIR/etc/pure-ftpd/conf/
cp ../db/*	$WORK_DIR/etc/pure-ftpd/db/
cp ../sbin/*	$WORK_DIR/usr/sbin/
ln -s ../conf/ExtAuth $WORK_DIR/etc/pure-ftpd/auth/10ext

# change ownership and user rights
chown -R root:root $DEBIAN_BASE
chown -R root:root $WORK_DIR

# vytvoreni balicku
make_package
