all: os_image
os_image:
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -A os_linux_0.11 -input-charset utf8 -boot-info-table -o OS_IMAGE.iso iso


os_image1:
	genisoimage -R -b boot/grub/BOOTSTRAP01.BIN -no-emul-boot -boot-load-size 4 -A os_linux_0.11 -input-charset utf8 -boot-info-table -o OS_IMAGE.iso iso
