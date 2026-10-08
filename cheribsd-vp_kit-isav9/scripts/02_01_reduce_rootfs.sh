#!/bin/bash

set -e

 . config.sh

echo "+++ Clean/Copy destdir"
rm -rf $CHERIBSD_DESTDIR_REDUCED
rm -rf $CHERIBSD_DESTDIR_PREPARED

echo "+++ Reduce size (remove unnecessary stuff: /srv /boot, debug, tests, doc, static libs)"
if ! [[ -d $CHERIBSD_DESTDIR_REDUCED ]] ; then
	cp -a $CHERIBSD_DESTDIR $CHERIBSD_DESTDIR_REDUCED
	rm -rf $CHERIBSD_DESTDIR_REDUCED/srv
	rm -rf $CHERIBSD_DESTDIR_REDUCED/boot/*
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/lib/debug
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/tests
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/share/examples
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/share/man
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/share/openssl
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/share/doc
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/lib/*.a
	rm -rf $CHERIBSD_DESTDIR_REDUCED/cheribsdbox.mtree
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdbox.dummy-hardlink-for-makefs
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdtest-hybrid
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdtest-hybrid-dynamic
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdtest-hybrid-dynamic-mt
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdtest-hybrid-mt
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdtest-purecap-dynamic
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/cheribsdtest-purecap-dynamic-mt
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/helloworld
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/helloworld_cxx
	rm -rf $CHERIBSD_DESTDIR_REDUCED/bin/helloworld_static
	rm -rf $CHERIBSD_DESTDIR_REDUCED/libexec/ld-elf64.so.1
	rm -rf $CHERIBSD_DESTDIR_REDUCED/libexec/ld-elf-debug.so.1
	rm -rf $CHERIBSD_DESTDIR_REDUCED/rescue/*
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/lib64/*
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/local64/*
	rm -rf $CHERIBSD_DESTDIR_REDUCED/var/tmp/*
	rm -rf $CHERIBSD_DESTDIR_REDUCED/usr/include
	du -h --max-depth=1 $CHERIBSD_DESTDIR_REDUCED
	cp $CHERIBSD_METALOG $CHERIBSD_DESTDIR_REDUCED/METALOG
else
	echo "ALREADY BUILT?"
fi

echo "done."
