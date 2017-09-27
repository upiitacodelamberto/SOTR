#!/bin/bash
apt-get clean
rm -v /var/lib/dbus/machine-id && rm -rf /tmp/*
umount -v /proc /sys /dev/pts
#exit
echo "If everything was OK you can safely exit now"
echo "If proc filesystem is not umounted, umount it using: umount --force --lazy /proc"
echo "REBOOT THE SYSTEM, COME BACK TO THIS DIRECTORY, CONTINUE WITH THE NEXT TARGET: make binarydir!!!!!!!!!!!!!!!"
#exit
