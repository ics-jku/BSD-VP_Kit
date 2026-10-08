#!/bin/bash

set -e

 . config.sh

echo "+++ Normalize library directory permissions for ldconfig"
for d in \
	"$FREEBSD_DESTDIR_PREPARED/lib" \
	"$FREEBSD_DESTDIR_PREPARED/usr/lib" \
	"$FREEBSD_DESTDIR_PREPARED/usr/lib/compat"
do
	if [[ -d "$d" ]] ; then
		chmod 0755 "$d"
	fi
done

echo "+++ Create rootfs ffs/ufs image"
if command -v fakeroot >/dev/null 2>&1 ; then
	echo "+++ Building image under fakeroot to enforce root:wheel ownership"
	fakeroot bash -c "set -e; chown -R 0:0 '$FREEBSD_DESTDIR_PREPARED'; ls -ln '$FREEBSD_DESTDIR_PREPARED/etc/login.conf' '$FREEBSD_DESTDIR_PREPARED/etc/pam.d/login' | sed 's/^/fakeroot-check: /'; '$MAKEFS_BIN' -f 1000 -o version=2 -s 512m '$FREEBSD_ROOTFS_IMG' '$FREEBSD_DESTDIR_PREPARED'"
else
	echo "WARNING: fakeroot not found, image will keep host ownership"
	$MAKEFS_BIN -f 1000 -o version=2 -s 512m $FREEBSD_ROOTFS_IMG $FREEBSD_DESTDIR_PREPARED
fi

echo "done."
