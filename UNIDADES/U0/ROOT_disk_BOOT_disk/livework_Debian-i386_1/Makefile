debootstrap_wheezy_i386:
	@echo "Step 1 – Installing the necessary software. PLEASE be sure you already have installed the packages: xorriso live-build syslinux squashfs-tools"
	@echo "If these packages are not installed you will not be able to complete the iso image!!!"
#	@echo "mkdir -p -v live_Debian_i386"
	mkdir -p -v live_Debian_i386
	@echo "Please execute:"
	@echo "Step 2 – Create a basic filesystem"
	@echo "Creating a basic file system (this may take a while ...)"
	@echo "Now excute the following commands:"
#	@echo "debootstrap --arch=i386 wheezy live_Debian_i386/chroot"
	debootstrap --arch=i386 wheezy live_Debian_i386/chroot
	@echo "YOU CAN COPY THE SCRIPTS in_chroot1.sh AND in_chroot1.sh using: "
	@echo "cp -v in_chroot1.sh in_chroot1.sh live_Debian_i386/chroot/"
	@echo "AND AFTER THE CHROOT TO live_Debian_i386/chroot COMMAND EXECUTE "
	@echo "chmod u+x in_chroot1.sh && ./in_chroot1.sh"
	@echo "THINK ABOUT THE PROPPOSED AT THE END OF THE SCRIPT, PROCCEED AND AFTER THAT:"
	@echo "chmod u+x in_chroot2.sh && ./in_chroot2.sh"
	@echo "OR YOU CAN TYPE THE REST OF THE COMMANDS IN THIS STEP MANUALLY ;-)"
	@echo "Step 3 – chroot"
	@echo "Now excute:"
	@echo "chroot live_Debian_i386/chroot"
	@echo "mount none -t proc /proc"
	@echo "mount none -t sysfs /sys"
	@echo "mount none -t devpts /dev/pts"
	@echo "export HOME=/root"
	@echo "export LC_ALL=C"
	@echo "export PS1=\"\e[01;31m(Debian_live_i386):\W \# \e[00m\""
	@echo "cat /etc/mtab"
	@echo "apt-get install dialog dbus"
	@echo "dbus-uuidgen > /var/lib/dbus/machine-id"
	@echo "apt-get install linux-image-i386 live-boot"
	@echo "passwd"
	@echo "Later you can install (apt-get install <debpkg_name>) and continue completing your Debian live image from this point"
	@echo "apt-get clean"
	@echo "rm -v /var/lib/dbus/machine-id && rm -rf /tmp/*"
	@echo "umount /proc /sys /dev/pts"
	@echo "exit"
binarydir:
	mkdir -p -v live_Debian_i386/binary/live && mkdir -p live_Debian_i386/binary/isolinux
	@echo "Now manually copy your kernel to live_Debian_i386/binary/live/vmlinuz"
	@echo "and the corresponding ramdisk to live_Debian_i386/binary/live/initrd"
	@echo "For example you could do:"
	@echo "cp -v live_Debian_i386/chroot/boot/vmlinuz-3.2.0-4-X live_Debian_i386/binary/live/vmlinuz"
	@echo "cp -v live_Debian_i386/chroot/boot/initrd.img-3.2.0-4-X live_Debian_i386/binary/live/initrd"

isolinux:live_Debian_i386/binary/live/vmlinuz live_Debian_i386/binary/live/initrd
	@echo "Step 4 – ISOLINUX"
#	cd live_Debian_i386
#	cp -v chroot/boot/vmlinuz-3.2.0-4-amd64 binary/live/vmlinuz
#	cp -v chroot/boot/initrd.img-3.2.0-4-amd64 binary/live/initrd		# CAMBIAR LOS NUMERO DE VERSION
	mksquashfs live_Debian_i386/chroot live_Debian_i386/binary/live/filesystem.squashfs -comp xz -e boot
	cp -vi /usr/lib/ISOLINUX/isolinux.bin live_Debian_i386/binary/isolinux/
	cp -vi /usr/lib/syslinux/modules/bios/hdt.c32 live_Debian_i386/binary/isolinux/
	cp -vi /usr/lib/syslinux/modules/bios/ldlinux.c32 live_Debian_i386/binary/isolinux/
	cp -vi /usr/lib/syslinux/modules/bios/libcom32.c32 live_Debian_i386/binary/isolinux/
	cp -vi /usr/lib/syslinux/modules/bios/libutil.c32 live_Debian_i386/binary/isolinux/
	cp -vi /usr/lib/syslinux/modules/bios/menu.c32 live_Debian_i386/binary/isolinux/
	cp -vi isolinux.cfg live_Debian_i386/binary/isolinux/
	@echo "Step 5 – Building the iso image"
	xorriso -as mkisofs -r -J -joliet-long -l -cache-inodes -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
-partition_offset 16 -A "Debian Live"  -b isolinux/isolinux.bin -c \
isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o remaster.iso \
$(shell pwd)/live_Debian_i386/binary

grabarCD:remaster.iso
	wodim -sao -eject -v dev=/dev/sr0 remaster.iso

clean:
	rm -vf live_Debian_i386/binary/live/filesystem.squashfs

help:
	@echo "<<<<This is a basic help info of Debian_live_CD_creator>>>"
	@echo ""
	@echo "Usage:"
	@echo "     make debootstrap_wheezy_i386, make binarydir, make isolinux, make grabarCD"
	@echo "     make debootstrap_wheezy_i386 -- gives instructions to start the creation of a "
	@echo "                basic filesystem and chroot to debootstrap_wheezy_i386/chroot to make" 
	@echo "                some configand install a i386 linux image on filesystem being created."
	@echo "     make binarydir -- creates directory and two subdirectories." 
	@echo "     make isolinux  -- generate a iso image of bootable cdromi remaster.iso."
	@echo "     make grabarCD -- writes the image remaster.iso"

