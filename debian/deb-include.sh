#!/bin/bash
#
# $Id$
#
# Debian packaging script - include
#

function make_package {
    # debian package control files
    for f in preinst postinst conffiles prerm postrm; do
        if [ -f  $DEB_PCK_NAME.$f ]; then
            cp $DEB_PCK_NAME.$f $DEBIAN_BASE/DEBIAN/$f
        fi
    done

    for f in $REMOVE_FILES_WITH_EXT; do
        # remove files with specified extension
        `find $DEBIAN_BASE -path "*.$f" | xargs rm -f > /dev/null`
    done

    # remove svn folders
    `find $DEBIAN_BASE -path "*.svn" | xargs rm -rf $1 > /dev/null`

    # MD5 sum
    `find $DEBIAN_BASE -type f | grep -v "DEBIAN" | xargs md5sum | sed -e "s/pkg\/$DEB_PCK_NAME//" >> $DEBIAN_BASE/DEBIAN/md5sum`

    SIZEDU=`du -sk "$DEBIAN_BASE" | awk '{ print $1}'`
    SIZEDIR=`find "$DEBIAN_BASE" -type d | wc | awk '{print $1}'`
    SIZE=$[ $SIZEDU - $SIZEDIR ]
    VERSION=${VERSION:=`cat "$DEB_PCK_NAME".version`}-r${SVNVERSION}

    sed -e "s/__VERSION__/$VERSION/" \
        -e "s/__PACKAGE__/$DEB_PCK_NAME/" \
        -e "s/__MAINTAINER__/$MAINTAINER/" \
        -e "s/__SVNVERSION__/$SVNVERSION/" \
        -e "s/__SIZE__/$SIZE/" \
        $DEB_PCK_NAME.control > pkg/$DEB_PCK_NAME/DEBIAN/control

    # make .deb package and rename it to proper name
    dpkg --build $DEBIAN_BASE
    dpkg-name -o $DEBIAN_BASE.deb
    rm -r $DEBIAN_BASE
}
