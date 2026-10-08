#!/bin/bash

set -e

 . config.sh

echo "+++ Normalize library directory permissions for ldconfig"
for d in \
	"$CHERIBSD_DESTDIR_PREPARED/lib" \
	"$CHERIBSD_DESTDIR_PREPARED/usr/lib" \
	"$CHERIBSD_DESTDIR_PREPARED/usr/lib/compat" \
	"$CHERIBSD_DESTDIR_PREPARED/usr/lib64"
do
	if [[ -d "$d" ]] ; then
		chmod 0755 "$d"
	fi
done

echo "+++ Create rootfs ffs/ufs image"
if command -v fakeroot >/dev/null 2>&1 ; then
	echo "+++ Building image under fakeroot to enforce root:wheel ownership"
	fakeroot bash -c "set -e; chown -R 0:0 '$CHERIBSD_DESTDIR_PREPARED'; ls -ln '$CHERIBSD_DESTDIR_PREPARED/etc/login.conf' '$CHERIBSD_DESTDIR_PREPARED/etc/pam.d/login' | sed 's/^/fakeroot-check: /'; '$MAKEFS_BIN' -f 1000 -o version=2 -s 512m '$CHERIBSD_ROOTFS_IMG' '$CHERIBSD_DESTDIR_PREPARED'"
else
	echo "WARNING: fakeroot not found, image will keep host ownership"
	$MAKEFS_BIN -f 1000 -o version=2 -s 512m $CHERIBSD_ROOTFS_IMG $CHERIBSD_DESTDIR_PREPARED
fi

echo "done."
