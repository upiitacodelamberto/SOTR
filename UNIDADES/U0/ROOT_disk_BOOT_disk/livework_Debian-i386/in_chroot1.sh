#!/bin/bash
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
export PS1="\e[01;31m(Debian_live_i386):\W # \e[00m"
cat /etc/mtab
#Sorry, you must do this manually: 
apt-get install dialog dbus
dbus-uuidgen > /var/lib/dbus/machine-id
#apt-get install linux-image-i386 live-boot
passwd
apt-get install binutils hwinfo less vim bvi gcc g++ gcc-multilib g++-multilib make cmake lsof psmisc
echo "Now you shoud install a linux-image (apt-cache search linux-image, choose one and)"
echo "issue apt-get intall linux-image-x.y.z live-boot" 
echo "DON'T FORGET TO INSTALL ALSO THE live-boot PACKAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#echo "Now you can install (apt-get install <debpkg_name>) and continue completing your \
#Debian live image from this point"

