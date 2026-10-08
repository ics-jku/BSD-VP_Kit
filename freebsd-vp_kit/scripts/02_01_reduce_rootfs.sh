#!/bin/bash

set -e

 . config.sh

echo "+++ Clean/Copy destdir"
rm -rf $FREEBSD_DESTDIR_REDUCED
rm -rf $FREEBSD_DESTDIR_PREPARED

echo "+++ Reduce size (remove unnecessary stuff: /srv /boot, debug, tests, doc, static libs)"
if ! [[ -d $FREEBSD_DESTDIR_REDUCED ]] ; then
	cp -a $FREEBSD_DESTDIR $FREEBSD_DESTDIR_REDUCED
	rm -rf $FREEBSD_DESTDIR_REDUCED/srv
	rm -rf $FREEBSD_DESTDIR_REDUCED/boot/*
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/lib/debug
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/tests
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/share/examples
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/share/man
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/share/openssl
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/share/doc
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/lib/*.a
	rm -rf $FREEBSD_DESTDIR_REDUCED/rescue/*
	rm -rf $FREEBSD_DESTDIR_REDUCED/var/tmp/*
	rm -rf $FREEBSD_DESTDIR_REDUCED/usr/include
	du -h --max-depth=1 $FREEBSD_DESTDIR_REDUCED
	cp $FREEBSD_METALOG $FREEBSD_DESTDIR_REDUCED/METALOG
else
	echo "ALREADY BUILT?"
fi

echo "done."
