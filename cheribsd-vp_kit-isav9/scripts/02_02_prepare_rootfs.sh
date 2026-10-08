#!/bin/bash

set -e

 . config.sh

# echo "+++ Prepare rootfs"
# if ! [[ -d $CHERIBSD_DESTDIR_PREPARED ]] ; then
# 	cp -a $CHERIBSD_DESTDIR_REDUCED $CHERIBSD_DESTDIR_PREPARED
# 	pushd $CHERIBSD_DESTDIR_PREPARED 2>&1 >/dev/null
# 	sed -E 's/time=[0-9\.]+$//' METALOG > METALOG.new
# 	mv METALOG.new METALOG
# 	echo 'hostname="cheribsd-vp-kit"' > etc/rc.conf
# 	echo "/dev/md0        /       ufs     rw      1       1" > etc/fstab
# 	echo "./etc/fstab type=file uname=root gname=wheel mode=0644" >> METALOG
# 	echo "./etc/rc.conf type=file uname=root gname=wheel mode=0644" >> METALOG
# 	popd 2>&1 >/dev/null
# else
# 	echo "ALREADY BUILT?"
# fi


echo "+++ Prepare rootfs"
if ! [[ -d $CHERIBSD_DESTDIR_PREPARED ]] ; then
	cp -a $CHERIBSD_DESTDIR_REDUCED $CHERIBSD_DESTDIR_PREPARED
	pushd $CHERIBSD_DESTDIR_PREPARED 2>&1 >/dev/null
	sed -E 's/time=[0-9\.]+$//' METALOG > METALOG.new
	mv METALOG.new METALOG
	echo 'hostname="cheribsd-vp-kit"' > etc/rc.conf
	# Suppresses a lot of errors: "devmatch: Can't read linker hints file", which is not included in the rootfs image
	echo 'devmatch_enable="NO"' >> etc/rc.conf
	echo 'devd_enable="NO"' >> etc/rc.conf
	echo "/dev/md0        /       ufs     rw      1       1" > etc/fstab
	echo "./etc/fstab type=file uname=root gname=wheel mode=0644" >> METALOG
	echo "./etc/rc.conf type=file uname=root gname=wheel mode=0644" >> METALOG
	
	# Copy custom test scripts if they exist
	if [[ -d "../../custom_tests" ]] ; then
		mkdir -p opt/custom_tests
		cp -r ../../custom_tests/* opt/custom_tests/
		# Register in METALOG
		find opt/custom_tests -type f | while read file; do
			echo "./$file type=file uname=root gname=wheel mode=0755" >> METALOG
		done
		find opt/custom_tests -type d | while read dir; do
			echo "./$dir type=dir uname=root gname=wheel mode=0755" >> METALOG
		done
	fi
	# copy other files for misc tests
	mkdir -p opt/custom_files
	if [[ -d ../../custom_files ]]; then
		cp -a ../../custom_files/. opt/custom_files/
	fi
	find opt/custom_files -type f | while read file; do
		echo "./$file type=file uname=root gname=wheel mode=0755" >> METALOG
		echo "Added $file to METALOG"
	done
	
	popd 2>&1 >/dev/null
else
	echo "ALREADY BUILT?"
fi

echo "done."
